using System;
using System.Collections.Generic;
using ScriptableRenderPasses;
using UnityEngine;

public class OverrideFromAttribute : PropertyAttribute
{
    public string attributeName;

    public OverrideFromAttribute(string attributeName) { this.attributeName = attributeName; }
}

/// <seealso cref="OverrideableParameter{T}"/>
public abstract class OverrideableParameter
{
    /// <summary>
    /// A beautified string for debugger output. This is set on a <c>DebuggerDisplay</c> on every
    /// parameter types.
    /// </summary>
    public const string k_DebuggerDisplay = "{m_Value} ({m_OverrideState})";

    /// <summary>
    /// The current override state for this parameter. The Volume system considers overriden parameters
    /// for blending, and ignores non-overriden ones.
    /// </summary>
    /// <seealso cref="overrideState"/>
    [SerializeField] protected bool m_OverrideState;

    /// <summary>
    /// The current override state for this parameter. The Volume system considers overriden parameters
    /// for blending, and ignores non-overriden ones.
    /// </summary>
    /// <remarks>
    /// You can override this property to define custom behaviors when the override state changes.
    /// </remarks>
    /// <seealso cref="m_OverrideState"/>
    public bool overrideState { get => m_OverrideState; set => m_OverrideState = value; }

    internal abstract void Interp(OverrideableParameter from, OverrideableParameter to, float t);

    /// <summary>
    /// Casts and gets the typed value of this parameter.
    /// </summary>
    /// <typeparam name="T">The type of the value stored in this parameter</typeparam>
    /// <returns>A value of type <typeparamref name="T"/>.</returns>
    /// <remarks>
    /// This method is unsafe and does not do any type checking.
    /// </remarks>
    public T GetValue<T>() { return ((OverrideableParameter<T>) this).value; }

    /// <summary>
    /// Sets the value of this parameter to the value in <paramref name="parameter"/>.
    /// </summary>
    /// <param name="parameter">The <see cref="OvParameter"/> to copy the value from.</param>
    public abstract void SetValue(OverrideableParameter parameter);

    // /// <summary>
    // /// Checks if a given type is an <see cref="ObjectParameter{T}"/>.
    // /// </summary>
    // /// <param name="type">The type to check.</param>
    // /// <returns><c>true</c> if <paramref name="type"/> is an <see cref="ObjectParameter{T}"/>,
    // /// <c>false</c> otherwise.</returns>
    // public static bool IsObjectParameter(Type type)
    // {
    //     if (type.IsGenericType && type.GetGenericTypeDefinition() == typeof(OverrideableParameter<Object>))
    //         return true;
    //
    //     return type.BaseType != null
    //            && IsObjectParameter(type.BaseType);
    // }

    /// <summary>
    /// Override this method to free all allocated resources
    /// </summary>
    public virtual void Release() { }
}

public abstract class OverrideableParameter<T> : OverrideableParameter, IEquatable<OverrideableParameter<T>>
{
    /// <summary>
    /// The value stored and serialized by this parameter.
    /// </summary>
    [SerializeField] protected T m_Value;

    /// <summary>
    /// The value that this parameter stores.
    /// </summary>
    /// <remarks>
    /// You can override this property to define custom behaviors when the value is changed.
    /// </remarks>
    public virtual T value { get => m_Value; set => m_Value = value; }


    /// <summary>
    /// Creates a new <see cref="OverrideableParameter{T}"/> instance.
    /// </summary>
    protected OverrideableParameter() : this(default, false) { }

    /// <summary>
    /// Creates a new <see cref="OverrideableParameter{T}"/> instance.
    /// </summary>
    /// <param name="value">The initial value to store in the parameter.</param>
    /// <param name="overrideState">The initial override state for the parameter.</param>
    public OverrideableParameter(T value, bool overrideState)
    {
        m_Value            = value;
        this.overrideState = overrideState;
    }

    internal override void Interp(OverrideableParameter from, OverrideableParameter to, float t)
    {
        // Note: this is relatively unsafe (assumes that from and to are both holding type T)
        Interp(from.GetValue<T>(), to.GetValue<T>(), t);
    }

