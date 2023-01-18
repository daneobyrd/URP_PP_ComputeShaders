using System.ComponentModel;
using UnityEditor;
using UnityEngine;

namespace ScriptableRenderPasses
{
    public class HorizontalToggleGroup
    {

        /// <summary>
        ///   <para>Begin a horizontal group with a toggle to enable or disable all the controls within at once.</para>
        /// </summary>
        /// <param name="label">Label to show above the toggled controls.</param>
        /// <param name="toggle">Enabled state of the toggle group.</param>
        /// <returns>
        ///   <para>The enabled state selected by the user.</para>
        /// </returns>
        public static bool BeginGroup([DefaultValue("GUIContent.none")] GUIContent label, bool toggle)
        {
            EditorGUILayout.BeginHorizontal();
            toggle = EditorGUILayout.ToggleLeft(label, toggle);
            EditorGUI.BeginDisabledGroup(!toggle);
            return toggle;
        }

        /// <summary>
        ///   <para>Begin a horizontal group with a toggle to enable or disable all the controls within at once.</para>
        /// </summary>
        /// <param name="toggle">Enabled state of the toggle group.</param>
        /// <returns>
        ///   <para>The enabled state selected by the user.</para>
        /// </returns>
        public static bool BeginGroup(bool toggle)
        {
            EditorGUILayout.BeginHorizontal();
            toggle = EditorGUILayout.ToggleLeft(GUIContent.none, toggle);
            EditorGUI.BeginDisabledGroup(!toggle);
            return toggle;
        }

        /// <summary>
        ///   <para>Begin a horizontal group with a toggle to enable or disable all the controls within at once.</para>
        /// </summary>
        /// <param name="label">Label to show above the toggled controls.</param>
        /// <param name="toggle">Enabled state of the toggle group.</param>
        /// <returns>
        ///   <para>The enabled state selected by the user.</para>
        /// </returns>
        public static bool BeginGroup(string label, bool toggle) => BeginGroup(new GUIContent(label), toggle);

        /// <summary>
        ///   <para>Close a group started with BeginHorizontalToggleGroup.</para>
        /// </summary>
        public static void EndGroup()
        {
            EditorGUI.EndDisabledGroup();
            EditorGUILayout.EndHorizontal();
        }

    }

    /// <summary>
    ///   <para>Begin a horizontal group with a toggle to enable or disable all the controls within at once.</para>
    /// </summary>
    public class HorizontalToggleGroupScope : GUI.Scope
    {
        /// <summary>
        ///   <para>The enabled state selected by the user.</para>
        /// </summary>
        public bool enabled { get; protected set; }


        /// <param name="label">Label to show to the right of the toggled control.</param>
        /// <param name="toggle">Enabled state of the toggle group.</param>
        public HorizontalToggleGroupScope(string label, bool toggle) => enabled = HorizontalToggleGroup.BeginGroup(label, toggle);
        
        /// <param name="label">Label to show to the right of the toggled control.</param>
        /// <param name="toggle">Enabled state of the toggle group.</param>
        public HorizontalToggleGroupScope(GUIContent label, bool toggle) => enabled = HorizontalToggleGroup.BeginGroup(label, toggle);
        
        /// <param name="toggle">Enabled state of the toggle group.</param>
        public HorizontalToggleGroupScope(bool toggle) => enabled = HorizontalToggleGroup.BeginGroup(toggle);


        protected override void CloseScope() => HorizontalToggleGroup.EndGroup();
    }
}