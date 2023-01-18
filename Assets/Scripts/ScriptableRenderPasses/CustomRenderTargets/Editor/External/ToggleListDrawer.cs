using System;
using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(ToggleListAttribute))]
public class ToggleListDrawer : PropertyDrawer
{
    private bool show;

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        var statusProperty = GetStatusPropertyFrom(property);
        var foldoutRect = GetLinePositionFrom(position, 1);

        show = EditorGUI.Foldout(
            foldoutRect,
            show,
            string.Empty,
            false);

        statusProperty.boolValue = EditorGUI.ToggleLeft(
            foldoutRect,
            property.displayName,
            statusProperty.boolValue);

        if (show)
            RenderSubproperties(property, position);
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        if (show)
            return EditorGUIUtility.singleLineHeight * (GetBooleanPropertyCount(property) + 1);
        else
            return EditorGUIUtility.singleLineHeight;
    }

    private SerializedProperty GetStatusPropertyFrom(SerializedProperty property)
    {
        var listAttribute = attribute as ToggleListAttribute;

        var statusProperty = property.FindPropertyRelative(
            listAttribute.StatusPropertyName);

        if (statusProperty == null)
            throw new Exception($"No property named \"{listAttribute.StatusPropertyName}\" found!");

        return statusProperty;
    }

    private void RenderSubproperties(SerializedProperty property, Rect position)
    {
        var innerPosition = new Rect(
                position.x + EditorGUIUtility.standardVerticalSpacing * 4,
                position.y,
                position.width,
                position.height);

        var statusProperty = GetStatusPropertyFrom(property);
        int line = 2;

        foreach (var instance in property)
        {
            var subproperty = instance as SerializedProperty;

            if (subproperty.propertyType != SerializedPropertyType.Boolean ||
                subproperty.name == statusProperty.name)
            {
                continue;
            }

            subproperty.boolValue = EditorGUI.ToggleLeft(
                GetLinePositionFrom(innerPosition, line),
                subproperty.displayName,
                subproperty.boolValue);

            line++;
        }
    }

    private int GetBooleanPropertyCount(SerializedProperty property)
    {
        int count = 0;

        foreach (var instance in property)
        {
            var subproperty = instance as SerializedProperty;

            if (subproperty.propertyType != SerializedPropertyType.Boolean)
                continue;

            count++;
        }

        return count - 1;
    }

    private Rect GetLinePositionFrom(Rect rect, int line)
    {
        float heightModifier = EditorGUIUtility.singleLineHeight * (line - 1);

        return new Rect(
            rect.x,
            rect.y + heightModifier,
            rect.width,
            EditorGUIUtility.singleLineHeight);
    }
}