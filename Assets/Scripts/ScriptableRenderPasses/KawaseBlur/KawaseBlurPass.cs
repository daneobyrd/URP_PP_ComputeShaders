using System;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses.KawaseBlur
{
    public sealed class KawaseBlurPass : ScriptableRenderPass
    {
        #region Fields

        private readonly string _profilerTag;
        private SourceType _blurSource;

        private const string KawaseBlitShaderPath = "Hidden/KawaseBlit";
        private Material _material;
        private static readonly ComputeShader _computeShader = (ComputeShader) Resources.Load("KawaseBlur/KawaseCS");
        private static int KBlur         => _computeShader.FindKernel("KBlur");
        private static int KBlurUpsample => _computeShader.FindKernel("KBlurUpsample");

        private string _sourceTexName;
        private readonly int _finalId = Shader.PropertyToID("_KawaseBlur");

        private RTHandle SourceTarget;
        private RTHandle TempBlurTarget1;
        private RTHandle TempBlurTarget2;
        private RTHandle FinalTarget;

        private int _passes;
        private bool _blitToCamera;
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
            _material         = (settings.blurMaterial != null) ? settings.blurMaterial : CoreUtils.CreateEngineMaterial(KawaseBlitShaderPath);
            _sourceTexName    = settings.srcTextureId;
            _passes           = settings.blurPasses;
            _blitToCamera     = settings.blitToCamera;
            _excludeSceneView = settings.excludeSceneView;
        }

        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            var descriptor = cameraTextureDescriptor;
            descriptor.graphicsFormat    = GraphicsFormat.B10G11R11_UFloatPack32;
            descriptor.depthBufferBits   = 0;
            descriptor.dimension         = TextureDimension.Tex2D;
            descriptor.msaaSamples       = 1;
            descriptor.enableRandomWrite = true;

            // Source texture
            if (_blurSource == SourceType.TextureID)
            {
                RenderingUtils.ReAllocateIfNeeded(ref SourceTarget, descriptor, FilterMode.Bilinear, TextureWrapMode.Clamp, name: _sourceTexName);
            }
            // Temp intermediate textures
            RenderingUtils.ReAllocateIfNeeded(ref TempBlurTarget1, descriptor, FilterMode.Bilinear, TextureWrapMode.Clamp, name: "_tempBlur1");
            RenderingUtils.ReAllocateIfNeeded(ref TempBlurTarget2, descriptor, FilterMode.Bilinear, TextureWrapMode.Clamp, name: "_tempBlur2");

            // Final texture
            RenderingUtils.ReAllocateIfNeeded(ref FinalTarget, descriptor, FilterMode.Bilinear, TextureWrapMode.Clamp, name: "_KawaseBlur");
        }

        #endregion

        #region Execution

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (_material == null)
            {
                Debug.LogErrorFormat
                (
                    "Missing {0}. {1} render pass will not execute. Check for missing reference in the renderer resources.",
                    _material, GetType().Name
                );
                return;
            }
            
            ref CameraData cameraData = ref renderingData.cameraData;

            if (cameraData.cameraType == CameraType.Preview) return;
            
            CommandBuffer cmd = CommandBufferPool.Get(_profilerTag);
            
            var sourceHandle = _blurSource == SourceType.CameraColor ? cameraData.renderer.cameraColorTargetHandle : SourceTarget;

            RenderTextureDescriptor targetDesc = cameraData.cameraTargetDescriptor;
            Vector2Int screenSize = new Vector2Int(targetDesc.width, targetDesc.height);

            if (!SystemInfo.supportsComputeShaders) return;
            ComputeKawaseBlur(cmd, screenSize, ref sourceHandle, ref TempBlurTarget1, ref TempBlurTarget2, ref FinalTarget);

            if (_blitToCamera)
            {
#if UNITY_EDITOR
                if (!IsVisibleInSceneView(cameraData, _excludeSceneView)) return;
#endif
                Blitter.BlitCameraTexture(cmd, FinalTarget, cameraData.renderer.cameraColorTargetHandle);
            }

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        private bool IsVisibleInSceneView(CameraData cameraData, bool excludeSceneView)
        {
            if (cameraData.cameraType != CameraType.SceneView) return true;
            return !excludeSceneView && CoreUtils.ArePostProcessesEnabled(cameraData.camera);
        }

        private void ComputeKawaseBlur(CommandBuffer cmd, Vector2Int size,
                                       ref RTHandle sourceRT,
                                       ref RTHandle tempRT1, ref RTHandle tempRT2,
                                       ref RTHandle finalRT)
        {
            // Linear sampling offset
            float[] offsets = {0.5f, 1.5f, 2.5f, 2.5f, 3.5f};

            // Downsample size by shifting right one bit
            var smallWidth = size.x >> 1;
            var smallHeight = size.y >> 1;
            Vector4 downsampledSize = new Vector4(smallWidth, smallHeight, 1f / smallWidth, 1f / smallHeight);
            
            Vector4 fullSize = new Vector4(size.x, size.y, 1f / size.x, 1f / size.y);

            var doubleWidth = size.x << 1;
            var doubleHeight = size.y << 1;
            Vector4 upsampleSize = new Vector4(doubleWidth, doubleHeight, 1f / doubleWidth, 1f / doubleHeight);
            
            // Set dispatch threadGroups to downsampled size.
            Vector2Int numthreads = new Vector2Int(smallWidth >> 3, smallHeight >> 3) + Vector2Int.one;
            // Vector2Int numthreads = new(Mathf.CeilToInt(size.x/16f) + 1,  // size.x/16 (size.x >> 4)
                                        // Mathf.CeilToInt(size.y/16f) + 1); // size.y/16 (size.y >> 4)

            using (new ProfilingScope(cmd, new ProfilingSampler("Downsample")))
            {
                // Set size CS parameter to downsampled size
                cmd.SetComputeVectorParam(_computeShader, "size", downsampledSize);

                // Pass 1
                cmd.SetComputeFloatParam(_computeShader, "offset", offsets[0]);
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Source", sourceRT);
                cmd.SetComputeTextureParam(_computeShader, KBlur, "_Result", tempRT1);

                cmd.DispatchCompute(_computeShader, KBlur, numthreads.x, numthreads.y, 1);
            }

            using (new ProfilingScope(cmd, new ProfilingSampler("Blur Passes")))
            {
                // Pass 2
                // Set size to full-size for correct texel_size
                cmd.SetComputeVectorParam(_computeShader, "size", fullSize);
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
            }

            using (new ProfilingScope(cmd, new ProfilingSampler("Bilinear Upsample")))
            {
                /* Upsample Pass */

                numthreads   = new Vector2Int(size.x >> 3, size.y >> 3) + Vector2Int.one;
                // numthreads.x = Mathf.CeilToInt(size.x / 8f) + 1;
                // numthreads.y = Mathf.CeilToInt(size.y / 8f) + 1;

                bool isEven = _passes % 2 == 0;

                // var upsampleRT = isEven ? tempRT2 : tempRT1;
                var upsampleRT = tempRT1; // always true because textures do not swap on last pass

                // Set size to upsampleSize (2x) for correct texel_size
                cmd.SetComputeVectorParam(_computeShader, "size", upsampleSize);
                cmd.SetComputeTextureParam(_computeShader, KBlurUpsample, "_Source", upsampleRT.nameID);
                cmd.SetComputeTextureParam(_computeShader, KBlurUpsample, "_Result", finalRT.nameID);

                cmd.DispatchCompute(_computeShader, KBlurUpsample, numthreads.x, numthreads.y, 1);
                cmd.SetGlobalTexture(_finalId, finalRT.nameID);
                
                ConfigureTarget(finalRT);
            }
        }

        #endregion

        #region Cleanup

        public void Dispose()
        {
            SourceTarget?.Release();
            TempBlurTarget2?.Release();
            TempBlurTarget1?.Release();
            FinalTarget?.Release();
        }

        #endregion
    }
}