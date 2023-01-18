#ifndef CONVOLUTION_INCLUDED
#define CONVOLUTION_INCLUDED
#include "MatrixFunctionMacros_VectorOut.hlsl"


// Length2 in ShaderLibrary\Common.hlsl
half Length2(in half2 v) { return dot(v, v); }
half Length2(in half4 v) { return dot(v, v); }
float Length2(in float2 v) { return dot(v, v); }
float Length2(in float4 v) { return dot(v, v); }

// from Inigo Quilez dist functions
half ndot(in half2 a, in half2 b) { return a.x * b.x - a.y * b.y; }
float ndot(in float2 a, in float2 b) { return a.x * b.x - a.y * b.y; }

// Dot product is perfect for convolution
// A = (a1, a2, a3 ... aN);
// B = (b1, b2, b3 ... bN);
// A•B = (a1b1 + a2b2 + a3b3 + ... aNbN);

TEMPLATE_2_MATRIX_SCALAR(float,dot2xN, 2, a, b, return (dot(a[0], b[0]) + dot(a[1], b[1])))
TEMPLATE_2_MATRIX_SCALAR(half, dot2xN, 2, a, b, return (dot(a[0], b[0]) + dot(a[1], b[1])))

TEMPLATE_2_MATRIX_SCALAR(float, dot3xN, 3, a, b, return(dot(a[0], b[0]) + dot(a[1], b[1]) + dot(a[2], b[2])))
TEMPLATE_2_MATRIX_SCALAR(half, dot3xN, 3, a, b, return(dot(a[0], b[0]) + dot(a[1], b[1]) + dot(a[2], b[2])))

TEMPLATE_2_MATRIX_SCALAR(float, dot4xN, 4, a, b, return float(dot(a[0], b[0]) + dot(a[1], b[1]) + dot(a[2], b[2]) + dot(a[3], b[3])))
TEMPLATE_2_MATRIX_SCALAR(half, dot4xN, 4, a, b, return half(dot(a[0], b[0]) + dot(a[1], b[1]) + dot(a[2], b[2]) + dot(a[3], b[3])))
#endif
