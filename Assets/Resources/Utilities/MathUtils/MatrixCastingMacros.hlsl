#ifndef MATRIX_CASTING_MACROS_VECTOR_OUT
#define MATRIX_CASTING_MACROS_VECTOR_OUT

#ifndef CONCAT_NAME
#define CONCAT_NAME(A, B, C) CALL_MERGE_NAME(A, MERGE_NAME(B, C))
#endif

// Template_1
// Float
#define TEMPLATE_1_CAST_MATRIX(Type, FunctionName, Rows, Parameter1, FunctionBody) \
    CONCAT_NAME(Type, Rows, x2) FunctionName(CONCAT_NAME(Type, Rows, x2) Parameter1) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x3) FunctionName(CONCAT_NAME(Type, Rows, x3) Parameter1) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x4) FunctionName(CONCAT_NAME(Type, Rows, x4) Parameter1) { FunctionBody; } \

// Int
#ifdef SHADER_API_GLES
#define TEMEMPLATE_1_CAST_MATRIX_INT(FunctionName, Rows, Parameter1, FunctionBody) \
    CONCAT_NAME( int, Rows, x2) FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x3) FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x4) FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1) { FunctionBody; } \

#else
#define TEMPLATE_1_CAST_MATRIX_INT(FunctionName, Parameter1, FunctionBody) \
    CONCAT_NAME( int, Rows, x2) FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x3) FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x4) FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x2) FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x3) FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x4) FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1) { FunctionBody; }
#endif

// Template_2
#define TEMPLATE_2_CAST_MATRIX(Type, FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    CONCAT_NAME(Type, Rows, x2) FunctionName(CONCAT_NAME(Type, Rows, x2) Parameter1, CONCAT_NAME(Type, Rows, x2) Parameter2) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x3) FunctionName(CONCAT_NAME(Type, Rows, x3) Parameter1, CONCAT_NAME(Type, Rows, x3) Parameter2) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x4) FunctionName(CONCAT_NAME(Type, Rows, x4) Parameter1, CONCAT_NAME(Type, Rows, x4) Parameter2) { FunctionBody; }

#ifdef SHADER_API_GLES
#define TEMEMPLATE_2_CAST_MATRIX_INT(FunctionName, Rows, Parameter1, Parameter2, FunctionBody) \
    CONCAT_NAME(int, Rows, x2) FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x3) FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x4) FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2) { FunctionBody; }

#else
#define TEMPLATE_2_CAST_MATRIX_INT(FunctionName, Parameter1, Parameter2, FunctionBody) \
    CONCAT_NAME( int, Rows, x2) FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x3) FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x4) FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x2) FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x3) FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x4) FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2) { FunctionBody; }
#endif

// Template_3
#define TEMPLATE_3_CAST_MATRIX(Type, FunctionName, Parameter1, Parameter2, Parameter3, FunctionBody) \
    CONCAT_NAME(Type, Rows, x2) FunctionName(CONCAT_NAME(Type, Rows, x2) Parameter1, CONCAT_NAME(Type, Rows, x2) Parameter2, CONCAT_NAME(Type, Rows, x2) Parameter3) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x3) FunctionName(CONCAT_NAME(Type, Rows, x3) Parameter1, CONCAT_NAME(Type, Rows, x3) Parameter2, CONCAT_NAME(Type, Rows, x3) Parameter3) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x4) FunctionName(CONCAT_NAME(Type, Rows, x4) Parameter1, CONCAT_NAME(Type, Rows, x4) Parameter2, CONCAT_NAME(Type, Rows, x4) Parameter3) { FunctionBody; }

#ifdef SHADER_API_GLES
#define TEMPLATE_3_CAST_MATRIX_INT(FunctionName, Parameter1, Parameter2, Parameter3, FunctionBody) \
    CONCAT_NAME(int, Rows, x2) FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x3) FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x4) FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3) { FunctionBody; }
#else
#define TEMPLATE_3_CAST_MATRIX_INT(FunctionName, Parameter1, Parameter2, Parameter3, FunctionBody) \
    CONCAT_NAME( int, Rows, x2) FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x3) FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x4) FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x2) FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x3) FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x4) FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3) { FunctionBody; }
