using System;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using UnityEngine.Serialization;

namespace ScriptableRenderPasses.KawaseBlur
{
    [Serializable]
    public enum SourceType
    {
        CameraColor = 0,
        TextureID = 1
    }

    [Serializable]
    public class KawaseBlurSettings
    {
        public bool enable;
        [FormerlySerializedAs("isBlitPass")] 
        public bool blitToCamera;
        public bool excludeSceneView;

        [Tooltip("The camera color can still be used in Texture ID mode: _CameraOpaqueTexture")]
        public SourceType blurSource;
        public string srcTextureId;

        [AdditionalProperty]
        public Material blitMaterial;
        
        public Material blurMaterial;
        [Range(3, 5)] public int blurPasses = 5;
    }

    [CreateAssetMenu(menuName = "Rendering/Kawase Blur", order = 2)]
    public sealed class KawaseBlurFeature : ScriptableRendererFeature
    {
        public KawaseBlurSettings settings;
        private KawaseBlurPass _kawaseBlur;

        public override void Create()
        {
            if (!settings.enable) return;
            _kawaseBlur = new KawaseBlurPass("Kawase Compute Render Pass", RenderPassEvent.BeforeRenderingPostProcessing);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
        {
            if (settings.blurMaterial == null) return;
            if (settings.enable == false) return;

            renderer.EnqueuePass(_kawaseBlur);
        }

        public override void SetupRenderPasses(ScriptableRenderer renderer, in RenderingData renderingData)
        {
            if (!settings.enable) return;

            _kawaseBlur.Setup(settings);
            if (settings.blurSource == SourceType.CameraColor ||
                (settings.blurSource == SourceType.TextureID && settings.srcTextureId == "_CameraOpaqueTexture"))
            {
                _kawaseBlur.ConfigureInput(ScriptableRenderPassInput.Color);
            }
        }

        protected override void Dispose(bool disposing)
        {
            _kawaseBlur?.Dispose();
            _kawaseBlur = null;
        }
    }
}