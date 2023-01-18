/*using System;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;

namespace ScriptableRenderPasses
{
    public static class HeaderToggle
    {
        public static class Styles
        {
            public static GUIStyle headerBackground = new("RL Header");
            public static GUIStyle emptyHeaderBackground = new("RL Empty Header");
            public static GUIStyle boxBackground = new("RL Background");
            public static GUIStyle elementBackground = new("RL Element");
        }

        static void OnContextClick(Vector2 position, Func<bool> hasMoreOptions, Action toggleMoreOptions)
        {
            var menu = new GenericMenu();

            menu.AddItem(EditorGUIUtility.TrTextContent("Show Additional Properties"), hasMoreOptions.Invoke(), () => toggleMoreOptions.Invoke());
            menu.AddItem(EditorGUIUtility.TrTextContent("Show All Additional Properties..."), false, () => CoreRenderPipelinePreferences.Open());

            menu.DropDown(new Rect(position, Vector2.zero));
        }

        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="contextAction">The context action</param>
        /// <param name="hasMoreOptions">Delegate saying if we have MoreOptions</param>
        /// <param name="toggleMoreOptions">Callback called when the MoreOptions is toggled</param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(string title, SerializedProperty group, SerializedProperty activeField,
                                Action<Vector2> contextAction = null,
                                Func<bool> hasMoreOptions = null,
                                Action toggleMoreOptions = null) =>
            Draw(EditorGUIUtility.TrTextContent(title), group, activeField, contextAction, hasMoreOptions, toggleMoreOptions, null, false);

        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="contextAction">The context action</param>
        /// <param name="hasMoreOptions">Delegate saying if we have MoreOptions</param>
        /// <param name="toggleMoreOptions">Callback called when the MoreOptions is toggled</param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(GUIContent title, SerializedProperty group, SerializedProperty activeField,
                                Action<Vector2> contextAction = null,
                                Func<bool> hasMoreOptions = null,
                                Action toggleMoreOptions = null) =>
            Draw(title, group, activeField, contextAction, hasMoreOptions, toggleMoreOptions, GUIContent.none, false);

        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="documentationURL">Documentation URL</param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(GUIContent title, SerializedProperty group, SerializedProperty activeField, string documentationURL) =>
            Draw(title, group, activeField, null, null, null, EditorGUIUtility.TrTextContent(documentationURL), false);

        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="documentationURL">Documentation URL</param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(GUIContent title, SerializedProperty group, SerializedProperty activeField, GUIContent documentationURL) =>
            Draw(title, group, activeField, null, null, null, documentationURL, true);


        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="contextAction">The context action</param>
        /// <param name="hasMoreOptions">Delegate saying if we have MoreOptions</param>
        /// <param name="toggleMoreOptions">Callback called when the MoreOptions is toggled</param>
        /// <param name="documentationURL">Documentation URL</param>
        /// <param name="overrideDocTooltip">Control whether to use title for Documentation URL tooltip.</param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(string title,
                                SerializedProperty group,
                                SerializedProperty activeField,
                                Action<Vector2> contextAction,
                                Func<bool> hasMoreOptions,
                                Action toggleMoreOptions,
                                string documentationURL,
                                bool overrideDocTooltip) =>
            Draw(EditorGUIUtility.TrTextContent(title), group, activeField, contextAction, hasMoreOptions, toggleMoreOptions,
                 EditorGUIUtility.TrTextContent(documentationURL), overrideDocTooltip);

        /// <summary>Draw a header toggle like in Volumes</summary>
        /// <param name="title"> The title of the header </param>
        /// <param name="group"> The group of the header </param>
        /// <param name="activeField">The active field</param>
        /// <param name="contextAction">The context action</param>
        /// <param name="hasMoreOptions">Delegate saying if we have MoreOptions</param>
        /// <param name="toggleMoreOptions">Callback called when the MoreOptions is toggled</param>
        /// <param name="documentationURL">Documentation URL</param>
        /// <param name="overrideDocTooltip"></param>
        /// <returns>return the state of the foldout header</returns>
        public static bool Draw(GUIContent title,
                                SerializedProperty group,
                                SerializedProperty activeField,
                                Action<Vector2> contextAction,
                                Func<bool> hasMoreOptions,
                                Action toggleMoreOptions,
                                GUIContent documentationURL,
                                bool overrideDocTooltip)
        {
            const float k_FloatMin = 1e-10f;

            const float addPadding = 2f;
            const float height = 17f + addPadding;
            var sourceRect = GUILayoutUtility.GetRect(1f, height);

            var oldIndent = EditorGUI.indentLevel;
            EditorGUI.indentLevel = 0;
            var indentedRect = EditorGUI.IndentedRect(sourceRect);
            EditorGUI.indentLevel = oldIndent;

            var labelRect = indentedRect;
            // labelRect.xMin += 32f;            
            labelRect.xMin += 16f;
            labelRect.xMax -= 20f + 16 + 5;

            var foldoutRect = indentedRect;
            foldoutRect.y      += 3f;
            foldoutRect.width  =  13f;
            foldoutRect.height =  13f;

            var toggleRect = indentedRect;
            toggleRect.x      += 16f + 3;
            toggleRect.y      += 3f;
            toggleRect.width  =  13f;
            toggleRect.height =  13f;

            // Adapted from CoreEditorUtils.HeaderDropdown
            labelRect.xMin   += CoreEditorConstants.standardHorizontalSpacing;
            foldoutRect.xMin += CoreEditorConstants.standardHorizontalSpacing;
            var xMin = indentedRect.xMin;
            indentedRect.xMin  =  Math.Abs(xMin - 7.0) < k_FloatMin ? 4.0f : EditorGUIUtility.singleLineHeight;
            indentedRect.width -= 1;

            // Background rect should be full-width
            // backgroundRect.xMin  =  sourceRect.xMin;
            // backgroundRect.width += 4f;

            // Background
            // float backgroundTint = EditorGUIUtility.isProSkin ? 0.1f : 1f;
            // EditorGUI.DrawRect(indentedRect, new Color(backgroundTint, backgroundTint, backgroundTint, 0.2f));
            DrawHeaderBackground(indentedRect);

            // Title
            using (new EditorGUI.DisabledScope(!activeField.boolValue))
            {
                DrawHeader(labelRect, title, group, EditorStyles.boldLabel);
            }

            // Foldout
            group.serializedObject.Update();
            group.isExpanded = GUI.Toggle(foldoutRect, group.isExpanded, GUIContent.none, EditorStyles.foldout);
            group.serializedObject.ApplyModifiedProperties();

            // Active checkbox
            activeField.serializedObject.Update();
            activeField.boolValue = GUI.Toggle(toggleRect, activeField.boolValue, GUIContent.none, CoreEditorStyles.smallTickbox);
            activeField.serializedObject.ApplyModifiedProperties();

            // Context menu
            var contextMenuIcon = CoreEditorStyles.contextMenuIcon.image;
            var contextMenuRect = new Rect(labelRect.xMax + 3f + 16 + 10, labelRect.y + 1f + addPadding, 16, 16);

            if (contextAction == null && hasMoreOptions != null)
            {
                // If no contextual menu add one for the additional properties.
                contextAction = pos => OnContextClick(pos, hasMoreOptions, toggleMoreOptions);
            }

            if (contextAction != null)
            {
                if (GUI.Button(contextMenuRect, contextMenuIcon, CoreEditorStyles.contextMenuStyle))
                    contextAction(new Vector2(contextMenuRect.x, contextMenuRect.yMax));
            }

            // Documentation button
            if (!overrideDocTooltip)
            {
                // original behavior
                CustomGUI.ShowHelpButton(contextMenuRect, (string) documentationURL.text, title);
            }
            else
            {
                CustomGUI.ShowHelpButton(contextMenuRect, documentationURL);
            }

            // Handle events
            var e = Event.current;

            if (e.type == EventType.MouseDown)
            {
                if (indentedRect.Contains(e.mousePosition))
                {
                    // Left click: Expand/Collapse
                    if (e.button == 0)
                        group.isExpanded = !group.isExpanded;
                    // Right click: Context menu
                    else if (contextAction != null)
                        contextAction(e.mousePosition);

                    e.Use();
                }
            }

            /*
            EditorGUI.DrawRect(sourceRect, new Color(1, 0, 0, .2f));
            EditorGUI.DrawRect(indentedRect, new Color(0, 0, 1, .2f));
            EditorGUI.DrawRect(labelRect, new Color(0, 1, 0, .2f));
            EditorGUI.DrawRect(foldoutRect, new Color(1, 0.92f, 0.016f, .2f));
            EditorGUI.DrawRect(toggleRect, new Color(.2f, .2f, .2f, .2f));
            EditorGUI.DrawRect(contextMenuRect, new Color(1, 0, 1, 0.2f));
            #1#


            return group.isExpanded;
        }

        // From ReorderableList
        public static void DrawHeaderBackground(Rect headerRect)
        {
            if (Event.current.type != EventType.Repaint)
                return;
            if ((double) headerRect.height < 5.0)
                Styles.emptyHeaderBackground.Draw(headerRect, false, false, false, false);
            else
                Styles.headerBackground.Draw(headerRect, false, false, false, false);
        }

        public static void DrawHeader(
            Rect headerRect,
            GUIContent header,
            SerializedProperty element,
            GUIStyle style)
        {
            EditorGUI.LabelField(headerRect, EditorGUIUtility.TrTempContent(element != null ? header.text : "Custom Render Target"), style);
        }

        public static void DrawActiveBackground(
            Rect rect,
            bool selected,
            bool focused,
            GUIStyle style)
        {
            if (Event.current.type != EventType.Repaint)
                return;
            style.Draw(rect, false, selected, selected, focused);
        }
    } 
    
    public static class SubHeaderFoldout
    {
        /// <summary>
        /// Draw a foldout sub header with a SerializedProperty.
        /// </summary>
        /// <param name="property"></param>
        /// <param name="title"> The title of the header </param>
        /// <param name="state"> The state of the header </param>
        /// <param name="isBoxed"> [optional] is the eader contained in a box style ? </param>
        /// <returns>return the state of the sub foldout header</returns>
        public static bool Draw(SerializedProperty property, GUIContent title, bool state, bool isBoxed = false)
        {
            const float height = 17f;
            var backgroundRect = GUILayoutUtility.GetRect(1f, height);

            var labelRect = backgroundRect;
            labelRect.xMin += 16f;
            labelRect.xMax -= 20f;

            var foldoutRect = backgroundRect;
            foldoutRect.y      += 1f;
            foldoutRect.x      += 15 * EditorGUI.indentLevel; //GUI do not handle indent. Handle it here
            foldoutRect.width  =  13f;
            foldoutRect.height =  13f;

            // Background rect should be full-width
            backgroundRect.xMin  =  0f;
            backgroundRect.width += 4f;

            if (isBoxed)
            {
                labelRect.xMin       += 5;
                foldoutRect.xMin     += 5;
                backgroundRect.xMin  =  EditorGUIUtility.singleLineHeight;
                backgroundRect.width -= 3;
            }

            // Title
            using (new EditorGUILayout.HorizontalScope())
            {
                EditorGUI.LabelField(labelRect, title, EditorStyles.boldLabel);
                EditorGUI.PropertyField(labelRect, property, CoreEditorStyles.empty);
            }

            // Active checkbox
            state = GUI.Toggle(foldoutRect, state, GUIContent.none, EditorStyles.foldout);

            var e = Event.current;
            if (e.type == EventType.MouseDown && backgroundRect.Contains(e.mousePosition) && e.button == 0)
            {
                state = !state;
                e.Use();
            }

            return state;
        }
    }

}*/