#ifndef STD_DEVIATION_INCLUDED
#define STD_DEVIATION_INCLUDED

#include "Convolution.hlsl"
#include "MatrixCastingMacros.hlsl"
#include "ArrayMatrixPacking.hlsl"

// Matrix Sums
TEMPLATE_1_MATRIX_SCALAR(float, sigma2xN, 2, v, return dot2xN(v, 1)) // in 2x2, 2x3, 2x4
TEMPLATE_1_MATRIX_SCALAR(float, sigma3xN, 3, v, return dot3xN(v, 1)) // in 3x2, 3x3, 3x4
TEMPLATE_1_MATRIX_SCALAR(float, sigma4xN, 4, v, return dot4xN(v, 1)) // in 4x2, 4x3, 4x4

TEMPLATE_1_MATRIX_SCALAR(half, sigma2xN, 2, v, return dot2xN(v, 1)) // in 2x2, 2x3, 2x4
TEMPLATE_1_MATRIX_SCALAR(half, sigma3xN, 3, v, return dot3xN(v, 1)) // in 3x2, 3x3, 3x4
TEMPLATE_1_MATRIX_SCALAR(half, sigma4xN, 4, v, return dot4xN(v, 1)) // in 4x2, 4x3, 4x4

TEMPLATE_4_MATRIX_VEC4(float, sigma_4, 4, a, b, c, d, return float4(sigma4xN(a), sigma4xN(b), sigma4xN(c), sigma4xN(d)))
TEMPLATE_4_MATRIX_VEC4(half, sigma_4, 4, a, b, c, d, return half4(sigma4xN(a), sigma4xN(b), sigma4xN(c), sigma4xN(d)))

float sigma9(in float px_array[9])
{
    return sigma3xN(asreal3x3(px_array));
}
float4 sigma16(in float4 input[16])
{
    float4x4 v[4];
    asfloat4x4_array(input, v);
    float x = sigma4xN(v[0]); // Red
    float y = sigma4xN(v[1]); // Green
    float z = sigma4xN(v[2]); // Blue
    float w = sigma4xN(v[3]); // Alpha
    return float4(x, y, z, w);
}

