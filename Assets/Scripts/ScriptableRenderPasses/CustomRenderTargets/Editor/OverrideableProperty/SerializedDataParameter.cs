using System;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine.Assertions;

namespace ScriptableRenderPasses
{
    /// <summary>
    /// A serialization wrapper for <see cref="OverrideableParameter{T}"/>.
    /// </summary>
    public sealed class SerializedDataParameter
    {
        /// <summary>
        /// The serialized property for <see cref="OverrideableParameter.overrideState"/>.
        /// </summary>
        public SerializedProperty overrideState { get; private set; }

        /// <summary>
        /// The serialized property for <see cref="OverrideableParameter{T}.value"/>
        /// </summary>
        public SerializedProperty value { get; private set; }

        /// <summary>
        /// A pre-fetched list of all the attributes applied on the <see cref="OverrideableParameter{T}"/>.
        /// </summary>
        public Attribute[] attributes { get; private set; }

        /// <summary>
        /// The actual type of the serialized <see cref="OverrideableParameter{T}"/>.
        /// </summary>
        public Type referenceType { get; private set; }

        SerializedProperty m_BaseProperty;
        object m_ReferenceValue;

        /// <summary>
        /// The generated display name of the <see cref="OverrideableParameter{T}"/> for the inspector.
        /// </summary>
        public string displayName => m_BaseProperty.displayName;

        internal SerializedDataParameter(SerializedProperty property)
        {
            // Find the actual property type, optional attributes & reference
            var path = property.propertyPath.Split('.');
            object obj = property.serializedObject.targetObject;
            FieldInfo field = null;

            foreach (var p in path)
            {
                field = obj.GetType().GetField(p, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                obj   = field.GetValue(obj);
            }

            Assert.IsNotNull(field);

            m_BaseProperty   = property.Copy();
            overrideState    = m_BaseProperty.FindPropertyRelative("m_OverrideState");
            value            = m_BaseProperty.FindPropertyRelative("m_Value");
            attributes       = field.GetCustomAttributes(true).Cast<Attribute>().ToArray();
            referenceType    = obj.GetType();
            m_ReferenceValue = obj;
        }

        /// <summary>
        /// Gets and casts an attribute applied on the base <see cref="OverrideableParameter{T}"/>.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <returns></returns>
        public T GetAttribute<T>()
            where T : Attribute
        {
            return (T) attributes.FirstOrDefault(x => x is T);
        }

        /// <summary>
        /// Gets and casts the underlying reference of type <typeparamref name="T"/>.
        /// </summary>
        /// <typeparam name="T">The type to cast to</typeparam>
        /// <returns>The reference to the serialized <see cref="OverrideableParameter{T}"/> type</returns>
        public T GetObjectRef<T>() { return (T) m_ReferenceValue; }

    }
}