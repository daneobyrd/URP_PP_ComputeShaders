#ifndef FREI_CHEN_COMMON_INCLUDED
#define FREI_CHEN_COMMON_INCLUDED

#include "Assets/Resources/Utilities/MathUtils/Convolution.hlsl"
#include "Assets/Resources/Utilities/Compute/loadCoordOffsets.hlsl"
#include "Assets/Resources/Utilities/MathUtils/ArrayMatrixPacking.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"

// Based on FXAALoad() in PostProcessing/Common.hlsl 
float4 std_dev_load(TEXTURE2D(inputTex), int2 icoords, int2 id, float4 sourceSize)
{
    #if SHADER_API_GLES
    float2 uv = (icoords + id) * sourceSize.zw;
    return SAMPLE_TEXTURE2D_LOD(inputTexture, sampler_PointClamp, uv, 0);
    #else
    return LOAD_TEXTURE2D_LOD(inputTex, clamp(icoords + id, 0, sourceSize.xy - 1.0), 0);
    #endif
}

void std_dev_load_float(UnityTexture2D inputTex, int2 icoords, int2 id, float4 sourceSize, out float4 RGBA)
{
    RGBA = std_dev_load(inputTex.tex, icoords, id, sourceSize);
}

void load3x3_array(TEXTURE2D(inputTex), int2 coord, int2 offset[9], float4 sourceSize, out float3x3 pixel[4])
{
    float4 px_array[9];
    UNITY_UNROLLX(9)
    for (int i = 0; i < 9; ++i)
    {
        px_array[i] = std_dev_load(inputTex, coord, offset[i], sourceSize);
    }
    asfloat3x3_split(px_array, pixel[0], pixel[1], pixel[2], pixel[3]);
    float red[9];
    float green[9];
    float blue[9];
    float alpha[9];

    split_array9(px_array, red, green, blue, alpha);
    pixel[0] = asfloat3x3_array9(red);
    pixel[1] = asfloat3x3_array9(green);
    pixel[2] = asfloat3x3_array9(blue);
    pixel[3] = asfloat3x3_array9(alpha);
}

void load3x3_array_float(UnityTexture2D inputTex, int2 coord, float4 sourceSize,
                         out float3x3 r, out float3x3 g, out float3x3 b, out float3x3 a)
{
    ZERO_INITIALIZE(float3x3, r);
    ZERO_INITIALIZE(float3x3, g);
    ZERO_INITIALIZE(float3x3, b);
    ZERO_INITIALIZE(float3x3, a);

    float3x3 mat_array[4] = { r,g,b,a };
    ZERO_INITIALIZE_ARRAY(float3x3, mat_array, 4);
    load3x3_array(inputTex.tex, coord, offset_3x3, sourceSize, mat_array);
}

void load5x5(TEXTURE2D(inputTex), int2 coord, float4 sourceSize, out real4 texel[25])
{
    UNITY_UNROLLX(25)
    for (int i = 0; i < 25; i++)
    {
        texel[i] = std_dev_load(inputTex, coord, offset_5x5[i], sourceSize);
    }
}

// Fetch 3x3 texel neighborhood from a 5x5 sample.
/*
void Fetch3x3_Array_from5x5(float4 texel[25], int center_idx, out real3x3 values[4])
{
    float4 px_array[9] =
    {
        texel[center_idx - (5 + 1)], texel[center_idx - (5 + 0)], texel[center_idx - (5 - 1)],
        texel[center_idx - 1], texel[center_idx], texel[center_idx + 1],
        texel[center_idx + (5 - 1)], texel[center_idx + (5 + 0)], texel[center_idx + (5 + 1)]
    };
    asfloat3x3_split(px_array, values[0], values[1], values[2], values[3]);
}
*/

// Fetch 3x3 texel neighborhood from a 5x5 sample.                                                               
/*
void Fetch3x3_4_from5x5(float4 texel[25], int center_idx, out float3x3_4 values)
{
    float4 px_array[9] =
    {
        texel[center_idx - (5 + 1)], texel[center_idx - (5 + 0)], texel[center_idx - (5 - 1)],
        texel[center_idx - 1], texel[center_idx], texel[center_idx + 1],
        texel[center_idx + (5 - 1)], texel[center_idx + (5 + 0)], texel[center_idx + (5 + 1)]
    };
    asfloat3x3_4(px_array, values);
}
*/

