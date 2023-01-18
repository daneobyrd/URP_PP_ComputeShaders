/*using System.Collections.Generic;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
    public static class BuiltinRTTypeSupport
    {
        // From ScreenSpaceAmbientOcclusion.cs
        // bool isRendererDeferred(ScriptableRenderer m_Renderer) => m_Renderer != null && m_Renderer is UniversalRenderer && ((UniversalRenderer)m_Renderer).renderingMode == RenderingMode.Deferred;
     
        // Adapted From ScreenSpaceAmbientOcclusionEditor
        private static bool RendererIsDeferred()
        {

            var urp = UniversalRenderPipeline.asset;
            var rendererData = urp.LoadBuiltinRendererData(); // Find replacement, this generates a new urp renderer asset in the root folder.
            return rendererData is UniversalRendererData {renderingMode: RenderingMode.Deferred};
        }
        
        // Based on RenderingUtils.m_RenderTextureFormatSupport
        /*private static bool SupportsBuiltinRTType(BuiltinRenderTextureType type)
        {
            switch (type)
            {
                case BuiltinRenderTextureType.BufferPtr:
                case BuiltinRenderTextureType.PropertyName:
                case BuiltinRenderTextureType.RenderTexture:
                case BuiltinRenderTextureType.BindableTexture:
                case BuiltinRenderTextureType.CurrentActive:
                    return true;
                case BuiltinRenderTextureType.CameraTarget:
                    return UniversalRenderPipeline.asset.supportsCameraOpaqueTexture;
                case BuiltinRenderTextureType.Depth:
                case BuiltinRenderTextureType.DepthNormals:
                    return UniversalRenderPipeline.asset.supportsCameraDepthTexture;
                case BuiltinRenderTextureType.Reflections:
                    return SupportedRenderingFeatures.active.reflectionProbes;
                case BuiltinRenderTextureType.MotionVectors:
                    return SupportedRenderingFeatures.active.motionVectors;

                case BuiltinRenderTextureType.ResolvedDepth:
                case BuiltinRenderTextureType.PrepassNormalsSpec:
                case BuiltinRenderTextureType.PrepassLight:
                case BuiltinRenderTextureType.GBuffer0:
                case BuiltinRenderTextureType.GBuffer1:
                case BuiltinRenderTextureType.GBuffer2:
                case BuiltinRenderTextureType.GBuffer3:
                case BuiltinRenderTextureType.GBuffer4:
                case BuiltinRenderTextureType.GBuffer5:
                case BuiltinRenderTextureType.GBuffer6:
                case BuiltinRenderTextureType.GBuffer7:
                    // return RendererIsDeferred();
                    return true;
                default:
                case BuiltinRenderTextureType.None:
                case BuiltinRenderTextureType.PrepassLightSpec:
                    return false;
            }
        }

        private static readonly Dictionary<BuiltinRenderTextureType, bool> ValidRTType = new();

        public static bool SupportsRenderTextureType(BuiltinRenderTextureType renderTextureType)
        {
            if (!ValidRTType.TryGetValue(renderTextureType, out var valid))
            {
                valid = SupportsBuiltinRTType(renderTextureType);
                ValidRTType.Add(renderTextureType, valid);
            }

            return valid;
        }#1#

    }
}*/