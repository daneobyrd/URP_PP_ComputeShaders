using UnityEngine;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
    /*
    public sealed class FreiChenFeature : ScriptableRendererFeature
    {
        public enum InjectionPoint
        {
            BeforeRenderingTransparents = RenderPassEvent.BeforeRenderingTransparents,
            BeforeRenderingPostProcessing = RenderPassEvent.BeforeRenderingPostProcessing,
            AfterRenderingPostProcessing = RenderPassEvent.AfterRenderingPostProcessing
        }

        public Material passMaterial;
        public InjectionPoint injectionPoint = InjectionPoint.AfterRenderingPostProcessing;
        public ScriptableRenderPassInput requirements = ScriptableRenderPassInput.Color;

        [HideInInspector] // We draw custom pass index entry with the dropdown inside FullScreenPassRendererFeatureEditor.cs
        public int passIndex = 0;

        public ComputeShader freiChenCs;

        private FreiChenPass _freiChenPass;
        private bool requiresColor;
        private bool injectedBeforeTransparents;
        
        public override void Create()
        {
            _freiChenPass = new FreiChenPass {renderPassEvent = (RenderPassEvent) injectionPoint};
            _freiChenPass.ConfigureInput(ScriptableRenderPassInput.Color);
        }

        protected override void Dispose(bool disposing) { _freiChenPass.Dispose(); }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            if (passMaterial == null)
            {
                Debug.LogWarningFormat("Missing Post Processing effect Material. {0} Fullscreen pass will not execute. Check for missing reference in the assigned renderer.", GetType().Name);
                return;
            }

            if (freiChenCs == null || passMaterial == null) return;

            _freiChenPass.Setup(freiChenCs,
                                passMaterial, passIndex, requiresColor, injectedBeforeTransparents,
                                "FullScreenPassRendererFeature", renderingData);


            renderer.EnqueuePass(_freiChenPass);
        }
    }
*/
}