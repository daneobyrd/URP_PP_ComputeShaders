#ifndef ARRAY_MATRIX_PACKING_INCLUDED
#define ARRAY_MATRIX_PACKING_INCLUDED

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

#define TEMPLATE_1_PACK_MATRIX_3x3(type, FunctionName, input) \
    row_major MERGE_NAME(type, 3x3) FunctionName(type input[9]) \
    { return type##3x3(input[0], input[1], input[2], input[3], input[4], input[5], input[6], input[7], input[8]); }


// Use any combination of inputs (totaling 9 components)
/* DOESN'T WORK: (INVALID SUBSCRIPT .w) ERROR
#define FLATTEN_TO_SCALAR_ARRAY_9(type, FunctionName, v1, v2, v3, vArray) \
/* 1, 4, 4 #1# \
void FunctionName(in type v1, in vector<type, 4> v2, in vector<type, 4> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; \
    vArray[1] = v2.x; vArray[2] = v2.y; vArray[3] = v2.z; vArray[4] = v2.w; \
    vArray[5] = v3.x; vArray[6] = v3.y; vArray[7] = v3.z; vArray[8] = v3.w; \
} \
/* 4, 1, 4 #1# \
void FunctionName(in vector<type, 4> v1, in type v2, in vector<type, 4> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; vArray[3] = v1.w; \
    vArray[4] = v2.x; \
    vArray[5] = v3.x; vArray[6] = v3.y; vArray[7] = v3.z; vArray[8] = v3.w; \
} \
/* 4, 4, 1 #1# \
void FunctionName(in vector<type, 4> v1, in vector<type, 4> v2, in type v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; vArray[3] = v1.w; \
    vArray[4] = v2.x; vArray[5] = v2.y; vArray[6] = v2.z; vArray[7] = v2.w; \
    vArray[8] = v3.x; \
} \
/* 2, 3, 4 #1# \
void FunctionName(in vector<type, 2> v1, in vector<type, 3> v2, in vector<type, 4> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; \
    vArray[2] = v2.x; vArray[3] = v2.y; vArray[4] = v2.z; \
    vArray[5] = v3.x; vArray[6] = v3.y; vArray[7] = v3.z; vArray[8] = v3.w; \
} \
/* 2, 4, 3 #1# \
void FunctionName(in vector<type, 2> v1, in vector<type, 4> v2, in vector<type, 3> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; \
    vArray[2] = v2.x; vArray[3] = v2.y; vArray[4] = v2.z; vArray[5] = v3.w; \
    vArray[6] = v3.x; vArray[7] = v3.y; vArray[8] = v3.z; \
} \
/* 3, 2, 4 #1# \
void FunctionName(in vector<type, 3> v1, in vector<type, 2> v2, in vector<type, 4> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; \
    vArray[3] = v2.x; vArray[4] = v2.y; \
    vArray[5] = v3.x; vArray[6] = v3.y; vArray[7] = v3.z; vArray[8] = v3.w; \
} \
/* 3, 4, 2 #1# \
void FunctionName(in vector<type, 3> v1, in vector<type, 4> v2, in vector<type, 2> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; \
    vArray[3] = v2.x; vArray[4] = v2.y; vArray[5] = v2.z; vArray[6] = v2.w; \
    vArray[7] = v3.x; vArray[8] = v3.y; \
} \
/* 3, 3, 3 #1# \
void FunctionName(in vector<type, 3> v1, in vector<type, 3> v2, in vector<type, 3> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; \
    vArray[3] = v2.x; vArray[4] = v2.y; vArray[5] = v2.z; \
    vArray[6] = v3.x; vArray[7] = v3.y; vArray[8] = v3.z; \
} \
/* 4, 2, 3 #1# \
void FunctionName(in vector<type, 4> v1, in vector<type, 2> v2, in vector<type, 3> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; vArray[3] = v1.w; \
    vArray[3] = v2.x; vArray[4] = v2.y; \
    vArray[6] = v3.x; vArray[7] = v3.y; vArray[8] = v3.z; \
} \
/* 4, 3, 2 #1# \
void FunctionName(in vector<type, 4> v1, in vector<type, 3> v2, in vector<type, 2> v3, out type vArray[9]) \
{ \
    vArray[0] = v1.x; vArray[1] = v1.y; vArray[2] = v1.z; vArray[3] = v1.w; \
    vArray[3] = v2.x; vArray[4] = v2.y; vArray[5] = v2.z; \
    vArray[7] = v3.x; vArray[8] = v3.y; \
}*/

TEMPLATE_1_PACK_MATRIX_3x3(float, asfloat3x3_macro, input)
TEMPLATE_1_PACK_MATRIX_3x3(half, ashalf3x3_macro, input)
TEMPLATE_1_PACK_MATRIX_3x3(int, asint3x3_macro, input)
#ifndef SHADER_API_GLES
TEMPLATE_1_PACK_MATRIX_3x3(uint, asuint3x3_macro, input)
#endif

// For 3x3 pixel sample
void split_array9(float4 input[9], out float r[9], out float g[9], out float b[9], out float a[9])
{
    for (int i = 0; i < 9; ++i)
    {
        r[i] = input[i].r;
        g[i] = input[i].g;
        b[i] = input[i].b;
        a[i] = input[i].a;
    }
}
/*
void split_red9(in float4 input[9], out float red[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        red[i] = input[i].r;
    }
}
void split_green9(in float4 input[9], out float green[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        green[i] = input[i].g;
    }
}
void split_blue9(in float4 input[9], out float blue[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        blue[i] = input[i].b;
    }
}
void split_alpha9(in float4 input[9], out float alpha[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        alpha[i] = input[i].a;
    }
}
*/

// 4x4 pixel sample
void split_array16(float4 input[16], out float r[16], out float g[16], out float b[16], out float a[16])
{
    for (int i = 0; i < 16; ++i)
    {
        r[i] = input[i].r;
        g[i] = input[i].g;
        b[i] = input[i].b;
        a[i] = input[i].a;
    }
}
/*
void split_red16(float4 input[16], out float red[16])
{
    for (int i = 0; i < 16; ++i)
    {
        red[i] = input[i].r;
    }
}
void split_green16(float4 input[16], out float green[16])
{
    
        for (int i = 0; i < 16; ++i)
        {
            green[i] = input[i].g;
        }
    }
void split_blue16(float4 input[16], out float blue[16])
{
    for (int i = 0; i < 16; ++i)
    {
        blue[i] = input[i].b;
    }
}
void split_alpha16(float4 input[16], out float alpha[16])
{
    for (int i = 0; i < 16; ++i)
    {
        alpha[i] = input[i].a;
    }
}
*/

row_major float2x2 asfloat2x2(in float input[4])
{
    return float2x2(input[0], input[1],
                    input[2], input[3]);
}
row_major float2x2 asfloat2x2(in float4 input)
{
    return float2x2(input.r, input.g,
                    input.b, input.a);
}
row_major float2x3 asfloat2x3(in float input[6])
{
    return float2x3(input[0], input[1], input[2],
                    input[3], input[4], input[5]);
}
row_major float2x4 asfloat2x4(in float input[8])
{
    return float2x4(input[0], input[1], input[2], input[3],
                    input[4], input[5], input[6], input[7]);
}

row_major float3x2 asfloat3x2(in float input[6])
{
    return float3x2(input[0], input[1],
                    input[2], input[3],
                    input[4], input[5]);
}
row_major float3x3 asfloat3x3_f3(in float3 A, in float3 B, in float3 C)
{
    return float3x3
    (
        A.x, A.y, A.z,
        B.x, B.y, B.z,
        C.x, C.y, C.z
    );
}
row_major float3x3 asfloat3x3_f3_array(in float3 input[3])
{
    return float3x3
    (
        input[0].r, input[0].g, input[0].b,
        input[1].r, input[1].g, input[1].b,
        input[2].r, input[2].g, input[2].b
    );
}
row_major float3x3 asfloat3x3_array9(in float input[9])
{
    return float3x3(input[0], input[1], input[2],
                    input[3], input[4], input[5],
                    input[6], input[7], input[8]
    );
}

void asfloat3x3_split(in float4 input[9],
                      out float3x3 out_red, out float3x3 out_green, out float3x3 out_blue, out float3x3 out_alpha)
{
    float red[9];
    float green[9];
    float blue[9];
    float alpha[9];
    
    split_array9(input, red, green, blue, alpha);

    out_red = asfloat3x3_array9(red);
    out_green = asfloat3x3_array9(green);
    out_blue = asfloat3x3_array9(blue);
    out_alpha = asfloat3x3_array9(alpha);
}
void asfloat3x3_array(in float4 input[9], out float3x3 output[4])
{
    asfloat3x3_split(input, output[0], output[1], output[2], output[3]);
}

row_major float4x4 asfloat4x4(in float input[16])
{
    return float4x4
    (
        input[0], input[1], input[2], input[3],
        input[4], input[5], input[6], input[7],
        input[8], input[9], input[10], input[11],
        input[12], input[13], input[14], input[15]
    );
}
row_major float4x4 asfloat4x4_split(in float4 A, in float4 B, in float4 C, in float4 D)
{
    return float4x4
    (
        A.r, A.g, A.b, A.a,
        B.r, B.g, B.b, B.a,
        C.r, C.g, C.b, C.a,
        D.r, D.g, D.b, D.a
    );
}
row_major float4x4 asfloat4x4_array(in float4 input[4])
{
    return float4x4
    (
        input[0].r, input[0].g, input[0].b, input[0].a,
        input[1].r, input[1].g, input[1].b, input[1].a,
        input[2].r, input[2].g, input[2].b, input[2].a,
        input[3].r, input[3].g, input[3].b, input[3].a
    );
}

void asfloat4x4_split(float4 input[16], out float4x4 output_red, out float4x4 output_green, out float4x4 output_blue, out float4x4 output_alpha)
{
    float red[16];
    float green[16];
    float blue[16];
    float alpha[16];

    // Zero initialize as a precaution.
    ZERO_INITIALIZE_ARRAY(float, red, 16);
    ZERO_INITIALIZE_ARRAY(float, green, 16);
    ZERO_INITIALIZE_ARRAY(float, blue, 16);
    ZERO_INITIALIZE_ARRAY(float, alpha, 16);

    split_array16(input, red, green, blue, alpha);

    output_red = asfloat4x4(red);
    output_green = asfloat4x4(green);
    output_blue = asfloat4x4(blue);
    output_alpha = asfloat4x4(alpha);
}
void asfloat4x4_array(float4 input[16], out float4x4 output[4])
{
    asfloat4x4_split(input, output[0], output[1], output[2], output[3]);
}

void split_array9(half4 input[9], out half r[9], out half g[9], out half b[9], out half a[9])
{
    for (int i = 0; i < 9; ++i)
    {
        r[i] = input[i].r;
        g[i] = input[i].g;
        b[i] = input[i].b;
        a[i] = input[i].a;
    }
}
/*
void split_red9(in half4 input[9], out half red[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        red[i] = input[i].r;
    }
}
void split_green9(in half4 input[9], out half green[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        green[i] = input[i].g;
    }
}
void split_blue9(in half4 input[9], out half blue[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        blue[i] = input[i].b;
    }
}
void split_alpha9(in half4 input[9], out half alpha[9])
{
    for (uint i = 0; i < 9; ++i)
    {
        alpha[i] = input[i].a;
    }
}
*/

row_major half2x2 ashalf2x2(in half input[4])
{
    return half2x2(input[0], input[1],
                   input[2], input[3]);
}
row_major half2x2 ashalf2x2(in half4 input)
{
    return half2x2(input.r, input.g,
                   input.b, input.a);
}
row_major half2x3 ashalf2x3(in half input[6])
{
    return half2x3(input[0], input[1], input[2],
                   input[3], input[4], input[5]);
}
row_major half2x3 ashalf2x3(in half3 A, in half3 B)
{
    return half2x3
    (
        A.x, A.y, A.z,
        B.x, B.y, B.z
    );
}
row_major half2x4 ashalf2x4(in half input[8])
{
    return half2x4(input[0], input[1], input[2], input[3],
                   input[4], input[5], input[6], input[7]);
}
row_major half3x2 ashalf3x2(in half input[6])
{
    return half3x2(input[0], input[1],
                   input[2], input[3],
                   input[4], input[5]);
}
row_major half3x3 ashalf3x3(in half input[9])
{
    return half3x3(input[0], input[1], input[2],
                   input[3], input[4], input[5],
                   input[6], input[7], input[8]
    );
}
row_major half4x4 ashalf4x4(in half input[16])
{
    return half4x4
    (
        input[0], input[1], input[2], input[3],
        input[4], input[5], input[6], input[7],
        input[8], input[9], input[10], input[11],
        input[12], input[13], input[14], input[15]
    );
}

void ashalf3x3_split(in half4 input[9],
    out half3x3 out_red, out half3x3 out_green, out half3x3 out_blue, out half3x3 out_alpha)
{
    half red[9];
    half green[9];
    half blue[9];
    half alpha[9];

    // Zero initialize as a precaution.
    ZERO_INITIALIZE_ARRAY(half, red, 9);
    ZERO_INITIALIZE_ARRAY(half, green, 9);
    ZERO_INITIALIZE_ARRAY(half, blue, 9);
    ZERO_INITIALIZE_ARRAY(half, alpha, 9);

    split_array9(input, red, green, blue, alpha);

    out_red = ashalf3x3(red);
    out_green = ashalf3x3(green);
    out_blue = ashalf3x3(blue);
    out_alpha = ashalf3x3(alpha);
}
void ashalf3x3_array(in half4 input[9], out half3x3 output[4])
{
    ashalf3x3_split(input, output[0], output[1], output[2], output[3]);
}

#if REAL_IS_HALF
// Nx3
row_major real3x3 asreal3x3(in real input[9])
{
    return ashalf3x3(input);
}
void asreal3x3_split(in real4 input[9], out real3x3 output_red, out real3x3 output_green, out real3x3 output_blue, out real3x3 output_alpha)
{
    ashalf3x3_array(input, output_red, output_green, output_blue, output_alpha);
}
void asreal3x3_array(in real4 input[9], out real3x3 output[4])
{
    ashalf3x3_array(input, output[0], output[1], output[2], output[3]);
}

// Nx4
row_major real2x4 asreal2x4(real input[8]) { return ashalf2x4(input); }
row_major real4x4 asreal4x4(real input[16]) { return ashalf4x4(input); }
void asreal4x4_array(real4 input[16], out real4x4 output_red, out real4x4 output_green, out real4x4 output_blue, out real4x4 output_alpha)
{
    ashalf4x4_4(input, output_red, output_green, output_blue, output_alpha))
}

