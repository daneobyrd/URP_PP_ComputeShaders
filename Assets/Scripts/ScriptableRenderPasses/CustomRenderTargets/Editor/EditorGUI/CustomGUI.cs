/*using System.Linq;
using UnityEditor.Rendering;

namespace ScriptableRenderPasses
{
    using UnityEditor;
    using UnityEngine;

    public static class CustomGUI
    {
        public static void InlineFields(SerializedProperty prop1, GUIContent prop1Label, SerializedProperty prop2, GUIContent prop2Label)
        {
            using (new EditorGUILayout.HorizontalScope())
            {
                EditorGUILayout.PropertyField(prop1, prop1Label);
                EditorGUILayout.PropertyField(prop2, prop2Label);
            }
        }

        // Adapted from CoreEditorUtils
        public static void ShowHelpButton(Rect contextMenuRect, string documentationURL, GUIContent title)
        {
            if (string.IsNullOrEmpty(documentationURL))
                return;

            var documentationRect = contextMenuRect;
            documentationRect.x -= 16 + 2;

            var documentationIcon = new GUIContent(CoreEditorStyles.iconHelp, $"Open Reference for {title.text}.");

            if (GUI.Button(documentationRect, documentationIcon, CoreEditorStyles.iconHelpStyle))
                Help.BrowseURL(documentationURL);
        }

        // Adapted from CoreEditorUtils
        public static void ShowHelpButton(Rect contextMenuRect, GUIContent documentationURL)
        {
            if (string.IsNullOrEmpty(documentationURL.text)
                && string.IsNullOrEmpty(documentationURL.tooltip))
                return;

            var documentationRect = contextMenuRect;
            documentationRect.x -= 16 + 2;

            var documentationIcon = new GUIContent(CoreEditorStyles.iconHelp, $"Open Reference for {documentationURL.tooltip}.");

            if (GUI.Button(documentationRect, documentationIcon, CoreEditorStyles.iconHelpStyle))
                Help.BrowseURL(documentationURL.text);
        }
        
        public static void ToggleLeft(Rect position, SerializedProperty property, GUIContent label, GUIStyle style)
        {
            bool toggle = property.boolValue;
            EditorGUI.BeginProperty(position, label, property);
            using (var check = new EditorGUI.ChangeCheckScope())
            {
                int oldIndent = EditorGUI.indentLevel;
                EditorGUI.indentLevel = 0;
                toggle                = EditorGUI.ToggleLeft(position, label, toggle, style);
                EditorGUI.indentLevel = oldIndent;
                if (check.changed)
                {
                    property.boolValue = property.hasMultipleDifferentValues || !property.boolValue;
                }
            }

            EditorGUI.EndProperty();
        }
        
        public static void TextFieldWithFallback(SerializedProperty textProperty, GUIContent label, string nullEmptyFallback)
        {
            if (string.IsNullOrEmpty(textProperty.stringValue))
            {
                textProperty.stringValue = nullEmptyFallback;
            }

            EditorGUILayout.PropertyField(textProperty, label);
        }

        // From RenderFeaturesEditor
        public static void ForceSave(Object target)
        {
            EditorUtility.SetDirty(target);
        }

        // From CoreEditorUtils
        /*
        public static float GetLongestLabelWidth(GUIContent[] labels)
        {
            var labelWidth = 0.0f;
            for (var i = 0; i < labels.Length; ++i)
                labelWidth = Mathf.Max(EditorStyles.label.CalcSize(labels[i]).x, labelWidth);
            return labelWidth;
        }
        #1#

        // Rider Suggested Simplification of GetLongestLabelWidth
        public static float GetLongestLabelWidth(GUIContent[] labels)
        {
            return labels.Aggregate(0.0f, (current, t) => Mathf.Max(EditorStyles.label.CalcSize(t).x, current));
        }

        // From CoreEditorUtils
        public static float GetLabelWidth(GUIContent label)
        {
            var labelWidth = 0.0f;
            labelWidth = Mathf.Max(EditorStyles.label.CalcSize(label).x, labelWidth);
            return labelWidth;
        }
    }

}*/