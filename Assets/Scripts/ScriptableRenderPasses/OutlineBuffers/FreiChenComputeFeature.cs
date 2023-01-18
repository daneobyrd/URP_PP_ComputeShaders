/*using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.XR;

public class FreiChenComputeFeature : ScriptableRendererFeature
{
    public enum InjectionPoint
    {
        BeforeRenderingTransparents = RenderPassEvent.BeforeRenderingTransparents,
        BeforeRenderingPostProcessing = RenderPassEvent.BeforeRenderingPostProcessing,
        AfterRenderingPostProcessing = RenderPassEvent.AfterRenderingPostProcessing
    }
    
    public Material stdMaterial;
    public Material passMaterial;
    public InjectionPoint injectionPoint = InjectionPoint.AfterRenderingPostProcessing;
    public ScriptableRenderPassInput requirements = ScriptableRenderPassInput.Color;
    [HideInInspector] // We draw custom pass index entry with the dropdown inside FullScreenPassRendererFeatureEditor.cs
    public int passIndex = 0;

    public ComputeShader _freiChenCs;

    private FreiChenComputePass _freiChenComputePass;
    private bool requiresColor;
    private bool injectedBeforeTransparents;

    public override void Create()
    {
        _freiChenComputePass                 = new FreiChenComputePass();
        _freiChenComputePass.renderPassEvent = (RenderPassEvent) injectionPoint;

        // This copy of requirements is used as a parameter to configure input in order to avoid copy color pass
        ScriptableRenderPassInput modifiedRequirements = requirements;
        requiresColor              = (requirements & ScriptableRenderPassInput.Color) != 0;
        injectedBeforeTransparents = injectionPoint <= InjectionPoint.BeforeRenderingTransparents;

        if (requiresColor && !injectedBeforeTransparents)
        {
            // Removing Color flag in order to avoid unnecessary CopyColor pass
            // Does not apply to before rendering transparents, due to how depth and color are being handled until
            // that injection point.
            modifiedRequirements ^= ScriptableRenderPassInput.Color;
        }

        _freiChenComputePass.ConfigureInput(modifiedRequirements);
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!stdMaterial || !passMaterial)
        {
            Debug.LogWarningFormat("Missing Post Processing effect Material. {0} Fullscreen pass will not execute. Check for missing reference in the assigned renderer.", GetType().Name);
            return;
        }

        _freiChenComputePass.Setup(passMaterial, passIndex, requiresColor, _freiChenCs, default, "FullScreenPassRendererFeature", renderingData);

        renderer.EnqueuePass(_freiChenComputePass);
    }

    protected override void Dispose(bool disposing) { _freiChenComputePass.Dispose(); }

    class FreiChenComputePass : ScriptableRenderPass
    {
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

        public void Setup(Material mat, int index, bool requiresColor, ComputeShader computeShader, bool isBeforeTransparents, string featureName, in RenderingData renderingData)
        {
            m_PassMaterial         =   mat;
            m_PassIndex            =   index;
            m_RequiresColor        =   requiresColor;
            m_ComputeShader        =   computeShader;
            m_IsBeforeTransparents =   isBeforeTransparents;
            m_ProfilingSampler     ??= new ProfilingSampler(featureName);

            var colorCopyDescriptor = renderingData.cameraData.cameraTargetDescriptor;
            colorCopyDescriptor.depthBufferBits = (int) DepthBits.None;
            if (colorCopyDescriptor.useDynamicScale)
            {
                colorCopyDescriptor.width  *= (int) ScalableBufferManager.widthScaleFactor;
                colorCopyDescriptor.height *= (int) ScalableBufferManager.heightScaleFactor;
            }

            RenderingUtils.ReAllocateIfNeeded(ref m_CopiedColor, colorCopyDescriptor, name: "_FullscreenPassColorCopy");

            var cs_UAV_Descriptor = colorCopyDescriptor;
            cs_UAV_Descriptor.enableRandomWrite = true;
            cs_UAV_Descriptor.msaaSamples       = 1;

            var stdDevDescriptor = colorCopyDescriptor;
            stdDevDescriptor.mipCount    = 8;
            stdDevDescriptor.useMipMap   = true;
            stdDevDescriptor.colorFormat = RenderTextureFormat.ARGBHalf;

            RenderingUtils.ReAllocateIfNeeded(ref m_StdDevHandle, stdDevDescriptor, name: m_StdDevTex);
            RenderingUtils.ReAllocateIfNeeded(ref m_OutlineHandle, cs_UAV_Descriptor, name: m_OutlineTex);

            m_PassData ??= new PassData();
        }

        public void Dispose()
        {
            m_CopiedColor?.Release();
            m_StdDevHandle?.Release();
            m_OutlineHandle?.Release();
        }

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

        // RG friendly method
        private static void ExecutePass(PassData passData, ref RenderingData renderingData, ref ScriptableRenderContext context)
        {
            var passMaterial = passData.effectMaterial;
            var passIndex = passData.passIndex;
            var requiresColor = passData.requiresColor;
            var isBeforeTransparents = passData.isBeforeTransparents;
            var copiedColor = passData.copiedColor;
            var profilingSampler = passData.profilingSampler;
            var computeShader = passData.computeShader;

            if (passMaterial == null)
            {
                // should not happen as we check it in feature
                return;
            }

            if (renderingData.cameraData.isPreviewCamera)
            {
                return;
            }

            ref var cameraData = ref renderingData.cameraData;

            CommandBuffer cmd = CommandBufferPool.Get("_FreiChenComputePass");
            cmd.SetGlobalTexture(m_StdDevTexShaderID, m_StdDevHandle.nameID);
            
            FreiChenCompute(cmd, computeShader, ref renderingData);


            using (new ProfilingScope(cmd, profilingSampler))
            {
                if (requiresColor)
                {
                    // For some reason BlitCameraTexture(cmd, dest, dest) scenario (as with before transparents effects) blitter fails to correctly blit the data
                    // Sometimes it copies only one effect out of two, sometimes second, sometimes data is invalid (as if sampling failed?).
                    // Adding RTHandle in between solves this issue.
                    // var source = isBeforeTransparents ? k_CameraTarget : cameraData.renderer.cameraColorTargetHandle;

                    // Blitter.BlitCameraTexture(cmd, source, copiedColor);
                    passMaterial.SetTexture(m_BlitTextureShaderID, copiedColor.rt);
                }

                // CoreUtils.SetRenderTarget(cmd, cameraData.renderer.cameraColorTargetHandle);
                // CoreUtils.DrawFullScreen(cmd, passMaterial);
                context.ExecuteCommandBuffer(cmd);
                cmd.Clear();
            }
        }

        static void FreiChenCompute(CommandBuffer cmd, ComputeShader computeShader, ref RenderingData renderingData)
        {
            ref var cameraData = ref renderingData.cameraData;

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

            // Number of thread groups
            // 1920x1080  :  dispatch(240, 135)
            // 2560x1440  :  dispatch(320, 180)
            // 3840x2160  :  dispatch(480, 270)
            var dispatch = new Vector2Int
            (
                screenDesc.width >> 3, // same as Mathf.CeilToInt(width / 8f)
                screenDesc.height >> 3 // same as Mathf.CeilToInt(height / 8f)
            );
            
            // var kFreiChen = _computeShader.FindKernel("KFreiChen");
            // var vFreiChen = _computeShader.FindKernel("KFreiChenGeneralizedVector");
            var sFreiChen = computeShader.FindKernel("KFreiChenGeneralizedScalar");

            // Change SubspaceTarget to Texture2D
            cmd.SetComputeVectorParam(computeShader, "_Size", size);
            cmd.SetComputeTextureParam(computeShader, sFreiChen, "Source", cameraData.renderer.cameraColorTargetHandle.nameID, 0);
            cmd.SetComputeTextureParam(computeShader, sFreiChen, "stdDevTexCS", m_StdDevHandle.nameID, 0);
            cmd.SetComputeTextureParam(computeShader, sFreiChen, "Result", m_OutlineHandle.nameID, 0);
            cmd.DispatchCompute(computeShader, sFreiChen, dispatch.x, dispatch.y, 1);
            
            // ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            // Set global texture _OutlineTexture with Computed edge data.
            // ---------------------------------------------------------------------------------------------------------------------------------------
            cmd.SetGlobalTexture(m_OutlineTexShaderID, m_OutlineHandle.nameID);
        }

        public class PassData
        {
            internal Material effectMaterial;
            internal int passIndex;
            internal bool requiresColor;
            internal bool isBeforeTransparents;
            // public ProfilingSampler profilingSampler;
            // public RTHandle copiedColor;
            public ComputeShader computeShader;
        }
    }
}*/