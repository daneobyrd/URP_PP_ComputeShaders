/*using System;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;

namespace ScriptableRenderPasses
{
    public static class FixMeBox
    {
        private static readonly GUIStyle HelpBoxLabelStyle = new(EditorStyles.miniLabel) {wordWrap = true};

        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="messageText">The message text.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        public static void Draw(string messageText, Action action) { Draw(messageText, MessageType.Warning, action); }

        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="messageText">The message text.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        /// <param name="buttonText">Text displayed within the button.</param>
        public static void Draw(string messageText, Action action, string buttonText) { Draw(messageText, MessageType.Warning, action, buttonText); }

        // UI Helpers
        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="message">The message with icon if need.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        /// <param name="buttonText">Text displayed within the button.</param>
        public static void Draw(GUIContent message, Action action, string buttonText = "Fix")
        {
            GUILayout.Space(2);
            using (new EditorGUILayout.HorizontalScope(EditorStyles.helpBox))
            {
                EditorGUILayout.LabelField(message, HelpBoxLabelStyle);
                GUILayout.FlexibleSpace();
                using (new EditorGUILayout.VerticalScope())
                {
                    GUILayout.FlexibleSpace();

                    if (GUILayout.Button(buttonText, GUILayout.Width(60)))
                        action();

                    GUILayout.FlexibleSpace();
                }
            }

            GUILayout.Space(5);
        }

        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="text">The message text.</param>
        /// <param name="messageType">The type of the message.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        public static void Draw(string text, MessageType messageType, Action action)
        {
            Draw(EditorGUIUtility.TrTextContentWithIcon(text, GetIcon(messageType)), action);
        }

        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="text">The message text.</param>
        /// <param name="messageType">The type of the message.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        /// <param name="buttonText">Text displayed within the button.</param>
        public static void Draw(string text, MessageType messageType, Action action, string buttonText)
        {
            Draw(EditorGUIUtility.TrTextContentWithIcon(text, GetIcon(messageType)), action, buttonText);
        }


        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="message">The message text.</param>
        /// <param name="messageType">The type of the message.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        public static void Draw(GUIContent message, MessageType messageType, Action action)
        {
            message.image = GetIcon(messageType);
            Draw(EditorGUIUtility.TrTextContentWithIcon(message.text, message.image), action);
        }

        /// <summary>Draw a help box with the Fix button.</summary>
        /// <param name="message">The message text.</param>
        /// <param name="messageType">The type of the message.</param>
        /// <param name="action">When the user clicks the button, Unity performs this action.</param>
        /// <param name="buttonText">Text displayed within the button.</param>
        public static void Draw(GUIContent message, MessageType messageType, Action action, string buttonText)
        {
            message.image = GetIcon(messageType);
            Draw(EditorGUIUtility.TrTextContentWithIcon(message.text, message.image), action, buttonText);
        }


        private static Texture2D GetIcon(MessageType messageType)
        {
            return messageType switch
            {
                MessageType.None    => null,
                MessageType.Info    => CoreEditorStyles.iconHelp,
                MessageType.Warning => CoreEditorStyles.iconWarn,
                MessageType.Error   => CoreEditorStyles.iconFail,
                _                   => throw new ArgumentOutOfRangeException(nameof(messageType), messageType, null)
            };
        }
    }
}*/