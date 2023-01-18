#ifndef STD_DEV_SG_INCLUDED
#define STD_DEV_SG_INCLUDED

#include "Assets/Resources/Utilities/Compute/loadCoordOffsets.hlsl"
#include "Assets/Resources/Utilities/MathUtils/ArrayMatrixPacking.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
#include "Assets/Resources/Utilities/MathUtils/std_deviation.hlsl"

// Originally Based on FXAALoad() in PostProcessing/Common.hlsl 
float4 std_dev_load_float(TEXTURE2D(inputTex), uint2 pixelCoords, int2 id, float4 sourceSize)
{
    #if SHADER_API_GLES
    float2 uv = (icoords + id) * sourceSize.zw;
    return SAMPLE_TEXTURE2D_LOD(inputTexture, sampler_PointClamp, uv, 0);
    #else
    return LOAD_TEXTURE2D_LOD(inputTex, clamp(pixelCoords + id, 0, sourceSize.xy), 0);
                        // originally: clamp(pixelCoords + id, 0, sourceSize.xy - 1.0)
    #endif
}
half4 std_dev_load_half(TEXTURE2D(inputTex), uint2 pixelCoords, int2 id, float4 sourceSize)
{
    #if SHADER_API_GLES
    float2 uv = (icoords + id) * sourceSize.zw;
    return SAMPLE_TEXTURE2D_LOD(inputTexture, sampler_PointClamp, uv, 0);
    #else
    return LOAD_TEXTURE2D_LOD(inputTex, clamp(pixelCoords + id, 0, sourceSize.xy), 0);
                        // originally: clamp(pixelCoords + id, 0, sourceSize.xy - 1.0)
    #endif
}

void load3x3_array(TEXTURE2D(inputTex), float2 uv, int2 offset[9], out float3x3 pixel[4])
{
    const uint2 pixel_coords = uint2(uv * _ScreenSize.xy);
    float4 px_array[9];
    for (int i = 0; i < 9; i++)
    {
        px_array[i] = std_dev_load_float(inputTex, pixel_coords, offset[i], _ScreenSize);
    }

    asfloat3x3_split(px_array, pixel[0], pixel[1], pixel[2], pixel[3]);
}
void load3x3_array(TEXTURE2D(inputTex), float2 uv, int2 offset[9], out half3x3 pixel[4])
{
    const uint2 pixel_coords = uint2(uv * _ScreenSize.xy);
    half4 px_array[9];
    for (int i = 0; i < 9; i++)
    {
        px_array[i] = std_dev_load_half(inputTex, pixel_coords, offset[i], _ScreenSize);
    }

    ashalf3x3_split(px_array, pixel[0], pixel[1], pixel[2], pixel[3]);
}

void load3x3_intensity(TEXTURE2D(inputTex), float2 uv, int2 offset[9], out real3x3 pixel[4])
{
    const uint2 pixel_coords = uint2(uv * _ScreenSize.xy);
    real4 px_array[9];
    #if REAL_IS_HALF
    for (int i = 0; i < 9; i++)
    {
        px_array[i] = Length2(std_dev_load_half(inputTex, pixel_coords, offset[i], _ScreenSize));
    }
    ashalf3x3_split(px_array, pixel[0], pixel[1], pixel[2], pixel[3]);
    
    #else
    for (int i = 0; i < 9; i++)
    {
        px_array[i] = Length2(std_dev_load_float(inputTex, pixel_coords, offset[i], _ScreenSize));
    }
    asfloat3x3_split(px_array, pixel[0], pixel[1], pixel[2], pixel[3]);
    #endif

}

float4 StandardDeviation_f32(TEXTURE2D(inputTex), float2 uv)
{
    float3x3 pixels[4];
    load3x3_array(inputTex, uv, offset_3x3, pixels);

    float4 deviation;
    std_dev_3x3_array(pixels[0], pixels[1], pixels[2], pixels[3], deviation);
    return deviation;
}
half4 StandardDeviation_f16(TEXTURE2D(inputTex), float2 uv)
{
    half3x3 pixels[4];
    load3x3_array(inputTex, uv, offset_3x3, pixels);

    half4 deviation;
    std_dev_3x3_array(pixels[0], pixels[1], pixels[2], pixels[3], deviation);
    return deviation;
}
real4 StandardDeviation_Scalar(TEXTURE2D(inputTex), float2 uv)
{
    real3x3 pixels[4];
    load3x3_intensity(inputTex, uv, offset_3x3, pixels);

    real4 deviation;
    std_dev_3x3_array(pixels[0], pixels[1], pixels[2], pixels[3], deviation);
    return deviation;
}


// ShaderGraph custom function node versions
void load3x3_array_float(UnityTexture2D inputTex, float2 uv,
                         out float3x3 r, out float3x3 g, out float3x3 b, out float3x3 a)
{
    float3x3 matrix_array[4];
    ZERO_INITIALIZE_ARRAY(float3x3, matrix_array, 4);
    load3x3_array(inputTex.tex, uv, offset_3x3, matrix_array);
    r = matrix_array[0];
    g = matrix_array[1];
    b = matrix_array[2];
    a = matrix_array[3];
}

void load3x3_array_half(UnityTexture2D inputTex, float2 uv,
                         out half3x3 r, out half3x3 g, out half3x3 b, out half3x3 a)
{
    half3x3 matrix_array[4];
    ZERO_INITIALIZE_ARRAY(half3x3, matrix_array, 4);
    load3x3_array(inputTex.tex, uv, offset_3x3, matrix_array);
    r = matrix_array[0];
    g = matrix_array[1];
    b = matrix_array[2];
    a = matrix_array[3];
}


// ShaderGraph custom function node versions
void StandardDeviation_float(UnityTexture2D inputTex, float2 uv, out float4 deviation)
{
    deviation = StandardDeviation_f32(inputTex.tex, uv);
}
void StandardDeviation_Scalar_float(UnityTexture2D inputTex, float2 uv, out float4 deviation)
{
    deviation = StandardDeviation_Scalar(inputTex.tex, uv);
}
void StandardDeviation_half(UnityTexture2D inputTex, float2 uv, out half4 deviation)
{
    deviation = StandardDeviation_f16(inputTex.tex, uv);
}
void StandardDeviation_Scalar_half(UnityTexture2D inputTex, float2 uv, out half4 deviation)
{
    deviation = StandardDeviation_Scalar(inputTex.tex, uv);
}


#endif
