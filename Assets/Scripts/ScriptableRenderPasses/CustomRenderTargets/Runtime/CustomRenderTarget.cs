/*using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using UnityEngine;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;

namespace ScriptableRenderPasses
{
    /// <summary>
    /// Class of relevant properties and functions useful for creating custom render targets.
    /// </summary>
    [Serializable]
    public class CustomRenderTarget
    {
        #region Fields

        [SerializeField] public bool Active;
        [SerializeField] public BuiltinRenderTextureType RenderTextureType;

        [Delayed, Tooltip("To access the contents of this temporary RenderTexture, create a shader texture property with the same name used here.")]
        public string texPropName;

        [SerializeReference] public Texture2D texture2D;
        [SerializeReference] public RenderTexture renderTexture;

        [NonSerialized] public int NameId;
        [NonSerialized] public RenderTargetIdentifier RTId;

        // public RenderTextureFormat renderTextureFormat;
        [OverrideFrom(nameof(renderTexture))]
        public RTFormatParameter renderTextureFormatParameter;
        
        [SerializeField] public FormatUsage formatUsage;
        
        [SerializeField] public DepthBits depthBits;                              // Exposed for derived type: CustomDepthTarget
        [SerializeField] public List<string> lightModeTags;

        #endregion

        #region IRenderTargetIdentifier

        public IRenderTargetIdentifier IdType { get; set; }

        public void SetIdType()
        {
            var idTypeDictionary = new Dictionary<BuiltinRenderTextureType, IRenderTargetIdentifier>
            {
                // [BuiltinRenderTextureType.PropertyName] = new StringIdentifier(texPropName),
                [BuiltinRenderTextureType.PropertyName]    = new IntIdentifier(NameId, RTId),
                [BuiltinRenderTextureType.RenderTexture]   = new TextureIdentifier(renderTexture, RTId),
                [BuiltinRenderTextureType.BindableTexture] = new TextureIdentifier(texture2D, RTId),
            };

            IdType = idTypeDictionary.TryGetValue
                (RenderTextureType, out var identifierType)
                ? identifierType
                : new BuiltinIdentifier(RenderTextureType, RTId);
        }

        public void SetRTId() => IdType.SetRTId(out RTId);

        #endregion

        #region Constructors

        // Base
        protected CustomRenderTarget(bool active,
                                     BuiltinRenderTextureType type,
                                     string texName,
                                     RenderTextureFormat renderTextureFormat,
                                     DepthBits depth,
                                     List<string> lightModeTags)
        {
            Active            = active;
            RenderTextureType = type;
            texPropName       = texName;
            NameId            = GetNameId();
            // RTId                = GetRTId();
            // this.renderTextureFormat       = renderTextureFormat;
            renderTextureFormatParameter = new RTFormatParameter();
            depthBits           = depth;
            this.lightModeTags  = lightModeTags;

            SetIdType();
            SetRTId();
        }


        // ColorTarget - for Custom Pass SV_TARGET 0-7
        protected CustomRenderTarget(bool active, string texName, RenderTextureFormat rtFormat, List<string> lightModeTags)
            : this(active, BuiltinRenderTextureType.PropertyName, texName, rtFormat, DepthBits.None, lightModeTags) { }

        // DepthTarget - for Custom Pass Depth Render Target
        protected CustomRenderTarget(bool active, string texName, DepthBits depth, List<string> lightModeTags)
            : this(active, BuiltinRenderTextureType.PropertyName, texName, RenderTextureFormat.Depth, depth, lightModeTags) { }

        // Builtin Render Texture (Not Depth)
        protected CustomRenderTarget(bool active, BuiltinRenderTextureType type, RenderTextureFormat rtFormat, List<string> lightModeTags)
            : this(active, type, "Not Used", rtFormat, DepthBits.None, lightModeTags) { }

        // BuiltinRenderTexture.Depth as Custom Pass Depth Buffer
        protected CustomRenderTarget(bool active, DepthBits depth, List<string> lightModeTags)
            : this(active, BuiltinRenderTextureType.Depth, "Not Used", RenderTextureFormat.Depth, depth, lightModeTags) { }

        #endregion

        #region GetTemporaryRT

        public RenderTextureDescriptor GetCRTDescriptor(int width, int height) => new(width, height, renderTextureFormatParameter.value, (int) depthBits);

        /// <param name="cmd">Your command buffer.</param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="filterMode">Defaults to point mode.</param>
        /// <param name="readWrite"></param>
        /// <param name="antiAliasing"></param>
        /// <param name="enableRandomWrite"></param>
        public void GetTemporaryCRT(CommandBuffer cmd, int width, int height,
                                    [DefaultValue(FilterMode.Point)] FilterMode filterMode,
                                    [DefaultValue(RenderTextureReadWrite.Default)]
                                    RenderTextureReadWrite readWrite,
                                    int antiAliasing, bool enableRandomWrite)
        {
            // if (renderTextureType != BuiltinRenderTextureType.None)
            cmd.GetTemporaryRT
            (
                GetNameId(),
                width,
                height,
                (int) depthBits,
                filterMode,
                renderTextureFormatParameter.value,
                readWrite,
                antiAliasing,
                enableRandomWrite
            );
        }

        public void GetTemporaryCRT(CommandBuffer cmd, int width, int height, RenderTextureFormat format)
        {
            cmd.GetTemporaryRT(GetNameId(), width, height, 0, FilterMode.Point, format);
        }

        public void GetTemporaryCRT(CommandBuffer cmd, int width, int height, int depthBuffer)
        {
            cmd.GetTemporaryRT(GetNameId(), width, height, depthBuffer, FilterMode.Point, RenderTextureFormat.Depth);
        }

        public void GetTemporaryCRT(CommandBuffer cmd, int width, int height, DepthBits depthBuffer)
        {
            var castDepthBits = (int) depthBuffer;
            cmd.GetTemporaryRT(GetNameId(), width, height, castDepthBits, FilterMode.Point, RenderTextureFormat.Depth);
        }


        public void GetTemporaryCRT(CommandBuffer cmd, RenderTextureDescriptor desc, FilterMode filterMode)
        {
            cmd.GetTemporaryRT(GetNameId(), desc, filterMode);
        }

        public void GetTemporaryCRT(CommandBuffer cmd, RenderTextureDescriptor desc) { cmd.GetTemporaryRT(GetNameId(), desc); }

        public void GetTempCRTwithDescriptor(CommandBuffer cmd, int width, int height) { GetTemporaryCRT(cmd, GetCRTDescriptor(width, height)); }

        #endregion

        #region Get/Set RenderTargetIdentifer

        public int GetNameId() { return Shader.PropertyToID(texPropName); }

        private RenderTargetIdentifier GetPropertyRTId() { return new RenderTargetIdentifier(GetNameId()); }
        
        public Dictionary<BuiltinRenderTextureType, RenderTargetIdentifier> UserRTTypeToRTId =>
            new()
            {
                [BuiltinRenderTextureType.PropertyName] = GetPropertyRTId(),
                [BuiltinRenderTextureType.RenderTexture]   = new RenderTargetIdentifier(renderTexture),
                [BuiltinRenderTextureType.BindableTexture] = new RenderTargetIdentifier(texture2D),
            };

        private enum CustomRenderTargetSource
        {
            None = 0,
            User = 1,
            Unity = 2
        }

        public int NeedTempRT()
        {
            return (int) RenderTextureType switch
            {
                (int) BuiltinRenderTextureType.None            => (int) CustomRenderTargetSource.None, // 0
                (int) BuiltinRenderTextureType.BufferPtr       => (int) CustomRenderTargetSource.None, // 0
                (int) BuiltinRenderTextureType.PropertyName    => (int) CustomRenderTargetSource.User, // 1
                (int) BuiltinRenderTextureType.RenderTexture   => (int) CustomRenderTargetSource.User, // 1
                (int) BuiltinRenderTextureType.BindableTexture => (int) CustomRenderTargetSource.User, // 1
                _                                              => (int) CustomRenderTargetSource.Unity // 2
            };
        }

        public int GetRTIdHash() => GetPropertyRTId().GetHashCode();

        #endregion

        /// <summary>
        /// Adds all (string) lightModeTags in colorTarget to shaderTagIdList.
        /// </summary>
        public void ShaderTagSetup(List<ShaderTagId> shaderTagIdList)
        {
            shaderTagIdList.AddRange(lightModeTags.Select(tagId => new ShaderTagId(tagId)));
        }
    }


    // Structure ideas
    /*
        CustomRenderTarget
            ICustomRenderTarget
                active
                renderTextureType
                renderTextureFormat
                depthBits
                
            CustomRenderTargetData<UserSource>
                PropertyName
                    string textureName
                    int NameId;
                    RenderTargetIdentifer rtId = new(NameId);
                BindableTexture
                    Texture2D texture;
                    RenderTargetIdentifier rtId = new(Texture);
                RenderTexture
                    RenderTexture renderTexture;
                    RenderTargetIdentifier rtId = new(RenderTexture);
                    
            CustomRenderTargetData<UnitySource>
                BuiltinTexture
                    RenderTargetIdentifier rtId = new(renderTextureType);            

     #1#
}*/