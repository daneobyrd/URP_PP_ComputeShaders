using System.Reflection;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
    /*
    public class FreiChenPass : ScriptableRenderPass
    {
        private string _profilerTag;
        private Material m_PassMaterial;
        private int m_PassIndex;
        private bool m_RequiresColor;
        private bool m_IsBeforeTransparents;
        public PassData m_PassData;
        private ProfilingSampler m_ProfilingSampler;
        private RTHandle m_CopiedColor;
        private static readonly int m_BlitTextureShaderID = Shader.PropertyToID("_BlitTexture");

        private ComputeShader m_ComputeShader;
        private static readonly string m_StdDevTex = "_StdDevTex";
        private static readonly int m_StdDevTexShaderID = Shader.PropertyToID(m_StdDevTex);
        private static readonly string m_OutlineTex = "_FreiChenTexture";
        private static readonly int m_OutlineTexShaderID = Shader.PropertyToID(m_OutlineTex);
        
        private static RTHandle m_StdDevHandle;
        private static RTHandle m_OutlineHandle;
        
        public FreiChenPass(){}
        
        public void Setup(ComputeShader computeShader,
                          Material mat, int index,
                          bool requiresColor, bool isBeforeTransparents,
                          string featureName, in RenderingData renderingData)

        {
            _profilerTag = featureName;

            var colorCopyDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            if (colorCopyDescriptor.useDynamicScale)
            {
                colorCopyDescriptor.width  *= (int) ScalableBufferManager.widthScaleFactor;
                colorCopyDescriptor.height *= (int) ScalableBufferManager.heightScaleFactor;
            }
            
            colorCopyDescriptor.msaaSamples       = 1;
            colorCopyDescriptor.depthBufferBits   = (int) DepthBits.None;;
            colorCopyDescriptor.enableRandomWrite = true;
            // colorCopyDescriptor.dimension         = TextureDimension.Tex2D;
            // colorCopyDescriptor.colorFormat       = RenderTextureFormat.ARGBFloat;
            
            var stdDevDescriptor = colorCopyDescriptor;
            stdDevDescriptor.mipCount    = 8;
            stdDevDescriptor.useMipMap   = true;
            stdDevDescriptor.colorFormat = RenderTextureFormat.ARGBHalf;

            var cs_UAV_Descriptor = colorCopyDescriptor;
            cs_UAV_Descriptor.enableRandomWrite = true;
            cs_UAV_Descriptor.msaaSamples       = 1;

            RenderingUtils.ReAllocateIfNeeded(ref k_CameraTarget, colorCopyDescriptor, name: "_FullscreenPassColorCopy");
            RenderingUtils.ReAllocateIfNeeded(ref m_StdDevHandle, stdDevDescriptor, name: "_Fullscreen" + m_StdDevTex);
            RenderingUtils.ReAllocateIfNeeded(ref m_OutlineHandle, cs_UAV_Descriptor, name: "_Fullscreen" + m_OutlineTex);
            
            m_PassData ??= new PassData();
        }
        
        public void Dispose()
        {
            m_CopiedColor?.Release();
            m_StdDevHandle?.Release();
            m_OutlineHandle?.Release();
        }
        
        /*
        static void DrawQuad(CommandBuffer cmd, Material material, int shaderPass)
        {
            if (SystemInfo.graphicsShaderLevel < 30)
                cmd.DrawMesh(RenderingUtils.fullscreenMesh, Matrix4x4.identity, material, 0, shaderPass);
            else
                cmd.DrawProcedural(Matrix4x4.identity, material, shaderPass, MeshTopology.Quads, 4);
        }
        #1#

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            m_PassData.effectMaterial       = m_PassMaterial;
            m_PassData.passIndex            = m_PassIndex;
            m_PassData.requiresColor        = m_RequiresColor;
            m_PassData.isBeforeTransparents = m_IsBeforeTransparents;
            m_PassData.profilingSampler     = m_ProfilingSampler;
            m_PassData.copiedColor          = m_CopiedColor;
                
            m_PassData.computeShader = m_ComputeShader;
                
            ExecutePass(m_PassData, ref renderingData, ref context);
        }

        public void ExecutePass(PassData passData, ref RenderingData renderingData, ref ScriptableRenderContext context)
        {
            ref CameraData cameraData = ref renderingData.cameraData;
            if (cameraData.camera.cameraType != CameraType.Game) return;
            if (m_PassMaterial == null) return;
            
            var screenDesc = cameraData.cameraTargetDescriptor;
            if (screenDesc.useDynamicScale)
            {
                screenDesc.width  *= (int) ScalableBufferManager.widthScaleFactor;
                screenDesc.height *= (int) ScalableBufferManager.heightScaleFactor;
            }
            
            float width = screenDesc.width;
            float height = screenDesc.height;
            
            screenDesc.depthBufferBits   = 0;
            screenDesc.enableRandomWrite = true;
            
            var size = new Vector4(width, height, 1 / width, 1 / height);
            
            // 1920x1080  :  dispatch(240, 135)
            // 2560x1440  :  dispatch(320, 180)
            // 3840x2160  :  dispatch(480, 270)
            var dispatch = new Vector2Int
            (
                screenDesc.width << 3, // same as Mathf.CeilToInt(width / 8f)
                screenDesc.height << 3 // same as Mathf.CeilToInt(height / 8f)
            );
            
            CommandBuffer cmd = CommandBufferPool.Get(_profilerTag);
            cmd.BeginSample(_profilerTag);
            
            #region Standard Deviation
            
            // Each 8x8 ThreadGroup reads a 16x16 pixel grid, but only writes to an 8x8 grid.
            // Adjacent ThreadGroups overlap pixel reads.
            // The right half of the pixels read by group (0,0,0) will be read by group(1,0,0).

            // cmd.SetViewProjectionMatrices(renderingData.cameraData.camera.worldToCameraMatrix, renderingData.cameraData.camera.projectionMatrix);
            // cmd.Blit(new RenderTargetIdentifier(BuiltinRenderTextureType.CameraTarget), _source, m_PassMaterial, 0);
            // cmd.DrawMesh(RenderingUtils.fullscreenMesh, Matrix4x4.identity, _material, default, 0);
            // DrawQuad(cmd, _material, 0);            
            // cmd.SetGlobalTexture(_sourceId, _source);

            /*
            // Create _CameraOpaqueTexture with 4 pixels of padding for 9x9 Frei Chen filter
            Blitter.BlitQuadWithPadding(cmd, source: renderingData.cameraData.targetTexture,
                                             textureSize: new Vector2(width, height),
                                             scaleBiasTex: Vector4.one,
                                             scaleBiasRT: Vector4.one,
                                             mipLevelTex: 0,
                                             bilinear: false,
                                             paddingInPixels: 4);
                                             #1#
            
            // Pixel Shader Standard Deviation
            // cmd.SetViewProjectionMatrices(renderingData.cameraData.camera.worldToCameraMatrix, renderingData.cameraData.camera.projectionMatrix);
            // cmd.Blit(_source, StdDevTargetId, m_PassMaterial, 1);
            // cmd.DrawMesh(RenderingUtils.fullscreenMesh, Matrix4x4.identity, _material, default, 1);
            
            // cmd.SetGlobalTexture(StdDevId, StdDevTargetId);

            #endregion
            
            FreiChenCompute(cmd, ref renderingData, size, dispatch);
            
            cmd.EndSample(_profilerTag);
            context.ExecuteCommandBuffer(cmd);
            // cmd.Clear();
            CommandBufferPool.Release(cmd);
        }
        
        void FreiChenCompute(CommandBuffer cmd, ref RenderingData renderingData, Vector4 size, Vector2Int dispatch)
        {
            #region Frei Chen
            
            // var kFreiChen = _computeShader.FindKernel("KFreiChen");
            // var vFreiChen = _computeShader.FindKernel("KFreiChenGeneralizedVector");
            var sFreiChen = m_ComputeShader.FindKernel("KFreiChenGeneralizedScalar");
            
            // Change SubspaceTarget to Texture2D
            cmd.SetComputeVectorParam(m_ComputeShader, "_Size", size);
            
            cmd.SetComputeTextureParam(m_ComputeShader, sFreiChen, "Source", k_CameraTarget.nameID, 0);
            cmd.SetComputeTextureParam(m_ComputeShader, sFreiChen, "stdDevTexCS", m_StdDevHandle.nameID, 0);
            cmd.SetComputeTextureParam(m_ComputeShader, sFreiChen, "Result", m_OutlineHandle.nameID, 0);
            cmd.DispatchCompute(m_ComputeShader, sFreiChen, dispatch.x, dispatch.y, 1);
            
            // ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            // Set global texture _OutlineTexture with Computed edge data.
            // ---------------------------------------------------------------------------------------------------------------------------------------
            cmd.SetGlobalTexture(m_OutlineTexShaderID, m_OutlineHandle.nameID);
            
            // ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            // Draw _OutlineTexture to the screen
            // ---------------------------------------------------------------------------------------------------------------------------------------
            
            cmd.SetViewProjectionMatrices(renderingData.cameraData.camera.worldToCameraMatrix, renderingData.cameraData.camera.projectionMatrix);
            // cmd.DrawMesh(RenderingUtils.fullscreenMesh, Matrix4x4.identity, _material, default, 1);
            Blit(cmd, ref renderingData, m_PassMaterial, 2);
            #endregion
        }

        public class PassData
        {
            public Material effectMaterial;
            public int passIndex;
            public bool requiresColor;
            public bool isBeforeTransparents;
            public ProfilingSampler profilingSampler;
            public RTHandle copiedColor;
            public ComputeShader computeShader;
        }
    }
*/
}