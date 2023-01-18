/*using System;
using System.Collections.Generic;
using UnityEngine;

namespace ScriptableRenderPasses
{
    [Serializable]
    public sealed class CustomColorRT : CustomRenderTarget
    {
        public bool useLocalFormat; // Exists to make property drawer simpler.

        public CustomColorRT(bool active,
                             string texName,
                             RenderTextureFormat rtFormat,
                             List<string> lightModeTags)
            : base(active, texName, rtFormat, lightModeTags) { }

        public CustomColorRT()
            : base(active: false, texName: default, rtFormat: RenderTextureFormat.Default, lightModeTags: default) { }
    }
}*/