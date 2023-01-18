/*using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses.CustomRenderTargets
{
    using static HelperEnums;

    [Serializable]
    public class DrawToRT : ScriptableRenderPass
    {
        private RTSettings _settings;
        private List<ShaderTagId> _shaderTagIdList = new();

        public DrawToRT(RTSettings passSettings)
        {
            _settings = passSettings;
            var s = _settings;
            
            profilingSampler = new ProfilingSampler(s.profilerTag);

            var renderQueueRange = s.renderQueueType == RenderQueueType.Opaque
                    ? RenderQueueRange.opaque
                    : RenderQueueRange.transparent;

            s.FilteringSettings = new FilteringSettings(renderQueueRange, s.layerMask, (uint) s.lightLayerMask);

            // Adds shader pass tags (from custom utility class) to TagIdList
            s.customColorRT.ShaderTagSetup(_shaderTagIdList);
        }
        
        public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            var width = cameraTextureDescriptor.width;
            var height = cameraTextureDescriptor.height;
            if (cameraTextureDescriptor.useDynamicScale)
            {
                width  *= (int) ScalableBufferManager.widthScaleFactor;
                height *= (int) ScalableBufferManager.heightScaleFactor;
            }

            cameraTextureDescriptor.msaaSamples = 1;
            
            var colorTarget = _settings.customColorRT;
            var depthTarget = _settings.customDepthRT;

            colorTarget.GetTemporaryCRT(cmd, width, height, colorTarget.renderTextureFormatParameter.value);

            if (!_settings.AllocateDepth)
            {
                // ConfigureTarget(colorTarget.RTId);
                ConfigureClear(ClearFlag.Color, clearColor);
            }
            else
            {
                depthTarget.GetTemporaryCRT(cmd, width, height, depthTarget.depthBits);
            
                // ConfigureTarget(colorTarget.RTId, depthTarget.RTId);
                ConfigureClear(ClearFlag.All, clearColor);
            }
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            var cameraData = renderingData.cameraData;

            SortingCriteria sortingCriteria = _settings.renderQueueType == RenderQueueType.Opaque
                ? cameraData.defaultOpaqueSortFlags
                : SortingCriteria.CommonTransparent;

            DrawingSettings drawingSettings =
                CreateDrawingSettings(_shaderTagIdList, ref renderingData, sortingCriteria);

            CommandBuffer cmd = CommandBufferPool.Get();
            using (new ProfilingScope(cmd, profilingSampler))
            {
                context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref _settings.FilteringSettings);
            }

            context.ExecuteCommandBuffer(cmd);
            cmd.Clear();

            CommandBufferPool.Release(cmd);
        }

        // OnCameraCleanup or FrameCleanup? In most situations it doesn't matter.
        public override void FrameCleanup(CommandBuffer cmd)
        {
            // cmd.ReleaseTemporaryRT(colorTarget.NameID);
            cmd.ReleaseTemporaryRT(_settings.customColorRT.GetNameId());

            if (_settings.AllocateDepth)
            {
                // cmd.ReleaseTemporaryRT(_settings.customDepthTarget.NameID);
                cmd.ReleaseTemporaryRT(_settings.customDepthRT.GetNameId());
            }
        }
    }
}*/