#ifndef FLOAT_BIT_MATH_INCLUDED
#define FLOAT_BIT_MATH_INCLUDED
/**
 * \brief Add the float4 in the low-half of val to the float4 in the high-half of val.
 * \param val A uint4 packed with two float4 values.
 * \return The sum of the two packed float4s.
 */
float4 AddFirst16AndLast16Bits_uint(in uint4 val)
{
    // f16tof32: Converts the float16 stored in the low-half of the uint to a float.
    return float4(f16tof32(val) + f16tof32(val >> 16));
}

float AddFirst16AndLast16Bits_uint(in uint val)
{
    // f16tof32: Converts the float16 stored in the low-half of the uint to a float.
    return float(f16tof32(val) + f16tof32(val >> 16));
}

/**
 * \brief Add the float4 in the low-half of val to the float4 in the high-half of val.
 * \param val A uint4 packed with two float4 values.
 * \param val_float The sum of the two packed float4s.
 */
void AddFirst16AndLast16Bits(in uint4 val, out float4 val_float)
{
    // f16tof32: Converts the float16 stored in the low-half of the uint to a float.
    val_float = float4(f16tof32(val) + f16tof32(val >> 16));
}

void AddFirst16AndLast16Bits(in uint val, out float val_float)
{
    // f16tof32: Converts the float16 stored in the low-half of the uint to a float.
    val_float = float(f16tof32(val) + f16tof32(val >> 16));
} //low-half of val + high-half of val

/**
 * \brief Add the float4 in the low-half of val to the float4 in the high-half of val.
 * \param val A uint4 packed with two float4 values.
 * \return The sum of the two packed float4s.
 */
float4 AddFirst16AndLast16Bits_float(in float4 val)
{
    return AddFirst16AndLast16Bits_uint(asuint(val));
}

float AddFirst16AndLast16Bits_float(in float val)
{
    return AddFirst16AndLast16Bits_uint(asuint(val));
}

/**
 * \brief Add the float4 in the low-half of val to the float4 in the high-half of val.
 * \param val A uint4 packed with two float4 values.
 * \return The sum of the two packed float4s.
 */
void AddFirst16AndLast16Bits(inout float4 val)
{
    AddFirst16AndLast16Bits(asuint(val), val);
}

void AddFirst16AndLast16Bits(inout float val)
{
    AddFirst16AndLast16Bits(asuint(val), val);
}
#endif
