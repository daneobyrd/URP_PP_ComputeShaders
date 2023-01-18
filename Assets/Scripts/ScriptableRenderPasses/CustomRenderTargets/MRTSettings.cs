/*using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
    [Serializable]
    public class MRTSettings
    {
        public string profilerTag;

        public FilteringSettings FilteringSettings; // Not serializable.

        [Header("Filters")] public HelperEnums.RenderQueueType renderQueueType;

        public LayerMask layerMask = -1;
        public LightLayerEnum lightLayerMask = LightLayerEnum.Everything;

        [HideInInspector] public HelperEnums.CameraTargetMode cameraTargetMode;

        [SerializeField] public List<CustomColorRT> customColorTargets;
        [SerializeField] public CustomDepthRT customDepthRT;

        public MRTSettings(string name, HelperEnums.RenderQueueType queueType)
        {
            profilerTag     = name;
            renderQueueType = queueType;

            customColorTargets = new List<CustomColorRT>();
            customDepthRT      = new CustomDepthRT();
        }
    }
}*/