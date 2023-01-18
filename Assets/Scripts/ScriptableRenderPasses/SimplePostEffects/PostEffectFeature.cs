// https://github.com/keijiro/SimplePostEffects

using System.Collections.Generic;
using System.Linq;
using JetBrains.Annotations;

namespace ScriptableRenderPasses
{
    using UnityEngine;
    using UnityEngine.Rendering;
    using UnityEngine.Rendering.Universal;

    /*
    public class BuiltinHandleDebug
    {
        public static RenderTargetIdentifier Depth = new(BuiltinRenderTextureType.Depth);
        public static RenderTargetIdentifier DepthNormals = new(BuiltinRenderTextureType.DepthNormals);
        public static RenderTargetIdentifier ResolvedDepth = new(BuiltinRenderTextureType.ResolvedDepth);
        public static RenderTargetIdentifier Reflections = new(BuiltinRenderTextureType.Reflections);
        public static RenderTargetIdentifier MotionVectors = new(BuiltinRenderTextureType.MotionVectors);
        public static RenderTargetIdentifier PrepassNormalsSpec = new(BuiltinRenderTextureType.PrepassNormalsSpec);
        public static RenderTargetIdentifier PrepassLight = new(BuiltinRenderTextureType.PrepassLight);
        public static RenderTargetIdentifier GBuffer0 = new(BuiltinRenderTextureType.GBuffer0);
        public static RenderTargetIdentifier GBuffer1 = new(BuiltinRenderTextureType.GBuffer1);
        public static RenderTargetIdentifier GBuffer2 = new(BuiltinRenderTextureType.GBuffer2);
        public static RenderTargetIdentifier GBuffer3 = new(BuiltinRenderTextureType.GBuffer3);
        public static RenderTargetIdentifier GBuffer4 = new(BuiltinRenderTextureType.GBuffer4);
        public static RenderTargetIdentifier GBuffer5 = new(BuiltinRenderTextureType.GBuffer5);
        public static RenderTargetIdentifier GBuffer6 = new(BuiltinRenderTextureType.GBuffer6);
        public static RenderTargetIdentifier GBuffer7 = new(BuiltinRenderTextureType.GBuffer7);

        private readonly RenderTargetIdentifier[] _debugArray =
        {
            Depth, DepthNormals, ResolvedDepth,
            Reflections, MotionVectors,
            PrepassNormalsSpec, PrepassLight,
            GBuffer0, GBuffer1, GBuffer2, GBuffer3, GBuffer4, GBuffer5, GBuffer6, GBuffer7,
        };

        public void PrintDebug(out List<int> debug)
        {
            debug = _debugArray.Select(identifier => identifier.GetHashCode()).ToList();
            
            foreach (var hash in debug)
            {
                Debug.Log(hash);
            }
        }
    }
    */

    /*
    sealed class PostEffectPass : ScriptableRenderPass
    {
        private Material _material;
        public RTSettings ToRTSettings;

        public PostEffectPass(Material material, RenderPassEvent renderPassEvent, RTSettings settings)
        {
            this._material       = material;
            base.renderPassEvent = renderPassEvent;
            this.ToRTSettings    = settings;
        }
        
        public override void Execute(ScriptableRenderContext context, ref RenderingData data)
        {
            if (_material == null) return;
            var cmd = CommandBufferPool.Get("PostEffect");
            Blit(cmd, ref data, _material, 0);
            context.ExecuteCommandBuffer(cmd);
            CommandBufferPool.Release(cmd);
        }
    }

    public sealed class PostEffectFeature : ScriptableRendererFeature
    {
        private Material _material;
        public RTSettings settings;
        
        private PostEffectPass _pass;
        
        public override void Create()
        {
            _pass = new PostEffectPass(material: _material, renderPassEvent: RenderPassEvent.AfterRenderingPostProcessing, settings);
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData data)
        {
            renderer.EnqueuePass(_pass);
        }
    }
*/
}