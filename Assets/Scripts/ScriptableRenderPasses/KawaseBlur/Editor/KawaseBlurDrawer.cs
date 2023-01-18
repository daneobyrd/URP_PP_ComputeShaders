using UnityEditor;
using UnityEngine;

namespace ScriptableRenderPasses.KawaseBlur.Editor
{
    using static EditorGUILayout;

    [CustomPropertyDrawer(typeof(KawaseBlurSettings))]
    public class KawaseBlurDrawer : PropertyDrawer
    {
        private bool createdStyles = false;
        private GUIStyle boldLabel;
        
        private void CreateStyles()
        {
            createdStyles       = true;
            boldLabel           = GUI.skin.label;
            boldLabel.fontStyle = FontStyle.Bold;
        }

        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            //base.OnGUI(position, property, label);
            if (!createdStyles) CreateStyles();

            #region Serialized Properties

            SerializedProperty enable = property.FindPropertyRelative(nameof(KawaseBlurSettings.enable));
            GUIContent enableLabel = new GUIContent("Enable");

            SerializedProperty isBlit = property.FindPropertyRelative(nameof(KawaseBlurSettings.isBlitPass));
            SerializedProperty excludeSceneView =
                property.FindPropertyRelative(nameof(KawaseBlurSettings.excludeSceneView));

            SerializedProperty srcType = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurSource));
            SerializedProperty srcTextureId = property.FindPropertyRelative(nameof(KawaseBlurSettings.srcTextureId));
            GUIContent srcTexIDLabel = new GUIContent("Texture ID");

            SerializedProperty blurPasses = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurPasses));
            SerializedProperty blurMaterial = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurMaterial));

            #endregion

            // Kawase Settings
            EditorGUI.BeginProperty(position, label, property);
            EditorGUI.LabelField(position, "Kawase Blur Settings", boldLabel);

            using (new HorizontalScope())
            {
                using (new VerticalScope())
                {
                    EditorGUIUtility.labelWidth = 100;
                    PropertyField(enable);
                    PropertyField(isBlit);
                    if (isBlit.boolValue)
                    {
                        PropertyField(excludeSceneView);
                    }
                }

                using (new VerticalScope())
                {
                    PropertyField(srcType);
                    if (srcType.intValue == (int) SourceType.TextureID)
                    {
                        if (string.IsNullOrEmpty(srcTextureId.stringValue))
                        {
                            srcTextureId.stringValue = "_CameraOpaqueTexture";
                        }

                        PropertyField(srcTextureId, srcTexIDLabel);
                    }

                    PropertyField(blurPasses);
                    PropertyField(blurMaterial);
                }
            }

            EditorGUI.EndProperty();
            property.serializedObject.ApplyModifiedProperties();
        }
    }
}