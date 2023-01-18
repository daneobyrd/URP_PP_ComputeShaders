/*using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses.KawaseBlur
{
    public sealed class KawaseBlurPass : ScriptableRenderPass
    {
        #region Fields

        private readonly string _profilerTag;
        private SourceType _blurSource;

        private Material _material;
        private static readonly ComputeShader _computeShader = (ComputeShader) Resources.Load("KawaseBlur/KawaseCS");
        private static int KBlur         => _computeShader.FindKernel("KBlur");
        private static int KBlurUpsample => _computeShader.FindKernel("KBlurUpsample");
        
        private int _sourceId;
        private readonly int _tempBlurId1 = Shader.PropertyToID("_tempBlur1");
        private readonly int _tempBlurId2 = Shader.PropertyToID("_tempBlur2");
        private readonly int _finalId = Shader.PropertyToID("_KawaseBlur");

        private RenderTargetIdentifier SourceTarget     => new(_sourceId);
        private RenderTargetIdentifier DownsampleTarget => new(_tempBlurId1);
        private RenderTargetIdentifier BlurTarget       => new(_tempBlurId2);
        private RenderTargetIdentifier FinalTarget      => new(_finalId);

        private int _passes;
        private bool _isBlitPass;
        private bool _excludeSceneView;

        #endregion

        #region Constructor

        public KawaseBlurPass(string profilerTag, RenderPassEvent renderPassEvent)
        {
            _profilerTag         = profilerTag;
            this.renderPassEvent = renderPassEvent;
        }

        #endregion

        #region State

        public void Setup(KawaseBlurSettings settings)
        {
            _blurSource       = settings.blurSource;
            _sourceId         = Shader.PropertyToID(settings.srcTextureId);
            _material         = settings.blurMaterial;
            _passes           = settings.blurPasses;
            _isBlitPass       = settings.isBlitPass;
            _excludeSceneView = settings.excludeSceneView;
        }

        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            var camTexDesc = cameraTextureDescriptor;
            camTexDesc.colorFormat       = RenderTextureFormat.ARGB32;
            camTexDesc.msaaSamples       = 1;
            camTexDesc.enableRandomWrite = true;

            // Source texture
            cmd.GetTemporaryRT(_sourceId, camTexDesc, FilterMode.Bilinear);
            // Temp intermediate textures
            cmd.GetTemporaryRT(_tempBlurId1, camTexDesc, FilterMode.Bilinear);
            cmd.GetTemporaryRT(_tempBlurId2, camTexDesc, FilterMode.Bilinear);
            // Final texture
            cmd.GetTemporaryRT(_finalId, camTexDesc, FilterMode.Bilinear);

            if (_blurSource != SourceType.CameraColor) return;
            // Configures this pass' SV_Target0 to FinalTarget. But I'm ignoring that, this is just the easiest way to clear the RT.
            ConfigureTarget(FinalTarget);
            ConfigureClear(ClearFlag.Color, Color.clear);
        }

        #endregion

        #region Execution

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (_material == null)
            {
                Debug.LogErrorFormat(
                    "Missing {0}. {1} render pass will not execute. Check for missing reference in the renderer resources.",
                    _material, GetType().Name);
                return;
            }

            CommandBuffer cmd = CommandBufferPool.Get(_profilerTag);

            CameraData cameraData = renderingData.cameraData;

            RTHandle cameraColorTexture = cameraData.renderer.cameraColorTargetHandle;
            RenderTextureDescriptor targetDesc = cameraData.cameraTargetDescriptor;
            targetDesc.enableRandomWrite = true;

            Vector2Int screenSize = new Vector2Int(targetDesc.width, targetDesc.height);

            var sourceRT = (_blurSource == SourceType.CameraColor) ? cameraColorTexture : SourceTarget;

            if (!SystemInfo.supportsComputeShaders) return;
            ComputeKawaseBlur(cmd, screenSize,
                             sourceRT,
                             DownsampleTarget,
                             BlurTarget,
                             FinalTarget);

            if (_isBlitPass)
            {
#if UNITY_EDITOR
                switch (cameraData)
                {
                    case {cameraType: CameraType.SceneView} when _excludeSceneView:
                    case {cameraType: CameraType.SceneView} when !CoreUtils.ArePostProcessesEnabled(cameraData.camera):
                        return;
                    default:
                        Blit(cmd, ref renderingData, _material, 0);
                        // context.DrawRenderers(new CullingResults()cameraData.renderer, _material);
                        break;
                }
#else
                Blit(cmd, ref renderingData, _material, 0);
#endif
            }

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        private void ComputeKawaseBlur(CommandBuffer cmd, Vector2Int size,
                                      RenderTargetIdentifier sourceRT,
                                      RenderTargetIdentifier tempRT1,
                                      RenderTargetIdentifier tempRT2,
                                      RenderTargetIdentifier finalRT)
        {

            // Linear sampling offset
            float[] offsets = {0.5f, 1.5f, 2.5f, 2.5f, 3.5f};

            // Downsample size by shifting right one bit
            var width = size.x >> 1;
            var height = size.y >> 1;
            // Set dispatch threadGroups to downsampled size.
            Vector2Int numthreads = default;
            numthreads.x = Mathf.CeilToInt(width / 8f);
            numthreads.y = Mathf.CeilToInt(height / 8f);

            // Set size to downsampled size
            cmd.SetComputeVectorParam(_computeShader, "size", new Vector4(width, height, 0, 0));

            // Pass 1
            cmd.SetComputeFloatParam(_computeShader, "offset", offsets[0]);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", sourceRT);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT1);

            cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);

            // Pass 2
            // Set size to full-size for correct texel_size
            cmd.SetComputeVectorParam(_computeShader, "size", new Vector4(size.x, size.y, 0, 0));
            cmd.SetComputeFloatParam(_computeShader, "offset", offsets[1]);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", tempRT1);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT2);

            cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);

            // Passes 3-5
            for (uint i = 2; i < _passes; i++)
            {
                cmd.SetComputeFloatParam(_computeShader, "offset", offsets[i]);
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", tempRT2);
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT1);

                cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);
                
                // Do not swap after final pass
                if (i == _passes) return;
                CoreUtils.Swap(ref tempRT1, ref tempRT2);
            }

            /#1#/ Pass 3
            cmd.SetComputeFloatParam(_computeShader, "offset", offsets[2]);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", tempRT2);
            cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT1);

            cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);

            if (_passes > 3)
            {
                // Pass 4
                cmd.SetComputeFloatParam(_computeShader, "offset", offsets[3]); // same offset for pass 3 and 4: 2.5
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", tempRT1);
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT2);

                cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);

                if (_passes > 4)
                {
                    // Pass 5
                    cmd.SetComputeFloatParam(_computeShader, "offset", offsets[4]);
                    cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", tempRT2);
                    cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT1);

                    cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);
                }
            }#1#

            /* Upsample Pass #1#

            numthreads.x = Mathf.CeilToInt(size.x / 8f);
            numthreads.y = Mathf.CeilToInt(size.y / 8f);

            bool isEven = _passes % 2 == 0;

            // var upsampleRT = isEven ? tempRT2 : tempRT1;
            var upsampleRT = tempRT1;
            
            // I can't remember why but the upsample 'size' had to be twice the size of the sourceTarget
            cmd.SetComputeVectorParam(_computeShader, "size", new Vector4(size.x << 1, size.y << 1, 0, 0));
            cmd.SetComputeTextureParam(_computeShader, KBlurUpsample, "_Source", upsampleRT);
            cmd.SetComputeTextureParam(_computeShader, KBlurUpsample, "_Result", finalRT);

            cmd.DispatchCompute(_computeShader, KBlurUpsample, numthreads.x, numthreads.y, 1);
            cmd.SetGlobalTexture(_finalId, finalRT, RenderTextureSubElement.Color);
        }

        #endregion

        #region Cleanup

        public override void FrameCleanup(CommandBuffer cmd)
        {
            if (cmd == null)
                throw new ArgumentNullException(nameof(cmd));

            cmd.ReleaseTemporaryRT(_sourceId);
            cmd.ReleaseTemporaryRT(_tempBlurId1);
            cmd.ReleaseTemporaryRT(_tempBlurId2);
            cmd.ReleaseTemporaryRT(_finalId);
        }

        #endregion
    }
}*/