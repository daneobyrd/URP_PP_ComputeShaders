Shader "KawaseBlit"
{
    HLSLINCLUDE
    #pragma target 5.0
    #pragma editor_sync_compilation

    #include "kBlit.hlsl"
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
            ZWrite Off
            ZTest Always
            Blend Off
            Cull Off

            HLSLPROGRAM
            #pragma only_renderers d3d11 playstation xboxone xboxseries vulkan metal switch
            #pragma exclude_renderers gles
            #pragma vertex Vert
            #pragma fragment FragmentColorOnly

            ENDHLSL
        }
    }
}