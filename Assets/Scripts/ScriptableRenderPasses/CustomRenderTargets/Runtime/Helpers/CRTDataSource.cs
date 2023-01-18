/*using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.Rendering;

namespace ScriptableRenderPasses
{
    
    [Serializable]
    public struct CRTDataSource
    {
        public static CRTDataSource CreateInstance() { return new CRTDataSource(); }

        private string textureName;
        private int NameId;
        
        private RenderTextureFormat renderTextureFormat;
        private DepthBits depthBits;

        private Texture2D texture2D;
        private RenderTexture renderTexture;

        private RenderTargetIdentifier RTId;

        /*
            = new RenderTargetIdentifier(NameId); 
            = new RenderTargetIdentifier(srcTexture);
            = new RenderTargetIdentifier(srcRenderTexture);
            = new RenderTargetIdentifier(renderTextureType);
         #1#

    

}

}*/