    /// <summary>
    /// Interpolates two values using a factor <paramref name="t"/>.
    /// </summary>
    /// <remarks>
    /// By default, this method does a "snap" interpolation, meaning it returns the value
    /// <paramref name="to"/> if <paramref name="t"/> is higher than 0, and <paramref name="from"/>
    /// otherwise.
    /// </remarks>
    /// <param name="from">The start value.</param>
    /// <param name="to">The end value.</param>
    /// <param name="t">The interpolation factor in range [0,1].</param>
    public virtual void Interp(T from, T to, float t)
    {
        // Default interpolation is naive
        m_Value = t > 0f ? to : from;
    }

    /// <summary>
    /// Sets the value for this parameter and sets its override state to <c>true</c>.
    /// </summary>
    /// <param name="x">The value to assign to this parameter.</param>
    public void Override(T x)
    {
        base.overrideState = true;
        m_Value            = x;
    }

    /// <summary>
    /// Sets the value of this parameter to the value in <paramref name="parameter"/>.
    /// </summary>
    /// <param name="parameter">The <see cref="OverrideableParameter"/> to copy the value from.</param>
    public override void SetValue(OverrideableParameter parameter) { m_Value = parameter.GetValue<T>(); }

    /// <summary>
    /// Returns a hash code for the current object.
    /// </summary>
    /// <returns>A hash code for the current object.</returns>
    public override int GetHashCode()
    {
        unchecked
        {
            int hash = 17;
            hash = hash * 23 + base.overrideState.GetHashCode();

            if (!EqualityComparer<T>.Default.Equals(value, default)) // Catches null for references with boxing of value types
                hash = hash * 23 + value.GetHashCode();

            return hash;
        }
    }

    /// <summary>
    /// Returns a string that represents the current object.
    /// </summary>
    /// <returns>A string that represents the current object.</returns>
    public override string ToString() => $"{value} ({base.overrideState})";

    #region IEquatable

    /// <summary>
    /// Compares the value in a parameter with another value of the same type.
    /// </summary>
    /// <param name="lhs">The first value in a <see cref="OverrideableParameter"/>.</param>
    /// <param name="rhs">The second value.</param>
    /// <returns><c>true</c> if both values are equal, <c>false</c> otherwise.</returns>
    public static bool operator ==(OverrideableParameter<T> lhs, T rhs) => lhs != null && !ReferenceEquals(lhs.value, null) && lhs.value.Equals(rhs);

    /// <summary>
    /// Compares the value store in a parameter with another value of the same type.
    /// </summary>
    /// <param name="lhs">The first value in a <see cref="OverrideableParameter"/>.</param>
    /// <param name="rhs">The second value.</param>
    /// <returns><c>false</c> if both values are equal, <c>true</c> otherwise</returns>
    public static bool operator !=(OverrideableParameter<T> lhs, T rhs) => !(lhs == rhs);

    /// <summary>
    /// Checks if this parameter is equal to another.
    /// </summary>
    /// <param name="other">The other parameter to check against.</param>
    /// <returns><c>true</c> if both parameters are equal, <c>false</c> otherwise</returns>
    public bool Equals(OverrideableParameter<T> other)
    {
        if (ReferenceEquals(null, other))
            return false;

        if (ReferenceEquals(this, other))
            return true;

        return EqualityComparer<T>.Default.Equals(m_Value, other.m_Value);
    }

    /// <summary>
    /// Determines whether two object instances are equal.
    /// </summary>
    /// <param name="obj">The object to compare with the current object.</param>
    /// <returns><c>true</c> if the specified object is equal to the current object, <c>false</c> otherwise.</returns>
    public override bool Equals(object obj)
    {
        if (ReferenceEquals(null, obj))
            return false;

        if (ReferenceEquals(this, obj))
            return true;

        if (obj.GetType() != GetType())
            return false;

        return Equals((OverrideableParameter<T>) obj);
    }

    #endregion
}

[Serializable]
public class RTFormatParameter : OverrideableParameter<RenderTextureFormat> { }