TEMPLATE_1_MATRIX_SCALAR(float, sqSum2xN, 2, v, return float(dot2xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(float, sqSum2xN, 2, a, b, return float2(sqSum2xN(a), sqSum2xN(b)))
TEMPLATE_3_MATRIX_VEC3(float, sqSum2xN, 2, a, b, c, return float3(sqSum2xN(a), sqSum2xN(b), sqSum2xN(c)))
TEMPLATE_4_MATRIX_VEC4(float, sqSum2xN, 2, a, b, c, d, return float4(sqSum2xN(a), sqSum2xN(b), sqSum2xN(c),  sqSum2xN(d)))

TEMPLATE_1_MATRIX_SCALAR(half, sqSum2xN, 2, v, return float(dot2xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(half, sqSum2xN, 2, a, b, return half2(sqSum2xN(a), sqSum2xN(b)))
TEMPLATE_3_MATRIX_VEC3(half, sqSum2xN, 2, a, b, c, return half3(sqSum2xN(a), sqSum2xN(b), sqSum2xN(c)))
TEMPLATE_4_MATRIX_VEC4(half, sqSum2xN, 2, a, b, c, d, return half4(sqSum2xN(a), sqSum2xN(b), sqSum2xN(c),  sqSum2xN(d)))

TEMPLATE_1_MATRIX_SCALAR(float, sqSum3xN, 3, v, return float(dot3xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(float, sqSum3xN, 3, a, b, return float2(sqSum3xN(a), sqSum3xN(b)))
TEMPLATE_3_MATRIX_VEC3(float, sqSum3xN, 3, a, b, c, return float3(sqSum3xN(a), sqSum3xN(b), sqSum3xN(c)))
TEMPLATE_4_MATRIX_VEC4(float, sqSum3xN, 3, a, b, c, d, return float4(sqSum3xN(a), sqSum3xN(b), sqSum3xN(c),  sqSum3xN(d)))

TEMPLATE_1_MATRIX_SCALAR(half, sqSum3xN, 3, v, return half(dot3xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(half, sqSum3xN, 3, a, b, return half2(sqSum3xN(a), sqSum3xN(b)))
TEMPLATE_3_MATRIX_VEC3(half, sqSum3xN, 3, a, b, c, return half3(sqSum3xN(a), sqSum3xN(b), sqSum3xN(c)))
TEMPLATE_4_MATRIX_VEC4(half, sqSum3xN, 3, a, b, c, d, return half4(sqSum3xN(a), sqSum3xN(b), sqSum3xN(c),  sqSum3xN(d)))

TEMPLATE_1_MATRIX_SCALAR(float, sqSum4xN, 4, v, return half(dot4xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(float, sqSum4xN, 4, a, b, return half2(sqSum4xN(a), sqSum4xN(b)))
TEMPLATE_3_MATRIX_VEC3(float, sqSum4xN, 4, a, b, c, return half3(sqSum4xN(a), sqSum4xN(b), sqSum4xN(c)))
TEMPLATE_4_MATRIX_VEC4(float, sqSum4xN, 4, a, b, c, d, return half4(sqSum4xN(a), sqSum4xN(b), sqSum4xN(c), sqSum4xN(d)))

TEMPLATE_1_MATRIX_SCALAR(half, sqSum4xN, 4, v, return half(dot4xN(v, v)))
TEMPLATE_2_MATRIX_VEC2(half, sqSum4xN, 4, a, b, return half2(sqSum4xN(a), sqSum4xN(b)))
TEMPLATE_3_MATRIX_VEC3(half, sqSum4xN, 4, a, b, c, return half3(sqSum4xN(a), sqSum4xN(b), sqSum4xN(c)))
TEMPLATE_4_MATRIX_VEC4(half, sqSum4xN, 4, a, b, c, d, return half4(sqSum4xN(a), sqSum4xN(b), sqSum4xN(c), sqSum4xN(d)))

// Matrix Mean Value

// Rows and columns must be integers.
#define MATRIX_AVG(Type, Rows, Columns) \
 Type CONCAT_NAME(Avg, Rows, x##Columns)(CONCAT_NAME(Type, Rows, x##Columns) inputMatrix) \
 { return CONCAT_NAME(sigma, Rows, xN)(inputMatrix) * rcp((Type)Rows*Columns); }

#define DECLARE_ALL_MATRIX_AVG(Type) \
    MATRIX_AVG(Type, 2, 2) \
    MATRIX_AVG(Type, 2, 3) \
    MATRIX_AVG(Type, 2, 4) \
    MATRIX_AVG(Type, 3, 2) \
    MATRIX_AVG(Type, 3, 3) \
    MATRIX_AVG(Type, 3, 4) \
    MATRIX_AVG(Type, 4, 2) \
    MATRIX_AVG(Type, 4, 3) \
    MATRIX_AVG(Type, 4, 4)

DECLARE_ALL_MATRIX_AVG(float)
DECLARE_ALL_MATRIX_AVG(half)

#define MATRIX_ARRAY_AVG_VECTOR(Type, Rows, Columns, FunctionName, arrayLength)  \
    void CONCAT_NAME(FunctionName, _, arrayLength)( in matrix<Type, Rows, Columns> matrixArray[arrayLength], out vector<Type, arrayLength> mean) \
    { for(int i = 0; i < arrayLength; i++) \
        mean[i] = FunctionName(matrixArray[i]) ; } \
    \
    Type##arrayLength CONCAT_NAME(FunctionName, _, arrayLength)( in matrix<Type, Rows, Columns> matrixArray[arrayLength]) \
    { \
         vector<Type, arrayLength> mean; \
        for(int i = 0; i < arrayLength; i++) \
            mean[i] = FunctionName(matrixArray[i]); \
        return mean; \
    }

// MATRIX_ARRAY_VECTOR_AVG(float, 2, 2, Avg2x2, 4)
// ~~~ possible output ~~~
/*
void Avg2x2_4(in float2x2 matrixArray[4], out float4 mean)
{
    for(int i = 0; i < arrayLength; i++)
         mean[i] = FunctionName(matrixArray[i]);

    // mean = float4(Avg2x2(v[0]), Avg2x2(v[1]), Avg2x2(v[2]), Avg2x2(v[3])); 
}
float4 Avg2x2_4(in float2x2 matrixArray[4])
{
    float4 mean;
    for(int i = 0; i < arrayLength; i++)
         mean[i] = FunctionName(matrixArray[i]);

    // mean = float4(Avg2x2(v[0]), Avg2x2(v[1]), Avg2x2(v[2]), Avg2x2(v[3])); 
    return mean;
} */

MATRIX_ARRAY_AVG_VECTOR(float, 2, 2, Avg2x2, 4)
MATRIX_ARRAY_AVG_VECTOR(half, 2, 2, Avg2x2, 4)
MATRIX_ARRAY_AVG_VECTOR(float, 2, 3, Avg2x3, 2)
MATRIX_ARRAY_AVG_VECTOR(half, 2, 3, Avg2x3, 2)
MATRIX_ARRAY_AVG_VECTOR(float, 3, 2, Avg3x2, 2)
MATRIX_ARRAY_AVG_VECTOR(half, 3, 2, Avg3x2, 2)
MATRIX_ARRAY_AVG_VECTOR(float, 3, 3, Avg3x3, 2)
MATRIX_ARRAY_AVG_VECTOR(half, 3, 3, Avg3x3, 2)
MATRIX_ARRAY_AVG_VECTOR(float, 3, 3, Avg3x3, 4)
MATRIX_ARRAY_AVG_VECTOR(half, 3, 3, Avg3x3, 4)
MATRIX_ARRAY_AVG_VECTOR(float, 4, 4, Avg4x4, 4)
MATRIX_ARRAY_AVG_VECTOR(half, 4, 4, Avg4x4, 4)

float2x2 mean_diff(in float2x2 px_grid) { return px_grid - Avg2x2(px_grid); }
float2x3 mean_diff(in float2x3 px_grid) { return px_grid - Avg2x3(px_grid); }
float3x2 mean_diff(in float3x2 px_grid) { return px_grid - Avg3x2(px_grid); }
float3x3 mean_diff(in float3x3 px_grid, in float mean)
{
    // Row by Row
    float3 row1 = float3(px_grid[0] - mean.xxx);
    float3 row2 = float3(px_grid[1] - mean.xxx);
    float3 row3 = float3(px_grid[2] - mean.xxx);
    return float3x3(row1.x, row1.y, row1.z,
                    row2.x, row2.y, row2.z,
                    row3.x, row3.y, row3.z);
}
float3x3 mean_diff(in float3x3 px_grid)
{
    return mean_diff(px_grid, Avg3x3(px_grid));
}

float Avg9(in float px_array[9])
{
    return dot3xN(asfloat3x3_array9(px_array), rcp(9));
}
float4 Avg9(in float4 px_array[9])
{
    float3x3 input_array[4];
    asfloat3x3_array(px_array, input_array);

    float4 sum = float4(Avg3x3(input_array[0]), Avg3x3(input_array[1]), Avg3x3(input_array[2]), Avg3x3(input_array[3]));
    return sum;
}

half Avg9(in half px_array[9])
{
    return dot3xN(ashalf3x3(px_array), rcp(9));
}
half4 Avg9(in half4 px_array[9])
{
    half3x3 input_array[4];
    ashalf3x3_array(px_array, input_array);

    return half4(Avg3x3(input_array[0]), Avg3x3(input_array[1]), Avg3x3(input_array[2]), Avg3x3(input_array[3]));
}

float3x3 mean_diff(in float px_array[9], in float mean)
{
    return mean_diff(asfloat3x3_array9(px_array), mean);
}
float3x3 mean_diff(in float px_array[9])
{
    return mean_diff(px_array, Avg9(px_array));
}

// 2x2
float variance_2x2(in float2x2 px_grid)
{
    return sqSum2xN(mean_diff(px_grid)) * rcp(4);
}
float std_dev_2x2(in float2x2 px_grid)
{
    return sqrt(variance_2x2(px_grid));
}
float std_dev_array4(float px_array[4])
{
    float2x2 px_grid = asfloat2x2(px_array);

    return std_dev_2x2(px_grid);
}

// 2x3
float variance_2x3(in float2x3 px_grid)
{
    return sqSum2xN(mean_diff(px_grid)) * float(rcp(6));
}
float2 variance_2x3_f2(in float2x3 px_grid[2])
{
    float2 mean;
    Avg2x3_2(px_grid, mean);
    const float2x3 diff[2] =
    {
        px_grid[0] - (float2x3)mean.r,
        px_grid[1] - (float2x3)mean.g,
    };
    return sqSum2xN(diff[0], diff[1]) * rcp(6);
}
float std_dev_2x3(in float2x3 px_grid)
{
    return sqrt(variance_2x3(px_grid));
}
float2 std_dev_2x3_f2(in float2x3 px_grid[2])
{
    return sqrt(variance_2x3_f2(px_grid));
}
float2 std_dev_2x3_f2(in float2x3 a, in float2x3 b)
{
    float2x3 array[2] = {a, b};
    return sqrt(variance_2x3_f2(array));
}

// 3x2
float variance_3x2(in float3x2 px_grid)
{
    return sqSum3xN(mean_diff(px_grid)) * float(rcp(6));
}
float2 variance_3x2_f2(in float3x2 px_grid[2])
{
    float2 mean;
    Avg3x2_2(px_grid, mean);
    const float3x2 diff[2] =
    {
        px_grid[0] - mean.r,
        px_grid[1] - mean.g,
    };
    return sqSum3xN(diff[0], diff[1]) * rcp(6);
}
float std_dev_3x2(in float3x2 px_grid)
{
    return sqrt(variance_3x2(px_grid));
}
float2 std_dev_3x2_f2(in float3x2 px_grid[2])
{
    return sqrt(variance_3x2_f2(px_grid));
}
float2 std_dev_3x2_f2(in float3x2 a, in float3x2 b)
{
    float3x2 array[2] = {a, b};
    return sqrt(variance_3x2_f2(array));
}

// 3x3
float variance_3x3(in float3x3 px_grid)
{
    return sqSum3xN(mean_diff(px_grid)) * (float)rcp(9);
}
float2 variance_3x3_f2(in float3x3 px_grid[2])
{
    return float2(sqSum3xN(mean_diff(px_grid[0])), sqSum3xN(mean_diff(px_grid[2]))) * (float2)rcp(9);
}
float4 variance_3x3_f4(in float3x3 px_grid[4])
{
    float4 mean;
    Avg3x3_4(px_grid, mean);
    const float3x3 diff[4] =
    {
        mean_diff(px_grid[0], mean.r),
        mean_diff(px_grid[1], mean.g),
        mean_diff(px_grid[2], mean.b),
        mean_diff(px_grid[3], mean.a),
    };
    return sqSum3xN(diff[0], diff[1], diff[2], diff[3]) * rcp(9).xxxx;
}

// 3x2
half variance_3x2(in half3x2 px_grid)
{
    return sqSum3xN(mean_diff(px_grid)) * rcp(6);
}
half2 variance_3x2_h2(in half3x2 px_grid[2])
{
    half2 mean;
    Avg3x2_2(px_grid, mean);
    const half3x2 diff[2] =
    {
        px_grid[0] - mean.r,
        px_grid[1] - mean.g,
    };
    return sqSum3xN(diff[0], diff[1]) * rcp(6);
}
half std_dev_3x2(in half3x2 px_grid)
{
    return sqrt(variance_3x2(px_grid));
}
half std_dev_3x2(half px_array[6])
{
    const half3x2 px_grid = ashalf3x2(px_array);

    return std_dev_3x2(px_grid);
}
half2 std_dev_3x2_h2(in half3x2 px_grid[2])
{
    return sqrt(variance_3x2_h2(px_grid));
}
half2 std_dev_3x2_h2(in half3x2 a, in half3x2 b)
{
    half3x2 array[2] = {a, b};
    return sqrt(variance_3x2_h2(array));
}

// 3x3
half variance_3x3(in half3x3 px_grid)
{
    return sqSum3xN(mean_diff(px_grid)) * rcp(9);
}
half2 variance_3x3_h2(in half3x3 px_grid[2])
{
    return half2(sqSum3xN(mean_diff(px_grid[0])), sqSum3xN(mean_diff(px_grid[2]))) * (half2)rcp(9);
}
half4 variance_3x3_h4(in half3x3 px_grid[4])
{
    half4 mean;
    Avg3x3_4(px_grid, mean);
    const half3x3 diff[4] =
    {
        px_grid[0] - (half3x3)mean.r,
        px_grid[1] - (half3x3)mean.g,
        px_grid[2] - (half3x3)mean.b,
        px_grid[3] - (half3x3)mean.a
    };
    return sqSum3xN(diff[0], diff[1], diff[2], diff[3]) * rcp(9);
}

float std_dev_3x3(in float3x3 px_grid)
{
    return sqrt(variance_3x3(px_grid));
}
float std_dev_array9(float px_array[9])
{
    float3x3 px_grid = asfloat3x3_array9(px_array);

    return std_dev_3x3(px_grid);
}

float2 std_dev_3x3_f2(float3x3 a, float3x3 b)
{
    float3x3 array[2] = {a, b};
    return sqrt(variance_3x3_f2(array));
}

float4 std_dev_3x3_f4(float3x3 a, float3x3 b, float3x3 c, float3x3 d)
{
    float3x3 array[4] = {a, b, c, d};
    float4 variance = variance_3x3_f4(array);
    return float4(SafeSqrt(variance.x), SafeSqrt(variance.y), SafeSqrt(variance.z), SafeSqrt(variance.w));
}
float4 std_dev_3x3_f4(float3x3 px_grid[4])
{
    float4 variance = variance_3x3_f4(px_grid);
    return float4(SafeSqrt(variance.x), SafeSqrt(variance.y), SafeSqrt(variance.z), SafeSqrt(variance.w));
}
float4 std_dev_f4_array(float4 px_array[9])
{
    float3x3 mat_array[4];
    asfloat3x3_array(px_array, mat_array);
    return std_dev_3x3_f4(mat_array);
}

half4 std_dev_3x3_h4(half3x3 a, half3x3 b, half3x3 c, half3x3 d)
{
    half3x3 array[4] = {a, b, c, d};
    half4 variance = variance_3x3_h4(array);
    return half4(SafeSqrt(variance.x), SafeSqrt(variance.y), SafeSqrt(variance.z), SafeSqrt(variance.w));
}
half4 std_dev_3x3_h4(half3x3 px_grid[4])
{
    half4 variance = variance_3x3_h4(px_grid);
    return half4(SafeSqrt(variance.x), SafeSqrt(variance.y), SafeSqrt(variance.z), SafeSqrt(variance.w));
}
half4 std_dev_h4_array(half4 px_array[9])
{
    half3x3 mat_array[4];
    ashalf3x3_array(px_array, mat_array);
    return std_dev_3x3_h4(mat_array);
}

/*
void std_dev_3x3_f2(float3x3 a, float3x3 b, out float2 std)
{
    std = std_dev_3x3_f2(a, b);
}
*/

void std_dev_3x3_array(float3x3 a, float3x3 b, float3x3 c, float3x3 d, out float4 std)
{
    std = std_dev_3x3_f4(a, b, c, d);
}
void std_dev_3x3_array(half3x3 a, half3x3 b, half3x3 c, half3x3 d, out half4 std)
{
    std = std_dev_3x3_h4(a, b, c, d);
}

#endif
