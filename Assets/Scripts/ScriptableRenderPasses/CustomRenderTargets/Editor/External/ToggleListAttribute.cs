using UnityEngine;

public class ToggleListAttribute : PropertyAttribute
{
    public string StatusPropertyName { get; private set; }

    public ToggleListAttribute(string statusPropertyName)
    {
        StatusPropertyName = statusPropertyName;
    }
}