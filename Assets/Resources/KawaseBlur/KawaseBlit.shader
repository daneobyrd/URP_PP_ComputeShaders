Shader "Hidden/KawaseBlit"
{
    HLSLINCLUDE
    #pragma target 5.0
    #pragma editor_sync_compilation

    ENDHLSL

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
        }
        Pass
        {
            Name "Blit Kawase Blur"
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
            // #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
            #pragma exclude_renderers gles
            #pragma vertex Vert
            #pragma fragment FragmentColorOnly
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            TEXTURE2D(_KawaseBlur);

            float4 FragmentColorOnly(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                const float2 uv = input.texcoord;
                return SAMPLE_TEXTURE2D_LOD(_KawaseBlur, sampler_LinearClamp, uv, 0);
            }
            
            ENDHLSL
        }
    }
}