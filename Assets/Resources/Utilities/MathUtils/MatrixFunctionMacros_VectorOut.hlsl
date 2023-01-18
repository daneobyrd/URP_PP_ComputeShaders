//_____________________________________________________________/\_______________________________________________________________
//==============================================================================================================================
#ifndef MATRIX_FUNCTION_MACROS_VECTOR_OUT
#define MATRIX_FUNCTION_MACROS_VECTOR_OUT

#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Macros.hlsl"
#define CONCAT_NAME(A, B, C) CALL_MERGE_NAME(A, MERGE_NAME(B,C))

// One parameter template.
//------------------------------------------------------------------------------------------------------------------------------

// float, half, bool 
/*==============================================================================================================================
Assumes type is not int or uint and that typedef or macro exists for matrix<type> (i.e. float2x4, half3x3).
Use TEMPLATE_#_MATRIX_INT# for int and uint data types.                                                                       */

//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_SCALAR(type, FunctionName, Rows, Parameter1, FunctionBody) \
    type FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_VEC2(type, FunctionName, Rows, Parameter1, FunctionBody) \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_VEC3(type, FunctionName, Rows, Parameter1, FunctionBody) \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_VEC4(type, FunctionName, Rows, Parameter1, FunctionBody) \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1) { FunctionBody; }

// int & uint
// Checks graphics API compatability (GLES) before declaring uint functions.
//==============================================================================================================================
#ifdef SHADER_API_GLES
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_INT(FunctionName, Rows, Parameter1, FunctionBody) \
    int FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_INT2(FunctionName, Rows, Parameter1, FunctionBody) \
    int2 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_INT3(FunctionName, Rows, Parameter1, FunctionBody) \
    int3 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_INT4(FunctionName, Rows, Parameter1, FunctionBody) \
    int4 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }

