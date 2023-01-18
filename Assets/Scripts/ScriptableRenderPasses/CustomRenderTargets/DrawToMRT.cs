using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
    using static HelperEnums;

    /*
    [Serializable]
    public class DrawToMRT : ScriptableRenderPass
    {
        private MRTSettings _settings;
        private List<ShaderTagId> _shaderTagIdList = new();
        private int SupportedMRTCount => SystemInfo.supportedRenderTargetCount;

        public DrawToMRT(MRTSettings passSettings)
        {
            _settings = passSettings;

            var renderQueueRange = _settings.renderQueueType == RenderQueueType.Opaque
                ? RenderQueueRange.opaque
                : RenderQueueRange.transparent;

            _settings.FilteringSettings =
                new FilteringSettings(renderQueueRange, _settings.layerMask, (uint) _settings.lightLayerMask);
        }

        /// <summary>
        /// Adds all non-duplicate (string) lightModeTags in colorTarget to _shaderTagIdList.
        /// </summary>
        public void ShaderTagSetup(List<CustomColorRT> colorTargets)
        {
            foreach (var colorTagId in colorTargets
                         .SelectMany(colorTarget => colorTarget.lightModeTags
                                                               .Select(tempTag => new ShaderTagId(tempTag))
                                                               .Where(colorTagID => !_shaderTagIdList.Contains(colorTagID))))
            {
                _shaderTagIdList.Add(colorTagId);
            }
            // Duplicate tags might not be an issue... but I'm checking for duplicates as a precaution.
        }

        /// <summary>
        /// Sets enum representing which custom targets are enabled.
        /// </summary>
        /// <param name="passSettings"></param>
        private void CheckCameraTargetMode(MRTSettings passSettings)
        {
            switch (passSettings.customDepthRT.Active)
            {
                // Currently no setting for DepthOnly pass.
                case true:
                    passSettings.cameraTargetMode = CameraTargetMode.ColorAndDepth;
                    break;
                case false:
                {
                    if (passSettings.customColorTargets.Any(target => target.Active = true))
                    {
                        passSettings.cameraTargetMode = CameraTargetMode.Color;
                    }

                    break;
                }
            }
        }

        public void Setup()
        {
            CheckCameraTargetMode(_settings);
            ShaderTagSetup(new List<CustomColorRT>(_settings.customColorTargets));
        }

        public override void OnCameraSetup(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
        {
            var width = cameraTextureDescriptor.width;
            var height = cameraTextureDescriptor.height;
            cameraTextureDescriptor.msaaSamples = 1;

            #region Create Temporary Render Textures

            List<RenderTargetIdentifier> activeColorAttachments = new();

            // Configure all active color attachments.
            foreach (var colorTarget in _settings.customColorTargets.Where(target => target.Active = true))
            {
                // If using a BuiltinRenderTextureType, we don't need to handle it's creation.
                if (colorTarget.IdType.GetType() != typeof(BuiltinIdentifier))
                {
                    colorTarget.GetTemporaryCRT(cmd, width, height, colorTarget.renderTextureFormatParameter.value);
                }

                activeColorAttachments.Add(colorTarget.RTId);
            }

            if (_settings.customDepthRT.Active)
            {
                var depthTarget = _settings.customDepthRT;
                if (depthTarget.IdType.GetType() !=
                    typeof(BuiltinIdentifier)) // If using a BuiltinRenderTextureType, we don't need to handle it's creation.
                {
                    depthTarget.GetTemporaryCRT(cmd, width, height, (int) depthTarget.depthBits);
                }
            }

            #endregion

            // Checking for edge-case where all targets are disabled in the editor. There's probably a simpler way to check for this earlier on.
            if (activeColorAttachments.Count == 0 && !_settings.customDepthRT.Active) return;

            #region ConfigureTarget

            var mrt = activeColorAttachments.ToArray();

            if (_settings.cameraTargetMode == CameraTargetMode.ColorAndDepth)
            {
                var depthTarget = _settings.customDepthRT;
                // ConfigureTarget(mrt, _settings.customDepthTarget.RTID);
                ConfigureTarget(mrt, depthTarget.RTId);
                ConfigureClear(ClearFlag.All, clearColor);
            }
            else //if (_settings.cameraTargetMode == CameraTargetMode.Color)
            {
                ConfigureTarget(mrt);
                ConfigureClear(ClearFlag.Color, clearColor);
            }

            #endregion
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            CommandBuffer cmd = CommandBufferPool.Get(_settings.profilerTag);

            var cameraData = renderingData.cameraData;

            SortingCriteria sortingCriteria =
                _settings.renderQueueType == RenderQueueType.Opaque
                    ? cameraData.defaultOpaqueSortFlags
                    : SortingCriteria.CommonTransparent;

            DrawingSettings drawingSettings = CreateDrawingSettings(_shaderTagIdList, ref renderingData, sortingCriteria);

            context.DrawRenderers(renderingData.cullResults, ref drawingSettings, ref _settings.FilteringSettings);

            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }

        // OnCameraCleanup or FrameCleanup? In most situations it doesn't matter.
        public override void FrameCleanup(CommandBuffer cmd)
        {
            foreach (var colorTarget in _settings.customColorTargets.Where(
                         colorTarget => colorTarget.Active && colorTarget.IdType.GetType() != typeof(BuiltinIdentifier)))
            {
                cmd.ReleaseTemporaryRT(colorTarget.GetNameId());
            }

            var depthTarget = _settings.customDepthRT;
            if (depthTarget.Active && depthTarget.IdType.GetType() != typeof(BuiltinIdentifier))
            {
                // cmd.ReleaseTemporaryRT(_settings.customDepthTarget.NameID);
                cmd.ReleaseTemporaryRT(_settings.customDepthRT.GetNameId());
            }
        }
    }
    */
}