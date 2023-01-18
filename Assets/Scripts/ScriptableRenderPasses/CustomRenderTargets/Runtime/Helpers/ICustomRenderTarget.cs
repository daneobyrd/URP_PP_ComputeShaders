namespace ScriptableRenderPasses
{
    using UnityEngine.Rendering;

    public interface ICustomRenderTarget
    {
        bool                     Active            { get; set; }
        BuiltinRenderTextureType RenderTextureType { get; set; }
    }
}