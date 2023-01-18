/*using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.Rendering;
#endif
using static SerializedPropUtil;

// using static ScriptableRenderPasses.OverrideableProperty;

namespace ScriptableRenderPasses
{
    using static EditorGUI;
    using static CustomGUI;
    using static HeaderToggle.Styles;
    using crt = CustomRenderTarget;
    using CRT = CustomRenderTarget;

    [CustomPropertyDrawer(typeof(CustomRenderTarget), useForChildren: true)]
    public class CustomRenderTargetDrawer : PropertyDrawer
    {
        #region GUIStyle

        private static class Labels // GUIContent
        {
            public static readonly GUIContent RTTypeLabel = EditorGUIUtility.TrTextContent("Render Texture Type");
            public static readonly GUIContent PropertyIdLabel = EditorGUIUtility.TrTextContent("Texture ID", "Global Texture Property");
            public const string FallbackText = "_CustomRenderTarget";

            public static readonly GUIContent Texture2DLabel = EditorGUIUtility.TrTextContent("Texture");
            public static readonly GUIContent RTLabel = EditorGUIUtility.TrTextContent("Render Texture", "Global Render Texture Property");

            public static readonly GUIContent RTFormatLabel = EditorGUIUtility.TrTextContent
            (
                "Render Texture Format", "The format used by this temporary render texture."
            );

            public static readonly GUIContent CustomColorTarget = EditorGUIUtility.TrTextContent("Color");
            public static readonly GUIContent CustomDepthTarget = EditorGUIUtility.TrTextContent("Depth");

            public static readonly GUIContent TextureFormatHelpURL = EditorGUIUtility.TrTextContent
            (
                "https://docs.unity3d.com/Manual/class-TextureImporterOverride.html#supported-formats",
                "the supported texture formats reference table"
            );

            public static string HelpText;

            public static readonly string PrepassLightSpecError = L10n.Tr
                ("Deferred lighting HDR specular light buffer (Xbox 360 only). Xbox360 is no longer supported in Unity 5.5+");

            public static readonly string BufferPtrInfo = L10n.Tr("Currently a BufferPtr editor has not been implemented and is not supported.");

            private static readonly GUIContent[] LabelArray = {RTTypeLabel, PropertyIdLabel, Texture2DLabel, RTLabel, RTFormatLabel};
            public static readonly float LongestLabelWidth = GetLongestLabelWidth(LabelArray);
        }

        private static class Styles // GUIStyle
        {
            private static readonly float SidebarWidth = CoreEditorConstants.standardHorizontalSpacing;

            public static readonly GUIStyle MainColumnStyle = new(boxBackground)
            {
                clipping = TextClipping.Clip, margin = new RectOffset((int) SidebarWidth, 0, 0, 5), padding = new RectOffset(5, 5, 0, 5),
            };

            public static readonly GUIStyle RightColumnStyle = new(boxBackground) {padding = {left = 5, right = 5},};

            private static readonly int VerticalSpacing = (int) EditorGUIUtility.standardVerticalSpacing;
            private static readonly int HorizontalSpacing = (int) CoreEditorConstants.standardHorizontalSpacing;

            public static readonly GUIStyle HighlightBox = new(elementBackground)
            {
                stretchHeight = false,
                fixedHeight   = EditorGUIUtility.singleLineHeight * 2 + EditorGUIUtility.standardVerticalSpacing,
                border        = new RectOffset(6, 3, 0, 6),
                padding       = new RectOffset(HorizontalSpacing, HorizontalSpacing, VerticalSpacing, VerticalSpacing)
            };

            public static readonly float CacheLabelWidth = EditorGUIUtility.labelWidth;
            public static float CacheFieldWidth = EditorGUIUtility.fieldWidth;
        }

        #endregion

        #region Serialized Properties

        private SerializedProperty _active;
        private SerializedProperty _rtType;
        private SerializedProperty _shaderTags;

        private SerializedProperty _propertyName;
        private SerializedProperty _texture2D;
        private SerializedProperty _renderTexture;

        private SerializedProperty _renderTextureFormat;

        private SerializedProperty _rtFormatParameter;
        private SerializedProperty _formatUsage;

        #endregion

        private bool _isInitialized = false;

        private void Initialize(SerializedProperty property)
        {
            _active     = property.FindPropertyRelative(nameof(crt.Active));
            _rtType     = property.FindPropertyRelative(nameof(crt.RenderTextureType));
            _shaderTags = property.FindPropertyRelative(nameof(crt.lightModeTags));

            _propertyName  = property.FindPropertyRelative(nameof(crt.texPropName));
            _texture2D     = property.FindPropertyRelative(nameof(crt.texture2D));
            _renderTexture = property.FindPropertyRelative(nameof(crt.renderTexture));

            _formatUsage       = property.FindPropertyRelative(nameof(crt.formatUsage));
            _rtFormatParameter = property.FindPropertyRelative(nameof(crt.renderTextureFormatParameter));

            _isInitialized = true;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            property.serializedObject.Update();

            if (!_isInitialized) { Initialize(property); }

            using var propScope = new PropertyScope(position, label, property);

            using var checkScope = new ChangeCheckScope();

            var displayContent = HeaderToggle.Draw(Labels.CustomColorTarget, property, _active, Labels.TextureFormatHelpURL);
            if (displayContent)
            {
                using var bgScope = new EditorGUILayout.VerticalScope(boxBackground);

                using (new EditorGUILayout.VerticalScope())
                {
                    using (new EditorGUILayout.VerticalScope())
                    {
                        EditorGUIUtility.labelWidth = Labels.LongestLabelWidth + (indentLevel * 15f) + CoreEditorConstants.standardHorizontalSpacing;

                        EditorGUILayout.PropertyField(_rtType, Labels.RTTypeLabel);
                        if (checkScope.changed)
                        {
                            // Apply changes and save if the user has modified any settings
                            property.serializedObject.ApplyModifiedProperties();
                            // ForceSave(property.serializedObject.targetObject);
                        }
                    }

                    using (var renderTargetData = new EditorGUILayout.VerticalScope(GUIStyle.none))
                    {
                        // HeaderToggle.DrawActiveBackground(renderTargetData.rect, _active.boolValue, false, Styles.HighlightBox);
                        RenderTargetDataGUI();

                        if (checkScope.changed)
                        {
                            FetchFlagAction();
                        }
                    }
                }

                using (var bottom = new EditorGUILayout.VerticalScope(GUIStyle.none))
                {
                    var backgroundTint = EditorGUIUtility.isProSkin ? 0.1f : 1f;
                    // DrawRect(bottom.rect, new Color(backgroundTint, backgroundTint, backgroundTint, 0.2f));

                    EditorGUILayout.PropertyField(_shaderTags);
                    if (checkScope.changed)
                    {
                        _shaderTags.serializedObject.Update();

                        // Apply changes and save if the user has modified any settings
                        property.serializedObject.ApplyModifiedProperties();
                    }
                }
            } // End .isExtended state
            // End _propScope
        }

        #region UIFlags

        [Flags]
        public enum CRT_UIFlags
        {
            None = 0,
            HelpBox = 1,
            TextureID = 2,
            RenderTexture = 4,
            Texture2D = 8,
            Deferred = 16,
        }

        private static readonly Dictionary<int, CRT_UIFlags> RTTypeDictionary = new()
        {
            [(int) BuiltinRenderTextureType.PropertyName]    = CRT_UIFlags.TextureID,     // -4
            [(int) BuiltinRenderTextureType.BufferPtr]       = CRT_UIFlags.HelpBox,       // -3
            [(int) BuiltinRenderTextureType.RenderTexture]   = CRT_UIFlags.RenderTexture, // -2
            [(int) BuiltinRenderTextureType.BindableTexture] = CRT_UIFlags.Texture2D,     // -1


            // Created by Unity, available in both Rendering Modes
            [(int) BuiltinRenderTextureType.None]          = CRT_UIFlags.None, // 0
            [(int) BuiltinRenderTextureType.CurrentActive] = CRT_UIFlags.None, // 1
            [(int) BuiltinRenderTextureType.CameraTarget]  = CRT_UIFlags.None, // 2
            [(int) BuiltinRenderTextureType.Depth]         = CRT_UIFlags.None, // 3
            [(int) BuiltinRenderTextureType.DepthNormals]  = CRT_UIFlags.None, // 4
            [(int) BuiltinRenderTextureType.Reflections]   = CRT_UIFlags.None, // 14
            [(int) BuiltinRenderTextureType.MotionVectors] = CRT_UIFlags.None, // 15

            // Error: Not supported after Unity 5.5+ (Xbox 360 only)
            [(int) BuiltinRenderTextureType.PrepassLightSpec] = CRT_UIFlags.HelpBox,

            // Created by Unity, available in Deferred Mode only
            [(int) BuiltinRenderTextureType.ResolvedDepth]      = CRT_UIFlags.Deferred, // 5
            [(int) BuiltinRenderTextureType.PrepassNormalsSpec] = CRT_UIFlags.Deferred, // 7
            [(int) BuiltinRenderTextureType.PrepassLight]       = CRT_UIFlags.Deferred, // 8
            [(int) BuiltinRenderTextureType.GBuffer0]           = CRT_UIFlags.Deferred, // 10
            [(int) BuiltinRenderTextureType.GBuffer1]           = CRT_UIFlags.Deferred, // 11
            [(int) BuiltinRenderTextureType.GBuffer2]           = CRT_UIFlags.Deferred, // 12
            [(int) BuiltinRenderTextureType.GBuffer3]           = CRT_UIFlags.Deferred, // 13
            [(int) BuiltinRenderTextureType.GBuffer4]           = CRT_UIFlags.Deferred, // 16
            [(int) BuiltinRenderTextureType.GBuffer5]           = CRT_UIFlags.Deferred, // 17
            [(int) BuiltinRenderTextureType.GBuffer6]           = CRT_UIFlags.Deferred, // 18
            [(int) BuiltinRenderTextureType.GBuffer7]           = CRT_UIFlags.Deferred, // 19
        };

        private CRT_UIFlags _uiFlags; // = CRT_UIFlags.None;

        private void SetFlags()
        {
            switch (_rtType.intValue)
            {
                case (int) BuiltinRenderTextureType.None:
                    _uiFlags = CRT_UIFlags.None;
                    break;

                // Created by User
                case (int) BuiltinRenderTextureType.PropertyName:
                    _uiFlags = CRT_UIFlags.TextureID;
                    break;
                case (int) BuiltinRenderTextureType.RenderTexture:
                    _uiFlags = CRT_UIFlags.RenderTexture;
                    break;
                case (int) BuiltinRenderTextureType.BindableTexture:
                    _uiFlags = CRT_UIFlags.Texture2D;
                    break;

                case (int) BuiltinRenderTextureType.BufferPtr:
                    _uiFlags        = CRT_UIFlags.HelpBox;
                    Labels.HelpText = Labels.BufferPtrInfo;
                    break;

                // Error: Not supported after Unity 5.5+ (Xbox 360 only) - find way to hide enum option in drawer to eliminate case
                case (int) BuiltinRenderTextureType.PrepassLightSpec:
                    _uiFlags        = CRT_UIFlags.HelpBox;
                    Labels.HelpText = Labels.PrepassLightSpecError;
                    break;

                /*
                // Created by Unity: available in Deferred Mode only
                case BuiltinRenderTextureType.ResolvedDepth:
                case BuiltinRenderTextureType.PrepassNormalsSpec:
                case BuiltinRenderTextureType.PrepassLight:
                case BuiltinRenderTextureType.GBuffer0:
                case BuiltinRenderTextureType.GBuffer1:
                case BuiltinRenderTextureType.GBuffer2:
                case BuiltinRenderTextureType.GBuffer3:
                case BuiltinRenderTextureType.GBuffer4:
                case BuiltinRenderTextureType.GBuffer5:
                case BuiltinRenderTextureType.GBuffer6:
                case BuiltinRenderTextureType.GBuffer7:
                #1#
                case (> (int) BuiltinRenderTextureType.DepthNormals)
                     and not ((int) BuiltinRenderTextureType.Reflections or (int) BuiltinRenderTextureType.MotionVectors):
                    _uiFlags = CRT_UIFlags.Deferred;
                    break;

                default:
                    /*
                    // Created by Unity: available in both Rendering Modes
                    case BuiltinRenderTextureType.None:
                    case BuiltinRenderTextureType.CurrentActive:
                    case BuiltinRenderTextureType.CameraTarget:
                    case BuiltinRenderTextureType.Depth:
                    case BuiltinRenderTextureType.DepthNormals:
                    case BuiltinRenderTextureType.Reflections:
                    case BuiltinRenderTextureType.MotionVectors:
                    #1#
                    _uiFlags = CRT_UIFlags.None;
                    break;
            }
        }

        private Dictionary<CRT_UIFlags, Action> FlagGUIDictionary =>
            new()
            {
                [CRT_UIFlags.None]          = DummyFunction,
                [CRT_UIFlags.HelpBox]       = RenderTargetHelpBox,
                [CRT_UIFlags.TextureID]     = TexturePropertyID,
                [CRT_UIFlags.RenderTexture] = RenderTextureGUI,
                [CRT_UIFlags.Texture2D]     = BindableTextureGUI,
                [CRT_UIFlags.Deferred]      = DeferredTextureGUI,
            };

        #endregion

        Action drawGUI;

        private void RenderTargetDataGUI()
        {
            FetchFlagAction();
            drawGUI?.Invoke();
        }

        public void FetchFlagAction()
        {
            RTTypeDictionary.TryGetValue(_rtType.intValue, out _uiFlags);
            FlagGUIDictionary.TryGetValue(_uiFlags, out drawGUI);
        }

        #region Flag GUI Functions

        private static void DummyFunction() { }

        private void RenderTargetHelpBox()
        {
            if (string.IsNullOrEmpty(Labels.HelpText))
            {
                Labels.HelpText = _rtType.intValue == (int) BuiltinRenderTextureType.BufferPtr ? Labels.BufferPtrInfo : Labels.PrepassLightSpecError;
            }

            EditorGUILayout.HelpBox(Labels.HelpText, MessageType.Info);
        }

        private bool _hideHint;
        private void   HideDeferredHint() { _hideHint = true; }
        private Action HideHint           => HideDeferredHint;

        private void DeferredTextureGUI()
        {
            if (_hideHint) return;

            FixMeBox.Draw
            (
                L10n.Tr("This BuiltinRenderTextureType only exists in the Deferred Rending Path."), MessageType.Info, HideHint, L10n.Tr("Dismiss")
            );
        }

        private void TexturePropertyID()
        {
            TextFieldWithFallback(_propertyName, Labels.PropertyIdLabel, Labels.FallbackText);
            EmbeddedRTFormat();
        }

        private void RenderTextureGUI()
        {
            EditorGUILayout.PropertyField(_renderTexture, Labels.RTLabel);
            OverrideRTFormat();
        }

        private void BindableTextureGUI()
        {
            EditorGUILayout.PropertyField(_texture2D, Labels.Texture2DLabel);
            EmbeddedRTFormat();
        }

        private void EmbeddedRTFormat() { EditorGUILayout.PropertyField(Unpack(_rtFormatParameter).value, Labels.RTFormatLabel); }

        private void OverrideRTFormat() { EditorGUILayout.PropertyField(_rtFormatParameter, Labels.RTFormatLabel); }

        #endregion
    }
}*/