void asreal4x4_array(real4 input[16], out real4x4 output[4])
{
    ashalf4x4_array(input, output[0], output[1], output[2], output[3]);
}

#else
row_major real3x3 asreal3x3(in real input[9])
{
    return asfloat3x3_array9(input);
}
void asreal3x3_split(in float4 input[9],
    out float3x3 output_red, out float3x3 output_green, out float3x3 output_blue, out float3x3 output_alpha)
{
    asfloat3x3_split(input, output_red, output_green, output_blue, output_alpha);
}
void asreal3x3_array(in float4 input[9], out float3x3 output[4])
{
    asfloat3x3_split(input, output[0], output[1], output[2], output[3]);
}

#endif

/*
p_grid.r = 3x3 red,       p_grid.r:                                
p_grid.g = 3x3 green,          r(-1, 1), r(0, 1), r(1, 1),      
p_grid.b = 3x3 blue,           r(-1, 0), r(0, 0), r(1, 0),      
p_grid.a = 3x3 alpha           r(-1,-1), r(0, 1), r(1,-1),
*/
// Not used
/*
void Unpack3x3ToArray(real3x3 p_grid[4], out real4 vArray[9])
{
    // px_grid[0] = red channel of 3x3 neighborhood around id
    // (px_grid[2])[1] = middle row of 3x3 blue channel

    /*
    An entry in this array is a 4x3 matrix containing the components of three vector4.
    4 (channels) x 3 (vectors).
    Each matrix column represents one vector4; one pixel.
    
    r10, r11, r12
    g20, g21, g22
    b30, b31, b32
    a40, a41, a42
    #1#
    row_major real4x3 row_4cx3v[3];

    /*
    for (int vec_component = 0; vec_component < 12; ++vec_component)
    {
        int a = floor(vec_component / 3);
        int b = vec_component % 3;

        // Store rgba components for each row of 3x3 sample in rgba_4x3 row
        (row_4x3[b])[a] = (px_grid[a])[b];
    }
    #1#

    (row_4cx3v[0])[0] = (p_grid[0])[0]; // top red row
    (row_4cx3v[0])[1] = (p_grid[1])[0]; // top green row
    (row_4cx3v[0])[2] = (p_grid[2])[0]; // top blue row                
    (row_4cx3v[0])[3] = (p_grid[3])[0]; // top alpha row  

    (row_4cx3v[1])[0] = (p_grid[0])[1]; // mid red row
    (row_4cx3v[1])[1] = (p_grid[1])[1]; // mid green row
    (row_4cx3v[1])[2] = (p_grid[2])[1]; // mid blue row
    (row_4cx3v[1])[3] = (p_grid[3])[1]; // mid alpha row

    (row_4cx3v[2])[0] = (p_grid[0])[2]; // bottom red row
    (row_4cx3v[2])[1] = (p_grid[1])[2]; // bottom green row
    (row_4cx3v[2])[2] = (p_grid[2])[2]; // bottom blue row 
    (row_4cx3v[2])[3] = (p_grid[3])[2]; // bottom alpha row 

    /*
    (r11, g12, b13, a14)
    (r21, g22, b23, a24)
    (r31, g32, b23, a24)
    #1#
    row_major real3x4 row_3vx4c[3];

    // Transpose, each row of rgba_3x4 contains rgba components to be extracted as a vector4
    row_3vx4c[0] = transpose(row_4cx3v[0]);
    row_3vx4c[1] = transpose(row_4cx3v[1]);
    row_3vx4c[2] = transpose(row_4cx3v[2]);

    for (int entry = 0; entry < 9; ++entry)
    {
        int vec = entry % 3;
        int row = entry & 3;;

        vArray[entry] = (row_3vx4c[vec])[row];
    }
}
// Not used
void Unpack3x3ToArray_float(real3x3 r, real3x3 g, real3x3 b, real3x3 a,
                            out real4 p0, out real4 p1, out real4 p2,
                            out real4 p3, out real4 p4, out real4 p5,
                            out real4 p6, out real4 p7, out real4 p8)
{
    const real3x3 input_array[4] = { r, g, b, a };
    real4 array[9] = { p0, p1, p2, p3, p4, p5, p6, p7, p8 };
    Unpack3x3ToArray(input_array, array);
}
*/
#endif
