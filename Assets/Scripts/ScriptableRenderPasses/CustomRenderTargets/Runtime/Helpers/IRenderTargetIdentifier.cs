using UnityEngine;
using UnityEngine.Rendering;

namespace ScriptableRenderPasses
{
    public interface IRenderTargetIdentifier
    {
        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            renderTargetID = default;
        }
    }
    
    public class BuiltinIdentifier : IRenderTargetIdentifier
    {
        private readonly BuiltinRenderTextureType _builtinType;
        private RenderTargetIdentifier _rtID;

        public BuiltinIdentifier(BuiltinRenderTextureType rtType, RenderTargetIdentifier identifier)
        {
            _builtinType = rtType;
            _rtID        = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID = new RenderTargetIdentifier(_builtinType);
            renderTargetID  = _rtID;
        }
    }

    public class StringIdentifier : IRenderTargetIdentifier
    {
        private readonly string _name;
        private RenderTargetIdentifier _rtID;

        public StringIdentifier(string name, RenderTargetIdentifier identifier)
        {
            _name = name;
            _rtID = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID = new RenderTargetIdentifier(_name);
            renderTargetID  = _rtID;
        }
    }

    public class IntIdentifier : IRenderTargetIdentifier
    {
        private readonly int _nameID;
        private RenderTargetIdentifier _rtID;

        public IntIdentifier(int nameId, RenderTargetIdentifier identifier)
        {
            _nameID = nameId;
            _rtID   = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID = new RenderTargetIdentifier(_nameID);
            renderTargetID  = _rtID;
        }
    }

    public class ExistingIdentifier : IRenderTargetIdentifier
    {
        private readonly RenderTargetIdentifier _existingID;
        private RenderTargetIdentifier _rtID;

        private ExistingIdentifier(RenderTargetIdentifier existing, RenderTargetIdentifier identifier)
        {
            _existingID = existing;
            _rtID       = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID          = new RenderTargetIdentifier(_existingID, 0);
            renderTargetID = _rtID;
        }
    }

    public class TextureIdentifier : IRenderTargetIdentifier
    {
        private readonly Texture _texture;
        private RenderTargetIdentifier _rtID;

        public TextureIdentifier(Texture texture, RenderTargetIdentifier identifier)
        {
            _texture = texture;
            _rtID    = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID          = new RenderTargetIdentifier(_texture);
            renderTargetID = _rtID;
        }
    }

    public class BufferIdentifier : IRenderTargetIdentifier
    {
        private readonly RenderBuffer _buffer;
        private RenderTargetIdentifier _rtID;

        public BufferIdentifier(RenderBuffer buffer, RenderTargetIdentifier identifier)
        {
            _buffer = buffer;
            _rtID   = identifier;
        }

        public void SetRTId(out RenderTargetIdentifier renderTargetID)
        {
            _rtID          = new RenderTargetIdentifier(_buffer);
            renderTargetID = _rtID;
        }
    }
}