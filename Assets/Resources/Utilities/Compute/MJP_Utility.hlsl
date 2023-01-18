//=================================================================================================
//
//	MJP's DX11 Sample Framework
//  http://mynameismjp.wordpress.com/
//
//  All code licensed under the MIT license
//
//=================================================================================================

// Computes a compute shader dispatch size given a thread group size, and number of elements to process
uint DispatchSize(uint tgSize, uint numElements)
{
    uint dispatchSize = numElements / tgSize;
    dispatchSize += numElements % tgSize > 0 ? 1 : 0;
    return dispatchSize;
}

// Returns a size suitable for creating a constant buffer, by rounding up
// to the next multiple of 16
inline uint CBSize(uint size)
{
    uint cbsize = size + (16 - (size % 16));
    return cbsize;
}
