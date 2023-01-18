/*using System;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace ScriptableRenderPasses
{
[Serializable]
public class RTSettings
{
    public bool enabled = false;
    public string profilerTag;

    public FilteringSettings FilteringSettings; // Not serializable.

    // Based on the enum used in Unity's RenderObjects feature.
    // Used as a shortcut for changing the render queue location between opaque and transparent.
    [Header("Filters")] public HelperEnums.RenderQueueType renderQueueType;

    public LayerMask layerMask = -1; // -1 for all
    public LightLayerEnum lightLayerMask = LightLayerEnum.Everything;
    
    public CustomColorRT customColorRT;
    public CustomDepthRT customDepthRT;
    public bool AllocateDepth => customDepthRT.Active;

    public RTSettings(string name, HelperEnums.RenderQueueType queueType)
    {
        profilerTag     = name;
        renderQueueType = queueType;

        customColorRT = new CustomColorRT();
        customDepthRT = new CustomDepthRT();
    }
}
}*/