#endif

// Template_4
#define TEMPLATE_4_CAST_MATRIX(Type, FunctionName, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    CONCAT_NAME(Type, Rows, x2) FunctionName(CONCAT_NAME(Type, Rows, x2) Parameter1, CONCAT_NAME(Type, Rows, x2) Parameter2, CONCAT_NAME(Type, Rows, x2) Parameter3, float2x2 Parameter4) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x3) FunctionName(CONCAT_NAME(Type, Rows, x3) Parameter1, CONCAT_NAME(Type, Rows, x3) Parameter2, CONCAT_NAME(Type, Rows, x3) Parameter3, float2x3 Parameter4) { FunctionBody; } \
    CONCAT_NAME(Type, Rows, x4) FunctionName(CONCAT_NAME(Type, Rows, x4) Parameter1, CONCAT_NAME(Type, Rows, x4) Parameter2, CONCAT_NAME(Type, Rows, x4) Parameter3, float2x4 Parameter4) { FunctionBody; }

#ifdef SHADER_API_GLES
#define TEMPLATE_4_CAST_MATRIX_INT(FunctionName, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    CONCAT_NAME(int, Rows, x2) FunctionName(CONCAT_NAME(int, Rows, x2) Parameter1, CONCAT_NAME(int, Rows, x2) Parameter2, CONCAT_NAME(int, Rows, x2) Parameter3, CONCAT_NAME(int, Rows, x2) Parameter4) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x3) FunctionName(CONCAT_NAME(int, Rows, x3) Parameter1, CONCAT_NAME(int, Rows, x3) Parameter2, CONCAT_NAME(int, Rows, x3) Parameter3, CONCAT_NAME(int, Rows, x3) Parameter4) { FunctionBody; } \
    CONCAT_NAME(int, Rows, x4) FunctionName(CONCAT_NAME(int, Rows, x4) Parameter1, CONCAT_NAME(int, Rows, x4) Parameter2, CONCAT_NAME(int, Rows, x4) Parameter3, CONCAT_NAME(int, Rows, x4) Parameter4) { FunctionBody; }
#else
#define TEMPLATE_4_CAST_MATRIX_INT(FunctionName, Parameter1, Parameter2, Parameter3, Parameter4, FunctionBody) \
    CONCAT_NAME( int, Rows, x2) FunctionName(CONCAT_NAME( int, Rows, x2) Parameter1, CONCAT_NAME( int, Rows, x2) Parameter2, CONCAT_NAME( int, Rows, x2) Parameter3, CONCAT_NAME( int, Rows, x2) Parameter4) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x3) FunctionName(CONCAT_NAME( int, Rows, x3) Parameter1, CONCAT_NAME( int, Rows, x3) Parameter2, CONCAT_NAME( int, Rows, x3) Parameter3, CONCAT_NAME( int, Rows, x3) Parameter4) { FunctionBody; } \
    CONCAT_NAME( int, Rows, x4) FunctionName(CONCAT_NAME( int, Rows, x4) Parameter1, CONCAT_NAME( int, Rows, x4) Parameter2, CONCAT_NAME( int, Rows, x4) Parameter3, CONCAT_NAME( int, Rows, x4) Parameter4) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x2) FunctionName(CONCAT_NAME(uint, Rows, x2) Parameter1, CONCAT_NAME(uint, Rows, x2) Parameter2, CONCAT_NAME(uint, Rows, x2) Parameter3, CONCAT_NAME(uint, Rows, x2) Parameter4) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x3) FunctionName(CONCAT_NAME(uint, Rows, x3) Parameter1, CONCAT_NAME(uint, Rows, x3) Parameter2, CONCAT_NAME(uint, Rows, x3) Parameter3, CONCAT_NAME(uint, Rows, x3) Parameter4) { FunctionBody; } \
    CONCAT_NAME(uint, Rows, x4) FunctionName(CONCAT_NAME(uint, Rows, x4) Parameter1, CONCAT_NAME(uint, Rows, x4) Parameter2, CONCAT_NAME(uint, Rows, x4) Parameter3, CONCAT_NAME(uint, Rows, x4) Parameter4) { FunctionBody; }
#endif

#endif