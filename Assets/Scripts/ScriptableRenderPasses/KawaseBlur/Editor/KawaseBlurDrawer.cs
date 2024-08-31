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
            if (!createdStyles) CreateStyles();

            #region Serialized Properties

            var enable = property.FindPropertyRelative(nameof(KawaseBlurSettings.enable));
            var enableLabel = new GUIContent("Enable");

            var blitToCamera = property.FindPropertyRelative(nameof(KawaseBlurSettings.blitToCamera));
            var excludeSceneView = property.FindPropertyRelative(nameof(KawaseBlurSettings.excludeSceneView));

            var srcType = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurSource));
            var srcTextureId = property.FindPropertyRelative(nameof(KawaseBlurSettings.srcTextureId));
            var srcTexIDLabel = new GUIContent("Texture ID");

            var blurPasses = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurPasses));
            var blurMaterial = property.FindPropertyRelative(nameof(KawaseBlurSettings.blurMaterial));

            #endregion

            // Kawase Settings
            EditorGUI.BeginProperty(position, label, property);
            EditorGUI.LabelField(position, "Kawase Blur Settings", boldLabel);

            using (new HorizontalScope())
            {
                using (new VerticalScope(GUILayout.Width(200)))
                {
                    EditorGUIUtility.labelWidth = 150;
                    PropertyField(enable);
                    PropertyField(blitToCamera);
                    if (blitToCamera.boolValue)
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