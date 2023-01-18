using System;
using UnityEngine;
using UnityEngine.Rendering.Universal;

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
        public bool isBlitPass;
        public bool excludeSceneView;

        [Tooltip
        (
            "The camera color can still be used in Texture ID mode. " +
            "Ensure the pipeline asset's Opaque Texture is enabled and use _CameraOpaqueTexture"
        )]
        public SourceType blurSource;

        public string srcTextureId;

        public Material blurMaterial;
        [Range(3, 5)] public int blurPasses = 5;
    }

    /*[CreateAssetMenu(menuName = "Rendering/Kawase Blur", order = 2)]
    public sealed class KawaseBlurFeature : ScriptableRendererFeature
    {
        public KawaseBlurSettings settings;
        private KawaseBlurPass _kawaseBlur;

        public override void Create()
        {
            if (!settings.enable) return;
            _kawaseBlur =
                new KawaseBlurPass("Kawase Compute Render Pass", RenderPassEvent.BeforeRenderingPostProcessing);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
        {
            if (!settings.enable) return;
            _kawaseBlur.Setup(settings);
            if (settings.blurSource == SourceType.TextureID)
                _kawaseBlur.ConfigureInput(ScriptableRenderPassInput.Color);

            renderer.EnqueuePass(_kawaseBlur);
        }
    }*/
}