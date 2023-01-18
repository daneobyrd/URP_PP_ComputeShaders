using System;
using System.Collections.Generic;
// using ScriptableRenderPasses.CustomRenderTargets;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses.OutlineBuffers
{
    using static HelperEnums;

    /*
    #region Settings Fields

    [Serializable]
    public class EdgeDetectionSettings
    {
        public EdgeDetectionMethod edgeMethod;
        public RenderPassEvent renderPassEvent = RenderPassEvent.BeforeRenderingPostProcessing;

        public Material blitMaterial;
    }

    /*
    [Serializable]
    public class BlurSettings
    {
        public bool enabled;
        public BlurType type;

        [Range(3, 5)] public int blurPasses = 5;
        public float threshold;
        public float intensity;
    }
    #1#

    [Serializable]
    public class OutlineShaderProperties
    {
        [Tooltip("Object Threshold."), Range(0.0000001f, 1.4f)]
        public float outerThreshold = 0.25f;

        [Tooltip("Inner Threshold."), Range(0.0000001f, 1.4f)]
        public float innerThreshold = 0.25f;

        // [Tooltip("Rotations.")] public int rotations = 8;

        [Tooltip("Depth Push.")] public float depthPush = 1e-6f;
        // [Tooltip("Object LUT.")] public Texture2D outerLUT;
        // [Tooltip("Inner LUT.")] public Texture2D innerLUT;
    }

    #endregion

    public class OutlineRenderer : ScriptableRendererFeature
    {
        public string ProfilerTag => nameof(OutlineRenderer);

        public RTSettings opaqueSettings = new("Linework Opaque Pass", RenderQueueType.Opaque);

        // public DrawToRTSettings transparentSettings = new("Linework Transparent Pass", RenderQueueType.Transparent);
        // public BlurSettings blur = new();
        public EdgeDetectionSettings edge = new();

        public OutlineShaderProperties shaderProps = new();
        // public MaterialPropertyBlock outline_PropertyBlock = new MaterialPropertyBlock();

        // Render Passes
        // private DrawToRT _lineworkOpaquePass;
        // private DrawToRT _lineworkTransparentPass;
        private FullscreenEdgeDetection _computeLines;

#if UNITY_EDITOR
        private Material OutlineEncoderMaterial
        {
            get => edge.blitMaterial;
            set => edge.blitMaterial = value;
        }

        private Shader OutlineEncoderShader
        {
            get => OutlineEncoderMaterial.shader;
            set => OutlineEncoderMaterial.shader = value;
        }

        private (bool, bool) EnabledPasses
        {
            get => (opaqueSettings.enabled, false);
            set => (opaqueSettings.enabled, _) = value;
        }
#else
        private Material OutlineEncoderMaterial => edge.blitMaterial;
        private Shader OutlineEncoderShader => OutlineEncoderMaterial.shader;
        private (bool, bool) EnabledPasses => (opaqueSettings.enabled, transparentSettings.enabled);
#endif
        private static class OutlineShaderIDs
        {
            public static readonly int OuterThreshold = Shader.PropertyToID("_OuterThreshold");

            public static readonly int InnerThreshold = Shader.PropertyToID("_InnerThreshold");

            // public static readonly int Rotations = Shader.PropertyToID("_Rotations");
            public static readonly int DepthPush = Shader.PropertyToID("_DepthPush");
            // public static readonly int OuterLut = Shader.PropertyToID("_OuterLUT");
            // public static readonly int InnerLut = Shader.PropertyToID("_InnerLUT");
        }

        private static class ComputeShaderConstants
        {
            // Blur Compute Shaders
            public static readonly ComputeShader Gaussian = (ComputeShader) Resources.Load("Compute/Blur/ColorPyramid");
            public static readonly ComputeShader Kawase = (ComputeShader) Resources.Load("Compute/Blur/KawaseCS");

            // Edge Detection Compute Shaders        
            public static readonly ComputeShader Laplacian =
                (ComputeShader) Resources.Load("Compute/EdgeDetection/Laplacian/Laplacian");

            public static readonly ComputeShader FreiChen =
                (ComputeShader) Resources.Load("Compute/EdgeDetection/Frei-Chen/FreiChen");
        }

        public override void Create()
        {
            if (EnabledPasses.Item1)
            {
                // _lineworkOpaquePass = new DrawToRT(opaqueSettings);
            }
            // if (EnabledPasses.Item2) { _lineworkTransparentPass = new DrawToRT(transparentSettings); }

            _computeLines = new FullscreenEdgeDetection(edge.renderPassEvent, "Outline Encoder");
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            GetMaterial();
            if (GetMaterial() == false)
            {
                return;
            }

            #region Set Global Outline Properties

            Shader.SetGlobalFloat(OutlineShaderIDs.OuterThreshold, shaderProps.outerThreshold);
            Shader.SetGlobalFloat(OutlineShaderIDs.InnerThreshold, shaderProps.innerThreshold);
            // Shader.SetGlobalInt(OutlineShaderIDS.Rotations, shaderProps.rotations);
            Shader.SetGlobalFloat(OutlineShaderIDs.DepthPush, shaderProps.depthPush);
            // Shader.SetGlobalTexture(OutlineShaderIDS.OuterLut, shaderProps.outerLUT);
            // Shader.SetGlobalTexture(OutlineShaderIDS.InnerLut, shaderProps.innerLUT);

            #endregion

            if (EnabledPasses.Item1) // opaque
            {
                // renderer.EnqueuePass(_lineworkOpaquePass);
            }
            // if (EnabledPasses.Item2) // transparent
            // {
            //     renderer.EnqueuePass(_lineworkTransparentPass);
            // }


            ComputeShader edgeCS = ComputeShaderConstants.FreiChen;
            string outlineSource;
            int outlineID = 0;
            
// #if UNITY_EDITOR
            switch (edge.edgeMethod)
            {
                // Only use Blur Pass for Laplacian
                case EdgeDetectionMethod.Laplacian:
                    outlineSource = opaqueSettings.customColorRT.texPropName;
                    outlineID     = opaqueSettings.customColorRT.GetNameId();
                    edgeCS        = ComputeShaderConstants.Laplacian;
                    break;
                case EdgeDetectionMethod.FreiChen or EdgeDetectionMethod.FreiChenGeneralized:
                    outlineSource = opaqueSettings.customColorRT.texPropName;
                    outlineID     = opaqueSettings.customColorRT.GetNameId();
                    edgeCS        = ComputeShaderConstants.FreiChen;
                    break;
                case EdgeDetectionMethod.Sobel:
                    break;
            }
// #endif

            var passIndex = opaqueSettings.customDepthRT.Active ? 1 : 0;

            _computeLines.Setup(outlineID, edgeCS, edge.edgeMethod);
            _computeLines.InitMaterial(OutlineEncoderMaterial, passIndex);
            renderer.EnqueuePass(_computeLines);
        }


        private void OnValidate()
        {
            GetEnabledPasses();
            GetMaterial();
        }

        private void GetEnabledPasses()
        {
            EnabledPasses = (opaqueSettings.enabled, false);

            if (EnabledPasses == (false, false))
            {
                Debug.LogWarningFormat(
                    "{0}.Create(): No enabled pass. Make sure to enable either the opaque or transparent pass in the renderer feature.",
                    GetType().Name);
            }
        }

        private bool GetMaterial()
        {
            // Does private material match public material?
            if (OutlineEncoderMaterial != edge.blitMaterial)
            {
                // Null check public material and if not null set private shader to use public material's shader.
                OutlineEncoderShader = Load(edge.blitMaterial);
                // If private material is null, create a new material using private shader.
                if (!OutlineEncoderMaterial)
                {
                    OutlineEncoderMaterial = Load(OutlineEncoderShader);
                }

                return true;
            }

            if (OutlineEncoderShader == null)
            {
                OutlineEncoderShader = Load(edge.blitMaterial);
            }

            return OutlineEncoderShader != null;
        }

        // Copied from universal/PostProcessPass.cs
        private Material Load(Shader shader)
        {
            if (shader == null)
            {
                var declaringType = GetType().DeclaringType;
                if (declaringType != null)
                    Debug.LogErrorFormat(
                        $"Missing shader. {declaringType.Name} render pass will not execute. Check for missing reference in the renderer feature settings.");
                return null;
            }
            else if (!shader.isSupported)
            {
                return null;
            }

            return CoreUtils.CreateEngineMaterial(shader);
        }

        private Shader Load(Material material)
        {
            var declaringType = GetType().DeclaringType;
            if (material == null)
            {
                if (declaringType != null)
                {
                    Debug.LogErrorFormat(
                        $"Missing material. {declaringType.Name} render pass will not execute. Check for missing reference in the renderer feature settings.");
                    return null;
                }
            }
            else if (material.shader == null)
            {
                if (declaringType != null)
                {
                    Debug.LogErrorFormat(
                        $"Shader error. {declaringType.Name} render pass will not execute. Check the shader used by the material reference in the renderer feature settings.");
                    return null;
                }
            }

            return material.shader;
        }
    }
*/
}