void ApplyFreiChenScalar(real input[9], real3x3 coeff, out real result)
{
    real3x3 input3x3 = asreal3x3(input);
    result = dot3xN(input3x3, coeff);
    result *= result;
}

void ApplyFreiChenScalar(real3x3 input3x3, real3x3 coeff, out real result)
{
    result = dot3xN(input3x3, coeff);
    result *= result;
}

void ApplyFreiChenVector_array(real4 input[9], real3x3 coeff, out real4 result)
{
    float3x3 input3x3[4];
    asfloat3x3_array(input, input3x3);

    result = 
        dot3xN(input3x3[0], coeff),
        dot3xN(input3x3[1], coeff),
        dot3xN(input3x3[2], coeff),
        dot3xN(input3x3[3], coeff);
    result *= result;
}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  //
//          Return one-component length from sRGB texel value           //
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *  //

/**
 * \brief Load vector4 value from inputTex, output scalar length.
 * \param inputTex Texture2D to load vector4 value from.
 * \param coord Texture coordinate of the center of 3x3 texel neighborhood.
 * \param offset int2 offset from 3x3 center coord.
 * \param sourceSize xy: Texture size, zw: texel size.
 * \return Scalar length of texel value.
 */
real load_color_intensity(TEXTURE2D(inputTex), int2 coord, int2 offset, float4 sourceSize)
{
    float4 texel_value = float4(std_dev_load(inputTex, coord, offset, sourceSize));
    return Length2(texel_value);
    // Test: Luminance(texel_value)?
}

void load_color_intensity9(TEXTURE2D(inputTex), int2 coord, int2 offset[9], float4 sourceSize, out float intensity[9])
{
    // Manually unrolled
    // 9 * 4 = 36 components
    intensity[0] = load_color_intensity(inputTex, coord, offset[0], sourceSize);
    intensity[1] = load_color_intensity(inputTex, coord, offset[1], sourceSize);
    intensity[2] = load_color_intensity(inputTex, coord, offset[2], sourceSize);
    intensity[3] = load_color_intensity(inputTex, coord, offset[3], sourceSize);
    intensity[4] = load_color_intensity(inputTex, coord, offset[4], sourceSize);
    intensity[5] = load_color_intensity(inputTex, coord, offset[5], sourceSize);
    intensity[6] = load_color_intensity(inputTex, coord, offset[6], sourceSize);
    intensity[7] = load_color_intensity(inputTex, coord, offset[7], sourceSize);
    intensity[8] = load_color_intensity(inputTex, coord, offset[8], sourceSize);
}

void load_color_intensity9(TEXTURE2D(inputTex), int2 coord, float4 sourceSize, out real intensity[9])
{
    load_color_intensity9(inputTex, coord, offset_3x3, sourceSize, intensity);
}

real3x3 load_color_intensity3x3(TEXTURE2D(inputTex), int2 coord, float4 sourceSize)
{
    real3x3 intensity;
    intensity[0][0] = load_color_intensity(inputTex, coord, offset_3x3[0], sourceSize);
    intensity[0][1] = load_color_intensity(inputTex, coord, offset_3x3[1], sourceSize);
    intensity[0][2] = load_color_intensity(inputTex, coord, offset_3x3[2], sourceSize);
    intensity[1][0] = load_color_intensity(inputTex, coord, offset_3x3[3], sourceSize);
    intensity[1][1] = load_color_intensity(inputTex, coord, offset_3x3[4], sourceSize);
    intensity[1][2] = load_color_intensity(inputTex, coord, offset_3x3[5], sourceSize);
    intensity[2][0] = load_color_intensity(inputTex, coord, offset_3x3[6], sourceSize);
    intensity[2][1] = load_color_intensity(inputTex, coord, offset_3x3[7], sourceSize);
    intensity[2][2] = load_color_intensity(inputTex, coord, offset_3x3[8], sourceSize);

    return intensity;
}

real fetch_color_intensity(real4 texel)
{
    return length(texel);
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

void load_color_intensity16(TEXTURE2D(inputTex), int2 coord, int2 offsets[16], float4 sourceSize,
                            out float4 intensity[16])
{
    for (int i = 0; i < 16; ++i)
    {
        intensity[i] = load_color_intensity(inputTex, coord, offsets[i], sourceSize);
    }
}

real4 load_color_intensity16(TEXTURE2D(inputTex), int2 coord, int2 offset, float4 sourceSize)
{
    return length(std_dev_load(inputTex, coord, offset, sourceSize));
}
#endif
