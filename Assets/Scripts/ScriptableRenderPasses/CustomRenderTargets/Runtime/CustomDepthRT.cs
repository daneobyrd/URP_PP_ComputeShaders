/*namespace ScriptableRenderPasses
{
    using System;
    using System.Collections.Generic;
    using UnityEngine.Rendering;

    [Serializable]
    public sealed class CustomDepthRT : CustomRenderTarget
    {
        public CustomDepthRT(bool active, string texName, DepthBits depthBits, List<string> lightModeTags)
            : base(active, texName, depthBits, lightModeTags)
        {
        }

        public CustomDepthRT() : base(active: false, texName: default, depth: DepthBits.None,
                                          lightModeTags: default)
        {
        }
    }
}*/