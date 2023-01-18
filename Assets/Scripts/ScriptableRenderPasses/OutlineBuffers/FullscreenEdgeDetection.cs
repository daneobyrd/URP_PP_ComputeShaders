﻿ using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses.OutlineBuffers
{
    [Serializable]
    public enum EdgeDetectionMethod
    {
        Laplacian = 0,
        Sobel = 1,
        FreiChen = 2,
        FreiChenGeneralized = 3
    }

    /*
    public class FullscreenEdgeDetection : ScriptableRenderPass
    {
        private string _profilerTag;
        private Material _material;
        private int _passIndex;

        private ComputeShader _computeShader;
        private EdgeDetectionMethod _method;

        private int _sourceId; // _BlurredUpsampleResults or _OutlineOpaqueColor
        private RenderTargetIdentifier _sourceTarget;

        private static int                    outlineId     => Shader.PropertyToID("_OutlineTexture");
        private static RenderTargetIdentifier outlineTarget => new(outlineId);

        #region Constructor & Setup Functions

        public FullscreenEdgeDetection(RenderPassEvent evt, string name)
        {
            // base.profilingSampler = new ProfilingSampler(name);
            _profilerTag    = name;
            renderPassEvent = evt;
        }

        public void Setup(string sourceTexture, ComputeShader computeShader, EdgeDetectionMethod method)
        {
            _sourceId      = Shader.PropertyToID(sourceTexture);
            _sourceTarget  = new RenderTargetIdentifier(_sourceId);
            _computeShader = computeShader;
            _method        = method;
        }

        public void Setup(int sourceID, ComputeShader computeShader, EdgeDetectionMethod method)
        {
            _sourceId      = sourceID;
            _sourceTarget  = new RenderTargetIdentifier(_sourceId);
            _computeShader = computeShader;
            _method        = method;
        }

        public void InitMaterial(Material initMaterial, int passIndex)
        {
            _material  = initMaterial;
            _passIndex = passIndex;
        }

        #endregion

        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            RenderTextureDescriptor camTexDesc = cameraTextureDescriptor;
            var width = camTexDesc.width;
            var height = camTexDesc.height;
            camTexDesc.msaaSamples       = 1;
            camTexDesc.depthBufferBits   = 0;
            camTexDesc.enableRandomWrite = true;
            // camTexDesc.sRGB              = _sourceColorSpace == RenderTextureReadWrite.sRGB;

            cmd.GetTemporaryRT(_sourceId, camTexDesc, FilterMode.Point);

            cmd.GetTemporaryRT(outlineId, camTexDesc, FilterMode.Point);
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            ref CameraData cameraData = ref renderingData.cameraData;
            // if (cameraData.camera.cameraType != CameraType.Game)
            //     return;
            if (_material == null)
                return;

            CommandBuffer cmd = CommandBufferPool.Get(_profilerTag);

            RenderTextureDescriptor cameraTargetDescriptor = cameraData.cameraTargetDescriptor;
            float width = cameraTargetDescriptor.width;
            float height = cameraTargetDescriptor.height;
            cameraTargetDescriptor.depthBufferBits   = 0;
            cameraTargetDescriptor.enableRandomWrite = true;
            var camSize = new Vector4(width, height, 1 / width, 1 / height);


            #region Compute Edges

            string methodString = null;
            Vector2Int numthreads = default;

            switch (_method)
            {
                case EdgeDetectionMethod.Laplacian:
                {
                    methodString = "KLaplacian";
                    numthreads.x = Mathf.CeilToInt(width / 32f);
                    numthreads.y = Mathf.CeilToInt(height / 32f);
                    break;
                }
                case EdgeDetectionMethod.FreiChen:
                {
                    methodString = "KFreiChen";
                    numthreads.x = Mathf.CeilToInt(width / 8f);
                    numthreads.y = Mathf.CeilToInt(height / 8f);
                    break;
                }
                case EdgeDetectionMethod.Sobel:
                    methodString = "KSobel";
                    break;
                case EdgeDetectionMethod.FreiChenGeneralized:
                    methodString = "KFreiChenGeneralized";
                    numthreads.x = Mathf.CeilToInt(width / 8f);
                    numthreads.y = Mathf.CeilToInt(height / 8f);
                    break;
                // default:
                //     throw new ArgumentOutOfRangeException();
            }

            var edgeKernel = _computeShader.FindKernel(methodString);

            cmd.SetComputeVectorParam(_computeShader, "_Size", camSize);
            cmd.SetComputeTextureParam(_computeShader, edgeKernel, "Source", _sourceTarget, 0);
            cmd.SetComputeTextureParam(_computeShader, edgeKernel, "Result", outlineTarget, 0);
            cmd.DispatchCompute(_computeShader, edgeKernel, numthreads.x, numthreads.y, 1);


            // ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            // Set global texture _OutlineTexture with Computed edge data.
            // ---------------------------------------------------------------------------------------------------------------------------------------
            cmd.SetGlobalTexture(outlineId, outlineTarget);

            #endregion

            // ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            // Draw _OutlineTexture to the screen
            // ---------------------------------------------------------------------------------------------------------------------------------------
            
            // cmd.SetViewProjectionMatrices(Matrix4x4.identity, Matrix4x4.identity);
            // Blitter.BlitCameraTexture(cmd, colorAttachmentHandle, colorAttachmentHandle, _material, false);
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        public override void OnCameraCleanup(CommandBuffer cmd)
        {
            if (_sourceId != -1) cmd.ReleaseTemporaryRT(_sourceId);
            if (outlineId != -1) cmd.ReleaseTemporaryRT(outlineId);
        }
    }
        */
}