#else
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_INT(FunctionName, Rows, Parameter1, FunctionBody) \
     int FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
     int FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
     int FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_INT2(type, FunctionName, Rows, Parameter1, FunctionBody) \
     int2 FunctionName(CONCAT_NAME(int, Rows, x2) { FunctionBody; } \
     int2 FunctionName(CONCAT_NAME(int, Rows, x3) { FunctionBody; } \
     int2 FunctionName(CONCAT_NAME(int, Rows, x4) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(int, Rows, x2) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(int, Rows, x3) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(int, Rows, x4) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_1_MATRIX_INT3(type, FunctionName, Rows, Parameter1, FunctionBody) \
     int3 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
     int3 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
     int3 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_1_MATRIX_INT4(type, FunctionName, Rows, Parameter1, FunctionBody) \
     int4 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
     int4 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
     int4 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#endif

// Two parameter template.
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_SCALAR(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    type FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_VEC2(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_VEC3(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_VEC4(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================

// int & uint
#ifdef SHADER_API_GLES
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_INT(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    int FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_INT2(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    int2 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_INT3(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    int3 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_INT4(type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    int4 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------

#else
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_INT(FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
     int FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
     int FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
     int FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_INT2(FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
     int2 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
     int2 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
     int2 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================
#define TEMPLATE_2_MATRIX_INT3(FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
     int3 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
     int3 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
     int3 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2) { FunctionBody; }
//------------------------------------------------------------------------------------------------------------------------------
#define TEMPLATE_2_MATRIX_INT4(FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
     int4 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
     int4 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
     int4 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2) { FunctionBody; }
//==============================================================================================================================

#endif

// Three parameter template.

#define TEMPLATE_3_MATRIX_SCALAR(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    type FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_VEC2(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_VEC3(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_VEC4(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3) { FunctionBody; }

#ifdef SHADER_API_GLES
#define TEMPLATE_3_MATRIX_INT(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    int FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
    int FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT2(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    int2 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
    int2 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT3(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    int3 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
    int3 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT4(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
    int4 FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
    int4 FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; }

#else
#define TEMPLATE_3_MATRIX_INT(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
     int FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2,  CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
     int FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2,  CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
     int FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2,  CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT2(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
     int2 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2,  CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
     int2 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2,  CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
     int2 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2,  CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT3(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
     int3 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2,  CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
     int3 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2,  CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
     int3 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2,  CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3) { FunctionBody; }
#define TEMPLATE_3_MATRIX_INT4(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, FunctionBody) \
     int4 FunctionName( CONCAT_NAME(int, Rows, x2) Parameter1,  CONCAT_NAME(int, Rows, x2) Parameter2,  CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
     int4 FunctionName( CONCAT_NAME(int, Rows, x3) Parameter1,  CONCAT_NAME(int, Rows, x3) Parameter2,  CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
     int4 FunctionName( CONCAT_NAME(int, Rows, x4) Parameter1,  CONCAT_NAME(int, Rows, x4) Parameter2,  CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3) { FunctionBody; }
#endif

// Template_4
// Float
#define TEMPLATE_4_MATRIX_SCALAR(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    type FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3, CONCAT_NAME(type, Rows, x2) Parameter4) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3, CONCAT_NAME(type, Rows, x3) Parameter4) { FunctionBody; } \
    type FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3, CONCAT_NAME(type, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_VEC2(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3, CONCAT_NAME(type, Rows, x2) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3, CONCAT_NAME(type, Rows, x3) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 2) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3, CONCAT_NAME(type, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_VEC3(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3, CONCAT_NAME(type, Rows, x2) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3, CONCAT_NAME(type, Rows, x3) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 3) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3, CONCAT_NAME(type, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_VEC4(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x2) Parameter1, CONCAT_NAME(type, Rows, x2) Parameter2, CONCAT_NAME(type, Rows, x2) Parameter3, CONCAT_NAME(type, Rows, x2) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x3) Parameter1, CONCAT_NAME(type, Rows, x3) Parameter2, CONCAT_NAME(type, Rows, x3) Parameter3, CONCAT_NAME(type, Rows, x3) Parameter4) { FunctionBody; } \
    MERGE_NAME(type, 4) FunctionName(CONCAT_NAME(type, Rows, x4) Parameter1, CONCAT_NAME(type, Rows, x4) Parameter2, CONCAT_NAME(type, Rows, x4) Parameter3, CONCAT_NAME(type, Rows, x4) Parameter4) { FunctionBody; }

#ifdef SHADER_API_GLES
#define TEMPLATE_4_MATRIX_INT(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    int FunctionName(MERGE_NAME(int, Rows, x2) Parameter1, MERGE_NAME(int, Rows, x2) Parameter2, MERGE_NAME(int, Rows, x2) Parameter3, MERGE_NAME(int, Rows, x2) Parameter4) { FunctionBody; } \
    int FunctionName(MERGE_NAME(int, Rows, x3) Parameter1, MERGE_NAME(int, Rows, x3) Parameter2, MERGE_NAME(int, Rows, x3) Parameter3, MERGE_NAME(int, Rows, x3) Parameter4) { FunctionBody; } \
    int FunctionName(MERGE_NAME(int, Rows, x4) Parameter1, MERGE_NAME(int, Rows, x4) Parameter2, MERGE_NAME(int, Rows, x4) Parameter3, MERGE_NAME(int, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_INT2(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    int2 FunctionName(MERGE_NAME(int, Rows, x2) Parameter1, MERGE_NAME(int, Rows, x2) Parameter2, MERGE_NAME(int, Rows, x2) Parameter3, MERGE_NAME(int, Rows, x2) Parameter4) { FunctionBody; } \
    int2 FunctionName(MERGE_NAME(int, Rows, x3) Parameter1, MERGE_NAME(int, Rows, x3) Parameter2, MERGE_NAME(int, Rows, x3) Parameter3, MERGE_NAME(int, Rows, x3) Parameter4) { FunctionBody; } \
    int2 FunctionName(MERGE_NAME(int, Rows, x4) Parameter1, MERGE_NAME(int, Rows, x4) Parameter2, MERGE_NAME(int, Rows, x4) Parameter3, MERGE_NAME(int, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_INT3(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    int3 FunctionName(MERGE_NAME(int, Rows, x2) Parameter1, MERGE_NAME(int, Rows, x2) Parameter2, MERGE_NAME(int, Rows, x2) Parameter3, MERGE_NAME(int, Rows, x2) Parameter4) { FunctionBody; } \
    int3 FunctionName(MERGE_NAME(int, Rows, x3) Parameter1, MERGE_NAME(int, Rows, x3) Parameter2, MERGE_NAME(int, Rows, x3) Parameter3, MERGE_NAME(int, Rows, x3) Parameter4) { FunctionBody; } \
    int3 FunctionName(MERGE_NAME(int, Rows, x4) Parameter1, MERGE_NAME(int, Rows, x4) Parameter2, MERGE_NAME(int, Rows, x4) Parameter3, MERGE_NAME(int, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_INT4(type, FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    int4 FunctionName(MERGE_NAME(int, Rows, x2) Parameter1, MERGE_NAME(int, Rows, x2) Parameter2, MERGE_NAME(int, Rows, x2) Parameter3, MERGE_NAME(int, Rows, x2) Parameter4) { FunctionBody; } \
    int4 FunctionName(MERGE_NAME(int, Rows, x3) Parameter1, MERGE_NAME(int, Rows, x3) Parameter2, MERGE_NAME(int, Rows, x3) Parameter3, MERGE_NAME(int, Rows, x3) Parameter4) { FunctionBody; } \
    int4 FunctionName(MERGE_NAME(int, Rows, x4) Parameter1, MERGE_NAME(int, Rows, x4) Parameter2, MERGE_NAME(int, Rows, x4) Parameter3, MERGE_NAME(int, Rows, x4) Parameter4) { FunctionBody; }

#else

#define TEMPLATE_4_MATRIX_INT(FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
     int FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3, CONCAT_NAME( int, Rows, x2) Parameter4) { FunctionBody; } \
     int FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3, CONCAT_NAME( int, Rows, x3) Parameter4) { FunctionBody; } \
     int FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3, CONCAT_NAME( int, Rows, x4) Parameter4) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3, CONCAT_NAME(uint, Rows, x2) Parameter4) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3, CONCAT_NAME(uint, Rows, x3) Parameter4) { FunctionBody; } \
    uint FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3, CONCAT_NAME(uint, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_INT2(FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
     int2 FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3, CONCAT_NAME( int, Rows, x2) Parameter4) { FunctionBody; } \
     int2 FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3, CONCAT_NAME( int, Rows, x3) Parameter4) { FunctionBody; } \
     int2 FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3, CONCAT_NAME( int, Rows, x4) Parameter4) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3, CONCAT_NAME(uint, Rows, x2) Parameter4) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3, CONCAT_NAME(uint, Rows, x3) Parameter4) { FunctionBody; } \
    uint2 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3, CONCAT_NAME(uint, Rows, x4) Parameter4) { FunctionBody; } 
#define TEMPLATE_4_MATRIX_INT3(FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
     int3 FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3, CONCAT_NAME( int, Rows, x2) Parameter4) { FunctionBody; } \
     int3 FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3, CONCAT_NAME( int, Rows, x3) Parameter4) { FunctionBody; } \
     int3 FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3, CONCAT_NAME( int, Rows, x4) Parameter4) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3, CONCAT_NAME(uint, Rows, x2) Parameter4) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3, CONCAT_NAME(uint, Rows, x3) Parameter4) { FunctionBody; } \
    uint3 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3, CONCAT_NAME(uint, Rows, x4) Parameter4) { FunctionBody; }
#define TEMPLATE_4_MATRIX_INT4( FunctionName, Rows, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
     int4 FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3, CONCAT_NAME( int, Rows, x2) Parameter4) { FunctionBody; } \
     int4 FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3, CONCAT_NAME( int, Rows, x3) Parameter4) { FunctionBody; } \
     int4 FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3, CONCAT_NAME( int, Rows, x4) Parameter4) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3, CONCAT_NAME(uint, Rows, x2) Parameter4) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3, CONCAT_NAME(uint, Rows, x3) Parameter4) { FunctionBody; } \
    uint4 FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3, CONCAT_NAME(uint, Rows, x4) Parameter4) { FunctionBody; }
#endif

#endif