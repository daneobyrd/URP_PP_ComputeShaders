Shader "FreiChen"
{
    HLSLINCLUDE
    #pragma target 5.0
    #pragma editor_sync_compilation

    #include "Assets/Resources/MyBlit_VertOnly.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    // #define FULLSCREENSHADERPASS_BLIT (0)
    // #define FULLSCREENSHADERPASS_DRAW_PROCEDURAL (1)

    // #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenCommon.hlsl"
    // #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenBlit.hlsl"
    // #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/Fullscreen/Includes/FullscreenDrawProcedural.hlsl"

    // #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"
    
    // #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    
    // #include "Assets/Resources/Utilities/std_deviation.hlsl"
    // #include "Assets/Resources/Utilities/loadCoordOffsets.hlsl"
    ENDHLSL

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
        }
/*
        Pass
        {
            Name "Standard Deviation Blit"
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
            #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
            #pragma vertex Vert
            #pragma fragment FragmentColorOnly

            SAMPLER(sampler_BlitTexture);
            float4 _BlitTexture_TexelSize;

            TEXTURE2D(_StdDevTex);
            // TEXTURE2D(_MainTex);
            
            float StandardDeviation(float grid[9], int2 coord)
            {
                for (int i = 0; i < 9; ++i)
                {
                    grid[i] = Length2(_CameraOpaqueTexture[coord * 0.5 + offset_3x3[i]]);
                    // LOAD_TEXTURE2D(_MainTex, uint2(clamp(coord + offset_3x3[i], 0, _ScreenSize.xy - 1.0)));
                }
                const float mean = Avg9(grid);
                
                for (int j = 0; j < 9; ++j)
                {
                    grid[j] = grid[j] - mean;
                }
                
                const float sq_sum =
                    Sq(grid[0]) + Sq(grid[1]) + Sq(grid[2])
                    + Sq(grid[3]) + Sq(grid[4]) + Sq(grid[5])
                    + Sq(grid[6]) + Sq(grid[7]) + Sq(grid[8]);
                
                return sqrt(sq_sum / 9);
            }

            float4 StandardDeviation(float4 grid[9], int2 coord )
            {
                for (int i = 0; i < 9; ++i)
                {
                    grid[i] = _BlitTexture[coord * 0.5 + offset_3x3[i]];
                }
                const float3x3_4 pixels = asfloat3x3_4(grid);
                return std_dev_3x3_4(pixels);
            }
            
            float4 FragmentColorOnly(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

                const float2 uv = input.texcoord;
                const int2 coord = floor(uv * _ScreenSize.xy);

                float4 px[9];
                ZERO_INITIALIZE_ARRAY(float4, px, 9);
                const float4 deviation = StandardDeviation(px, coord);
                return deviation;
            }
            ENDHLSL
        }
*/
        Pass
        {
            Name "Frei Chen Blit"
            ZWrite Off ZTest Always Blend Off Cull Off

            HLSLPROGRAM
            #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
            #pragma vertex Vert
            #pragma fragment FragmentColorOnly

            TEXTURE2D(_FreiChenTexture);
            
            float4 FragmentColorOnly(Varyings input) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
                const float2 uv = input.texcoord;
                // const int2 coord = floor(uv * _ScreenSize.xy);
                return SAMPLE_TEXTURE2D_LOD(_FreiChenTexture, sampler_LinearClamp, uv, 0);
            }
            ENDHLSL
        }
    }
}