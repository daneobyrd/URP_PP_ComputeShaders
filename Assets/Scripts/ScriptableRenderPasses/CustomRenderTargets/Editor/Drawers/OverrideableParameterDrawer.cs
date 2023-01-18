/*using System;
using ScriptableRenderPasses;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.Experimental.Rendering;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using SerializedDataParameter = ScriptableRenderPasses.SerializedDataParameter;
using static SerializedPropUtil;

[CustomPropertyDrawer(typeof(OverrideableParameter))]
public abstract class OverrideableParameterDrawerBase : PropertyDrawer
{
    // Override this and return false if you want to customize the override checkbox position,
    // else it'll automatically draw it and put the property content in a horizontal scope.

    /// <summary>
    /// Override this and return <c>false</c> if you want to customize the position of the override
    /// checkbox. If you don't, Unity automatically draws the checkbox and puts the property content in a
    /// horizontal scope.
    /// </summary>
    /// <returns><c>false</c> if the override checkbox position is customized, <c>true</c>
    /// otherwise</returns>
    public virtual bool IsAutoProperty() => true;

    /// <summary>
    /// Draws the parameter in the editor. If the input parameter is invalid you should return
    /// <c>false</c> so that Unity displays the default editor for this parameter.
    /// </summary>
    /// <param name="property">The parameter to draw.</param>
    /// <param name="title">The label and tooltip of the parameter.</param>
    /// <returns><c>true</c> if the input parameter is valid, <c>false</c> otherwise in which
    /// case Unity will revert to the default editor for this parameter</returns>
    public virtual void OnPropertyGUI(SerializedDataParameter property, GUIContent title) { }
}

public abstract class OverrideableParameterDrawer : OverrideableParameterDrawerBase
{
    // private const string m_Override = "m_OverrideState";
    // private const string m_Value = "m_Value";
    public SerializedDataParameter DataParameter;
    protected SerializedProperty OverrideState { get; set; }
    protected SerializedProperty Value         { get; set; }

    #region Style & Layout

    public class Styles
    {
        public static GUIContent overrideSettingText { get; } = EditorGUIUtility.TrTextContent("", "Override this setting for this field.");

        // public static GUIContent allText { get; } = EditorGUIUtility.TrTextContent
        //     ("ALL", "Toggle all overrides on. To maximize performances you should only toggle overrides that you actually need.");
        // public static GUIContent noneText { get; } = EditorGUIUtility.TrTextContent("NONE", "Toggle all overrides off.");
        // public static string toggleAllText { get; } = L10n.Tr("Toggle All");

        public const int overrideCheckboxWidth = 14;
        public const int overrideCheckboxOffset = 9;
    }

    static Vector2? m_OverrideToggleSize;

    private static Vector2 OverrideToggleSize
    {
        get
        {
            if (!m_OverrideToggleSize.HasValue)
                m_OverrideToggleSize = CoreEditorStyles.smallTickbox.CalcSize(Styles.overrideSettingText);
            return m_OverrideToggleSize.Value;
        }
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        return EditorGUI.GetPropertyHeight(property, label, true);
    }

    #endregion

    private void Init(SerializedProperty property)
    {
        DataParameter = Unpack(property);
        OverrideState = DataParameter.overrideState;
        Value         = DataParameter.value;
    }

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        Init(property);
        EditorGUILayout.BeginHorizontal();

        IDisposable indentScope = null;
        IDisposable disabledScope = null;

        HandleDecorators(DataParameter, label);

        var relativeIndentation = EditorGUI.indentLevel;
        if (relativeIndentation != 0)
        {
            indentScope = new IndentLevelScope(relativeIndentation * 15);
        }

        // var doOverride = OverrideState.boolValue = GetOverrideCheckbox(DataParameter.value);
        DrawOverrideCheckbox(DataParameter);
        var doOverride = OverrideState.boolValue;

        disabledScope = new EditorGUI.DisabledScope(!doOverride);

        var sourceAsset = GetOverrideFromProp(property);

        switch (doOverride)
        {
            case false when CheckValid(sourceAsset):
                ApplyOverride(Value, sourceAsset);

                EditorGUILayout.PropertyField(Value, label);
                
                // IDisposable
                disabledScope?.Dispose();
                indentScope?.Dispose();

                EditorGUILayout.EndHorizontal();
                break;
            case false: // Invalid RenderTexture asset format
                ApplyOverride(Value, sourceAsset);
                EditorGUILayout.PropertyField(Value, label);

                // IDisposable
                disabledScope?.Dispose();

                EditorGUILayout.EndHorizontal();

                // FixMeBox on new line outside of the disabled scope
                FixInvalid(sourceAsset, Value);
                
                indentScope?.Dispose();
                break;
            default:
                EditorGUILayout.PropertyField(Value, label);

                // IDisposable
                disabledScope?.Dispose();
                indentScope?.Dispose();

                EditorGUILayout.EndHorizontal();
                break;
        }
        
        EditorGUIUtility.labelWidth += Styles.overrideCheckboxWidth + Styles.overrideCheckboxOffset + 3 + 3;
    }

    protected virtual bool CheckValid(SerializedProperty overrideFrom)                                  { throw new NotImplementedException(); }
    protected virtual void FixInvalid(SerializedProperty overrideFrom, SerializedProperty newValueProp) { throw new NotImplementedException(); }

    private SerializedProperty GetOverrideFromProp(SerializedProperty property)
    {
        var attributes = fieldInfo.GetCustomAttributes(true);
        if (Array.Find(attributes, attr => attr is OverrideFromAttribute) is not OverrideFromAttribute overrideFrom)
        {
            throw new Exception($"OverrideableParameter {property.name} doesn't have the OverrideFrom attribute");
        }

        return property.GetSibling(overrideFrom.attributeName);
    }

    protected abstract void ApplyOverride(SerializedProperty valueProp, SerializedProperty overrideFrom);

    #region GUIFunctions

    public override void OnPropertyGUI(SerializedDataParameter property, GUIContent title)
    {
        if (!string.IsNullOrEmpty(property.displayName))
            PropertyField(DataParameter, new GUIContent(property.displayName));
        else
            PropertyField(DataParameter, title);
    }

    /// <summary>
    /// Draws a given <see cref="SerializedDataParameter"/> in the editor.
    /// </summary>
    /// <param name="propertyData">The property to draw in the editor</param>
    /// <returns>true if the property field has been rendered</returns>
    private static bool PropertyField(SerializedDataParameter propertyData)
    {
        var title = EditorGUIUtility.TrTextContent
        (
            propertyData.displayName,
            propertyData.GetAttribute<TooltipAttribute>()
                        ?.tooltip
        ); // avoid property from getting the tooltip of another one with the same name
        return PropertyField(propertyData, title);
    }

    /// <summary>
    /// Draws a given <see cref="SerializedDataParameter"/> in the editor using a custom label and tooltip.
    /// </summary>
    /// <param name="propertyData">The property to draw in the editor.</param>
    /// <param name="title">A custom label and/or tooltip.</param>
    /// <returns>true if the property field has been rendered</returns>
    private static bool PropertyField(SerializedDataParameter propertyData, GUIContent title)
    {
        // if (IsAutoProperty())
        // return DrawEmbeddedField(property, title);
        // else
        return DrawPropertyField(propertyData, title);
    }

    /// <summary>
    /// Handles unity built-in decorators (Space, Header, Tooltips, ...) from <see cref="SerializedDataParameter"/> attributes
    /// </summary>
    /// <param name="propertyData">The property to obtain the attributes and handle the decorators</param>
    /// <param name="title">A custom label and/or tooltip that might be updated by <see cref="TooltipAttribute"/> and/or by <see cref="InspectorNameAttribute"/></param>
    public static void HandleDecorators(SerializedDataParameter propertyData, GUIContent title)
    {
        foreach (var attr in propertyData.attributes)
        {
            if (!(attr is PropertyAttribute))
                continue;

            switch (attr)
            {
                case SpaceAttribute spaceAttribute:
                    EditorGUILayout.GetControlRect(false, spaceAttribute.height);
                    break;
                case HeaderAttribute headerAttribute:
                    DrawHeader(headerAttribute.header);
                    break;
                case TooltipAttribute tooltipAttribute:
                    if (string.IsNullOrEmpty(title.tooltip))
                        title.tooltip = tooltipAttribute.tooltip;
                    break;
                case InspectorNameAttribute inspectorNameAttribute:
                    title.text = inspectorNameAttribute.displayName;
                    break;
            }
        }
    }

    /// <summary>
    /// Draws a header into the inspector with the given title
    /// </summary>
    /// <param name="header">The title for the header</param>
    protected static void DrawHeader(string header)
    {
        var content = EditorGUIUtility.TrTextContent(header);
        var rect = EditorGUI.IndentedRect(EditorGUILayout.GetControlRect(false, EditorGUIUtility.singleLineHeight));
        EditorGUI.LabelField(rect, content, EditorStyles.miniLabel);
    }

    /// <summary>
    /// Draws a given <see cref="SerializedDataParameter"/> in the editor using a custom label
    /// and tooltip.
    /// </summary>
    /// <param name="propertyData">The property to draw in the editor.</param>
    /// <param name="title">A custom label and/or tooltip.</param>
    public static bool DrawPropertyField(SerializedDataParameter propertyData, GUIContent title)
    {
        using (var scope = new OverrideablePropertyScope(propertyData, title))
        {
            // if (!scope.Displayed)
            //     return false;

            // Custom drawer
            // if (Instance?.OnPropertyGUI(property, title) ?? false)
            // return true;

            // Standard Unity drawer
            EditorGUILayout.PropertyField(propertyData.value, title);
        }

        return true;
    }

    /// <summary>
    /// Draws the override checkbox used by a property in the editor.
    /// </summary>
    /// <param name="propertyData">The property to draw the override checkbox for</param>
    public static void DrawOverrideCheckbox(SerializedDataParameter propertyData)
    {
        // Create a rect the height + vspacing of the property that is being overriden
        float height = EditorGUI.GetPropertyHeight(propertyData.value) + EditorGUIUtility.standardVerticalSpacing;
        // float height = EditorGUIUtility.singleLineHeight;
        var overrideRect = GUILayoutUtility.GetRect
        (
            GUIContent.none, CoreEditorStyles.miniLabelButton, GUILayout.Height(height),
            GUILayout.Width(Styles.overrideCheckboxWidth + Styles.overrideCheckboxOffset),
            GUILayout.ExpandWidth(false)
        );

        // also center vertically the checkbox
        overrideRect.yMin += height * 0.5f - OverrideToggleSize.y * 0.5f;
        overrideRect.xMin += Styles.overrideCheckboxOffset;

        var overridenField = propertyData.overrideState.boolValue;
        var toggleValue = GUI.Toggle(overrideRect, overridenField, Styles.overrideSettingText, CoreEditorStyles.smallTickbox);
        propertyData.overrideState.boolValue = toggleValue;
    }

    #endregion

    #region OverrideablePropertyScope

    /// <summary>
    /// Scope for property that handle:
    /// - Layout decorator (Space, Header)
    /// - Naming decorator (Tooltips, InspectorName)
    /// - Overridable checkbox if parameter IsAutoProperty
    /// - disabled GUI if Overridable checkbox (case above) is unchecked
    /// - additional property scope
    /// This is automatically used inside PropertyField method
    /// </summary>
    public struct OverrideablePropertyScope : IDisposable
    {
        private IDisposable _disabledScope;
        private readonly IDisposable _indentScope;

        /*
        /// <summary>
        /// Either the content property will be displayed or not (can varry with additional property settings)
        /// </summary>
        public bool Displayed { get; private set; }
        #1#

        /// <summary>
        /// The title modified regarding attribute used on the field
        /// </summary>
        private GUIContent Label { get; set; }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="propertyData">The property that will be drawn</param>
        /// <param name="label">The label of this property</param>
        public OverrideablePropertyScope(SerializedDataParameter propertyData, GUIContent label)
        {
            _disabledScope = null;
            _indentScope   = null;
            // Displayed = false;
            Label = label;

            Init(propertyData, Label);
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="propertyData">The property that will be drawn</param>
        /// <param name="label">The label of this property</param>
        public OverrideablePropertyScope(SerializedDataParameter propertyData, string label) : this()
        {
            _disabledScope = null;
            _indentScope   = null;
            // Displayed = false;
            Label = EditorGUIUtility.TrTextContent(label);

            Init(propertyData, Label);
        }

        private void Init(SerializedDataParameter propertyData, GUIContent label)
        {
            // Below, 3 is horizontal spacing and there is one between label and field and another between override checkbox and label
            EditorGUIUtility.labelWidth -= Styles.overrideCheckboxWidth + Styles.overrideCheckboxOffset + 3 + 3;

            // Displayed = !(Drawer?.IsAutoProperty() ? true);

            // if (Displayed)
            {
                HandleDecorators(propertyData, label);

                var relativeIndentation = EditorGUI.indentLevel;
                if (relativeIndentation != 0)
                {
                    var indentScope = new IndentLevelScope(relativeIndentation * 15);
                }

                EditorGUILayout.BeginHorizontal();
                DrawOverrideCheckbox(propertyData);

                _disabledScope = new EditorGUI.DisabledScope(!propertyData.overrideState.boolValue);
            }
        }

        /// <summary>
        /// Dispose
        /// </summary>
        void IDisposable.Dispose()
        {
            _disabledScope?.Dispose();
            _indentScope?.Dispose();

            // if (!HaveCustomOverrideCheckbox && Displayed)
            EditorGUILayout.EndHorizontal();

            // if (isAdditionalProperty)
            // editor.EndAdditionalPropertiesScope();

            EditorGUIUtility.labelWidth += Styles.overrideCheckboxWidth + Styles.overrideCheckboxOffset + 3 + 3;
        }
    }

    /// <summary>
    /// Like EditorGUI.IndentLevelScope but this one will also indent the override checkboxes.
    /// </summary>
    private class IndentLevelScope : GUI.Scope
    {
        int m_Offset;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="offset">[optional] Change the indentation offset</param>
        public IndentLevelScope(int offset = 15)
        {
            m_Offset = offset;

            // When using EditorGUI.indentLevel++, the clicking on the checkboxes does not work properly due to some issues on the C++ side.
            // This scope is a work-around for this issue.
            GUILayout.BeginHorizontal();
            EditorGUILayout.Space(offset, false);
            GUIStyle style = new GUIStyle();
            // GUILayout.BeginVertical(style);
            GUILayout.BeginHorizontal(style);
            EditorGUIUtility.labelWidth -= m_Offset;
        }

        /// <summary>
        /// Dispose
        /// </summary>
        protected override void CloseScope()
        {
            EditorGUIUtility.labelWidth += m_Offset;
            // GUILayout.EndVertical();
            GUILayout.EndHorizontal();
            GUILayout.EndHorizontal();
        }
    }

    #endregion
}


[CustomPropertyDrawer(typeof(RTFormatParameter))]
public class RTParameterDrawer : OverrideableParameterDrawer
{
    // public override bool IsAutoProperty() { return true; }

    protected override bool CheckValid(SerializedProperty overrideFrom)
    {
        var renderTexture = (RenderTexture) overrideFrom.objectReferenceValue;

        var format = renderTexture.format;
        // var graphicsFormat = renderTexture.graphicsFormat;
        renderTexture.Release();

        if (!RenderingUtils.SupportsRenderTextureFormat(format))
        {
            return false;
        }

        return true;
        // return RenderingUtils.SupportsGraphicsFormat(graphicsFormat, FormatUsage.Render);
    }

    protected override void FixInvalid(SerializedProperty overrideFrom, SerializedProperty newValueProp)
    {
        var renderTexture = (RenderTexture) overrideFrom.objectReferenceValue;

        GUI.enabled = true;
        FixMeBox.Draw
        (
            L10n.Tr($"{renderTexture.graphicsFormat} is not supported by your graphics card."),
            MessageType.Warning,
            RequestCompatibleFormat,
            L10n.Tr("Use Compatible Format")
        );
        GUI.enabled = false;

        // Declare and Initialize outside of RequestCompatibleFormat()
        RenderTextureFormat rtFormat = renderTexture.format;

        void RequestCompatibleFormat()
        {
            // var formatUsageProperty = valueProp.GetSibling("_formatUsage");
            // var formatUsage = formatUsageProperty.GetEnumValue<FormatUsage>();

            OverrideState.boolValue = true;
            rtFormat                = GetCompatibleRTFormat(renderTexture.format);
        }

        newValueProp.SetEnumValue(rtFormat);
        renderTexture.Release();
    }

    // Adapted from RenderTexture.cs and GraphicsFormatUtility.cs
    private static GraphicsFormat GetCompatibleFormat(RenderTextureFormat renderTextureFormat)
    {
        if (renderTextureFormat == RenderTextureFormat.Depth) { return GraphicsFormat.None; }
        GraphicsFormat graphicsFormat = GraphicsFormatUtility.GetGraphicsFormat(renderTextureFormat, RenderTextureReadWrite.Default);
        if (graphicsFormat == GraphicsFormat.None) { return graphicsFormat; }

        GraphicsFormat compatibleFormat = SystemInfo.GetCompatibleFormat(graphicsFormat, FormatUsage.Render);
        return graphicsFormat == compatibleFormat ? graphicsFormat : compatibleFormat;

        /*Debug.LogWarning
        (
            (object) string.Format
            (
                "'{0}' is not supported. RenderTexture::GetTemporary fallbacks to {1} format on this platform. Use 'SystemInfo.IsFormatSupported' C# API to check format support.",
                (object) graphicsFormat.ToString(),
                (object) compatibleFormat.ToString()
            )
        );#1#
    }

    private static RenderTextureFormat GetCompatibleRTFormat(RenderTextureFormat renderTextureFormat) =>
        GraphicsFormatUtility.GetRenderTextureFormat(GetCompatibleFormat(renderTextureFormat));
    
    protected override void ApplyOverride(SerializedProperty valueProp, SerializedProperty overrideFrom)
    {
        var overrideReferenceValue = overrideFrom.objectReferenceValue;
        if (!overrideReferenceValue) return;

        var renderTexture = (RenderTexture) overrideReferenceValue;

        // Only accept 2D RenderTextures
        if (renderTexture.dimension != TextureDimension.Tex2D) return;

        valueProp.SetEnumValue(renderTexture.format);
    }
}

public static class SerializedPropUtil
{
    public static SerializedProperty GetSibling(this SerializedProperty prop, string siblingName)
    {
        var lastSeparatorIdx = prop.propertyPath.LastIndexOf('.');

        if (lastSeparatorIdx == -1)
        {
            return prop.serializedObject.FindProperty(siblingName);
        }

        return prop.serializedObject.FindProperty(prop.propertyPath.Substring(0, lastSeparatorIdx + 1) + siblingName);
    }

    /// <summary>
    /// Generates and auto-populates a <see cref="SerializedDataParameter"/> from a serialized
    /// <see cref="OverrideableParameter"/>.
    /// </summary>
    /// <param name="property">A serialized property holding a <see cref="OverrideableParameter{T}"/>
    /// </param>
    /// <returns></returns>
    public static SerializedDataParameter Unpack(SerializedProperty property)
    {
        Assert.IsNotNull(property);
        return new SerializedDataParameter(property);
    }
}*/