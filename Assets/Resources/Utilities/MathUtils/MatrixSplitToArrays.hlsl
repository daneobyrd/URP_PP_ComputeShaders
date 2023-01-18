/*#ifndef MATRIX_SPLIT_TO_ARRAYS_INCLUDED
#define MATRIX_SPLIT_TO_ARRAYS_INCLUDED

#define UNPACK_MATRIX_STRUCT_TO_ARRAY(Type, array) \
void MERGE_NAME(unpack_, Type##4x4_4)(in Type##4x4 mat[4], out vector<Type, 4> array[16]) \
{ \
array[0]  = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1]  = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2]  = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
array[3]  = vector<Type, 4>((mat[0])[0][3], (mat[1])[0][3], (mat[2])[0][3], (mat[3])[0][3]); \
array[4]  = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[5]  = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[6]  = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
array[7]  = vector<Type, 4>((mat[0])[1][3], (mat[1])[1][3], (mat[2])[1][3], (mat[3])[1][3]); \
array[8]  = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[9]  = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
array[10] = vector<Type, 4>((mat[0])[2][2], (mat[1])[2][2], (mat[2])[2][2], (mat[3])[2][2]); \
array[11] = vector<Type, 4>((mat[0])[2][3], (mat[1])[2][3], (mat[2])[2][3], (mat[3])[2][3]); \
array[12] = vector<Type, 4>((mat[0])[3][0], (mat[1])[3][0], (mat[2])[3][0], (mat[3])[3][0]); \
array[13] = vector<Type, 4>((mat[0])[3][1], (mat[1])[3][1], (mat[2])[3][1], (mat[3])[3][1]); \
array[14] = vector<Type, 4>((mat[0])[3][2], (mat[1])[3][2], (mat[2])[3][2], (mat[3])[3][2]); \
array[15] = vector<Type, 4>((mat[0])[3][3], (mat[1])[3][3], (mat[2])[3][3], (mat[3])[3][3]); \
} \
void MERGE_NAME(unpack_, Type##4x3_4)(in Type##4x3 mat[4], out vector<Type, 4> array[12]) \
{ \
array[0]  = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1]  = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2]  = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
\
array[3]  = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[4]  = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[5]  = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
\
array[6]  = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[7]  = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
array[8]  = vector<Type, 4>((mat[0])[2][2], (mat[1])[2][2], (mat[2])[2][2], (mat[3])[2][2]); \
\
array[9]  = vector<Type, 4>((mat[0])[3][0], (mat[1])[3][0], (mat[2])[3][0], (mat[3])[3][0]); \
array[10] = vector<Type, 4>((mat[0])[3][1], (mat[1])[3][1], (mat[2])[3][1], (mat[3])[3][1]); \
array[11] = vector<Type, 4>((mat[0])[3][2], (mat[1])[3][2], (mat[2])[3][2], (mat[3])[3][2]); \
} \
void MERGE_NAME(unpack_, Type##3x4_4)(in Type##3x4 mat[4], out vector<Type, 4> array[12]) \
{ \
array[0]  = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1]  = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2]  = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
array[3]  = vector<Type, 4>((mat[0])[0][3], (mat[1])[0][3], (mat[2])[0][3], (mat[3])[0][3]); \
\
array[4]  = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[5]  = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[6]  = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
array[7]  = vector<Type, 4>((mat[0])[1][3], (mat[1])[1][3], (mat[2])[1][3], (mat[3])[1][3]); \
\
array[8]  = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[9]  = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
array[10] = vector<Type, 4>((mat[0])[2][2], (mat[1])[2][2], (mat[2])[2][2], (mat[3])[2][2]); \
array[11] = vector<Type, 4>((mat[0])[2][3], (mat[1])[2][3], (mat[2])[2][3], (mat[3])[2][3]); \
} \
void MERGE_NAME(unpack_, Type##3x3_4)(in Type##3x3 mat[4], out vector<Type, 4> array[9]) \
{ \
array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2] = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
\
array[3] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[4] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[5] = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
\
array[6] = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[7] = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
array[8] = vector<Type, 4>((mat[0])[2][2], (mat[1])[2][2], (mat[2])[2][2], (mat[3])[2][2]); \
} \
void MERGE_NAME(unpack_, Type##4x2_4)(in Type##4x2 mat[4], out vector<Type, 4> array[8]) \
{ \
array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[3] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[4] = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[5] = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
array[6] = vector<Type, 4>((mat[0])[3][0], (mat[1])[3][0], (mat[2])[3][0], (mat[3])[3][0]); \
array[7] = vector<Type, 4>((mat[0])[3][1], (mat[1])[3][1], (mat[2])[3][1], (mat[3])[3][1]); \
} \
void MERGE_NAME(unpack_, Type##2x4_4)(in Type##2x4 mat[4], out vector<Type, 4> array[8]) \
{ \
array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2] = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
array[3] = vector<Type, 4>((mat[0])[0][3], (mat[1])[0][3], (mat[2])[0][3], (mat[3])[0][3]); \
array[4] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[5] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[6] = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
array[7] = vector<Type, 4>((mat[0])[1][3], (mat[1])[1][3], (mat[2])[1][3], (mat[3])[1][3]); \
} \
void MERGE_NAME(unpack_, Type##3x2_4)(in Type##3x2 mat[4], out vector<Type, 4> array[6]) \
{ \
array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
\
array[2] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[3] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
\
array[4] = vector<Type, 4>((mat[0])[2][0], (mat[1])[2][0], (mat[2])[2][0], (mat[3])[2][0]); \
array[5] = vector<Type, 4>((mat[0])[2][1], (mat[1])[2][1], (mat[2])[2][1], (mat[3])[2][1]); \
} \
void MERGE_NAME(unpack_, Type##2x3_4)(in Type##2x3 mat[4], out vector<Type, 4> array[6]) \
{ \
array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
array[2] = vector<Type, 4>((mat[0])[0][2], (mat[1])[0][2], (mat[2])[0][2], (mat[3])[0][2]); \
array[3] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
array[4] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
array[5] = vector<Type, 4>((mat[0])[1][2], (mat[1])[1][2], (mat[2])[1][2], (mat[3])[1][2]); \
} \
void MERGE_NAME(unpack_, Type##2x2_4)(in Type##2x2 mat[4], out vector<Type, 4> array[4]) \
{ \
    array[0] = vector<Type, 4>((mat[0])[0][0], (mat[1])[0][0], (mat[2])[0][0], (mat[3])[0][0]); \
    array[1] = vector<Type, 4>((mat[0])[0][1], (mat[1])[0][1], (mat[2])[0][1], (mat[3])[0][1]); \
    array[2] = vector<Type, 4>((mat[0])[1][0], (mat[1])[1][0], (mat[2])[1][0], (mat[3])[1][0]); \
    array[3] = vector<Type, 4>((mat[0])[1][1], (mat[1])[1][1], (mat[2])[1][1], (mat[3])[1][1]); \
}

UNPACK_MATRIX_STRUCT_TO_ARRAY(half, h_x)

UNPACK_MATRIX_STRUCT_TO_ARRAY(float, array)

#if REAL_IS_HALF
void  unpack_real2x2_4(in half2x2 mat[4], out half4 array[4])  { unpack_half2x2_4(mat, array); }
void  unpack_real2x3_4(in half2x3 mat[4], out half4 array[6])  { unpack_half2x3_4(mat, array); }
void  unpack_real2x4_4(in half2x4 mat[4], out half4 array[8])  { unpack_half2x4_4(mat, array); }
void  unpack_real3x2_4(in half3x2 mat[4], out half4 array[6])  { unpack_half3x2_4(mat, array); }
void  unpack_real3x3_4(in half3x3 mat[4], out half4 array[9])  { unpack_half3x3_4(mat, array); }
void  unpack_real3x4_4(in half3x4 mat[4], out half4 array[12]) { unpack_half3x4_4(mat, array); }
void  unpack_real4x3_4(in half4x3 mat[4], out half4 array[12]) { unpack_half4x3_4(mat, array); }
void  unpack_real4x4_4(in half4x4 mat[4], out half4 array[16]) { unpack_half4x4_4(mat, array); }

#else
void  unpack_real2x2_4(in float2x2 mat[4], out float4 array[4])  { unpack_float2x2_4(mat, array); }
void  unpack_real2x3_4(in float2x3 mat[4], out float4 array[6])  { unpack_float2x3_4(mat, array); }
void  unpack_real2x4_4(in float2x4 mat[4], out float4 array[8])  { unpack_float2x4_4(mat, array); }
void  unpack_real3x2_4(in float3x2 mat[4], out float4 array[6])  { unpack_float3x2_4(mat, array); }
void  unpack_real3x3_4(in float3x3 mat[4], out float4 array[9])  { unpack_float3x3_4(mat, array); }
void  unpack_real3x4_4(in float3x4 mat[4], out float4 array[12]) { unpack_float3x4_4(mat, array); }
void  unpack_real4x3_4(in float4x3 mat[4], out float4 array[12]) { unpack_float4x3_4(mat, array); }
void  unpack_real4x4_4(in float4x4 mat[4], out float4 array[16]) { unpack_float4x4_4(mat, array); }
#endif

#ifndef SHADER_API_GLES

UNPACK_MATRIX_STRUCT_TO_ARRAY(uint, array)

#endif

UNPACK_MATRIX_STRUCT_TO_ARRAY(int, array)

#endif*/