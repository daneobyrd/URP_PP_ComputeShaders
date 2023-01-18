/*
// All ideas for misunderstanding of what the algorithm wanted during the standard deviation comparison.

// https://stackoverflow.com/questions/14415753/wrap-value-into-range-min-max-without-division
uint wrap_range(const in uint value, const in uint max)
{
    return (value + max) % (max * 2 + 1) - max;
}

static int cache_offset[15] =
{
    -18, -17, -16, //-15, -14, -13,
    -10,  -9,  -8, // -6,  -5,  -4,
    -2,   -1,   0, //  1,   2,   3,
     6,    7,   8, //  9,  10,  11,
    14,   15,  16, // 17,  18,  19
};
void StdDev3x3Mean(uint outIndex, uint leftMostIndex)
{
    /*
    ┌────────•─────┬────────•─────┬────────•─────┐
    │ px1[0] │     │ px1[1] │     │ px1[2] │     │
    ├────────•─────┼────────•─────┼────────•─────┤
    │ px1[3] │     │ px1[4] │     │ px1[5] │     │
    ├────────•─────┼────────•─────┼────────•─────┤
    │ px1[6] │     │ px1[7] │     │ px1[8] │     │
    └────────•─────┴────────•─────┴────────•─────┘
    #1#

    /*
      ┌─────•──────┬─────•─────┬──────•─────┐
      │  a  │  ab  │ abc │ bcd │  cd  │  d  │   aaa     bbb     ccc     ddd
      ├─────•──────┼─────•─────┼──────•─────┤   aaa     bbb     ccc     ddd
      │  a  │  ab  │ abc │ bcd │  cd  │  d  │	aaa     bbb     ccc     ddd
      │  e  │  ef  │ efg │ fgh │  gh  │  h  │
      ├─────•──────┼─────•─────┼──────•─────┤   eee     fff     ggg     hhh
      │  a  │  ab  │ abc │ bcd │  cd  │  d  │   eee     fff     ggg     hhh	
      │  e  │  ef  │ efg │ fgh │  gh  │  h  │   eee     fff     ggg     hhh
      │  i  │  ij  │ ijk │ jkl │  kl  │  l  │
      ├─────•──────┼─────•─────┼──────•─────┤   iii     jjj     kkk     lll
      │  e  │  ef  │ efg │ fgh │  gh  │  h  │   iii     jjj     kkk     lll
      │  i  │  ij  │ ijk │ jkl │  kl  │  l  │   iii     jjj     kkk     lll
      ├─────•──────┼─────•─────┼──────•─────┤                     
      │  i  │  ij  │ ijk │ jkl │  kl  │  l  │
      └─────•──────┴─────•─────┴──────•─────┘  
    #1#

    float4 p[30];

    for (uint n = 0; n < 15; ++n)
    {
        Load2Pixels(leftMostIndex + cache_offset[n], p[n + (n & 15u)], p[n + (n & 15u) + 1u]);
        // (0, 1) (2, 3) (4, 5) ... (28, 29)
    }
    
    float4 a0[9] = { p[0],  p[1],   p[2],
                    p[6],  p[7],   p[8],
                    p[12], p[13],  p[14] };
    
    float4 b1[9] = { p[1],   p[2],  p[3], 
                    p[7],   p[8],  p[9], 
                    p[13],  p[14], p[15], };
    
    float4 c2[9] = { p[2],  p[3],  p[4], 
                    p[8],  p[9],  p[10],
                    p[14], p[15], p[16] };

    float4 d3[9] = { p[3],  p[4],  p[5], 
                    p[9],  p[10], p[11],
                    p[15], p[16], p[17] };
    
    float4 e4[9] = { p[6],  p[7],   p[8], 
                    p[12], p[13],  p[14],
                    p[18], p[19],  p[20] };
    
    float4 f5[9] = { p[7],   p[8],  p[9], 
                    p[13],  p[14], p[15],
                    p[19],  p[20], p[21] };

    float4 g6[9] = { p[8],  p[9],  p[10],    
                    p[14], p[15], p[16],    
                    p[20], p[21], p[22] }; 

    float4 h7[9] = { p[9],  p[10], p[11],    
                    p[15], p[16], p[17],    
                    p[21], p[22], p[23] };
    
    float4 i8[9] = { p[12], p[13],  p[14],    
                    p[18], p[19],  p[20],    
                    p[24], p[25],  p[26] };
    
    float4 j9[9] = { p[13],  p[14], p[15],    
                    p[19],  p[20], p[21],    
                    p[26],  p[27], p[28] }; 

    float4 k10[9] = { p[14], p[15], p[16],    
                    p[20], p[21], p[22],    
                    p[26], p[27], p[28] }; 

    float4 l11[9] = { p[15], p[16], p[17],    
                    p[21], p[22], p[23],    
                    p[27], p[28], p[29] }; 

    const float4 std0 = std_dev(a0);
    const float4 std1 = std_dev(b1);
    const float4 std2 = std_dev(c2);
    const float4 std3 = std_dev(d3);
    const float4 std4 = std_dev(e4);
    const float4 std5 = std_dev(f5);
    const float4 std6 = std_dev(g6);
    const float4 std7 = std_dev(h7);
    const float4 std8 = std_dev(i8);
    const float4 std9 = std_dev(j9);
    const float4 std10 = std_dev(k10);
    const float4 std11 = std_dev(l11);
    
    float4 pixel1_array[9] = { std0, std1, std2, std4, std5, std6, std8, std9, std10 };
    float4 pixel2_array[9] = { std1, std2, std3, std5, std6, std7, std9, std10, std11 };

    const float4 mean[2] = { Avg9(pixel1_array), Avg9(pixel2_array) };
    
    Store2Pixels(outIndex, mean[0], mean[1]);
}
void Store18StdDev(uint outIndex, uint leftMostIndex)
{
    /*
    ┌────────•─────┬────────•─────┬────────•─────┐
    │ px1[0] │     │ px1[1] │     │ px1[2] │     │
    ├────────•─────┼────────•─────┼────────•─────┤
    │ px1[3] │     │ px1[4] │     │ px1[5] │     │
    ├────────•─────┼────────•─────┼────────•─────┤
    │ px1[6] │     │ px1[7] │     │ px1[8] │     │
    └────────•─────┴────────•─────┴────────•─────┘
    #1#
    float4 px[9];
    Load1Pixel(leftMostIndex, px[0]);
    Load1Pixel(leftMostIndex + 1u, px[1]);
    Load1Pixel(leftMostIndex + 2u, px[2]);

    Load1Pixel(leftMostIndex + 8u, px[3]);
    Load1Pixel(leftMostIndex + 9u, px[4]);
    Load1Pixel(leftMostIndex + 10u, px[5]);

    Load1Pixel(leftMostIndex + 16u, px[6]);
    Load1Pixel(leftMostIndex + 17u, px[7]);
    Load1Pixel(leftMostIndex + 18u, px[8]);
    
    const float4 std1, std2;
    unpacked_std_dev(px, std1, std2);
    
    Store2Pixels(outIndex, std1, std2);
}

// Adapted from CoreRP/ShaderLibrary/Sampling/Hammersley.hlsl
// k_Hammersley2dSeq16
// I plotted the points and subdivided the xy grid into 5 rows and 9 sections.
// Flatten 2D sequence into 1D index offset
// Imagine 8x16 array: top-left is [0], bottom right is [128]
// Array entry value is the index offset relative to a 5x9 section taken from a 8x16 formatted gs_cache[128]
const uint Hammersley_5x9Idx[15] =
{
    4u,
    10u, 11u,
    16u, 20u,
    25u, 26u,
    32u,
    41u, 44u,
    48u, 51u,
    57u, 59u,
    66u
};


// Based on a misunderstanding that I should compare current pixel's mean std-dev
// with the mean std-dev of aleatory selected pixels in THIS THREAD GROUP.
void CalcThreadMeanStdDev(uint cacheIdx, out float4 mean1, out float4 mean2)
{
    float4 std1, std2;
    Load2Pixels(cacheIdx, std1, std2);
    float4 sum1 = std1;
    float4 sum2 = std2;
    // Select 16 pixel values from gs_cache as an approximation of the mean
    UNITY_UNROLLX(15)
    for (uint i = 0; i < 15; ++i)
    {
        const uint index = wrap_range(cacheIdx + Hammersley_5x9Idx[i], 128u); 
        
        // float4 temp1, temp2;
        Load2Pixels(index, std1, std2);
        // sum1 += temp1;
        // sum2 += temp2;
        sum1 += std1;
        sum2 += std2;
    }
    mean1 = sum1 * rcp(15); // 16-1 because this sample is not the entire population
    mean2 = sum2 * rcp(15); // 16-1 because this sample is not the entire population
}*/

/*
NOTES:
Unity's color pyramid (based on MS MiniEngine) took advantage of pixel packing by multiplying packed floats with averaged weight values.
Also consider color pyramid properly handled all 16x16 pixels because it was a reductive process.
So to speak, because it was blurring the pixel data, the loss of data was a desired outcome.
In this case, data loss is not desired.
    
However, I imagine pixel packing is still useful for decreasing the number of operations needed.
For Example:
1) sum = p1 + p2 + p3 + p4;
2) sum = p1_2 + p3_4;
   AddFirst16AndLast16Bits(sum);
At scale this would decrease the number of operations dramatically.
    
const uint topMostIndex = (groupThreadId.y << 3u) + groupThreadId.x;
    
Load2Pixels(topMostIndex, std00, std10);
Load2Pixels(topMostIndex + 8u, std01, std11);

Output std-dev of 3x3 area around Texture2D(Source) pixel to RWTexture2D(Result).
    
Currently this is something like a bilinear average of std-dev. Placeholder only. Not desired or ideal.
Result[id] = (std_p00 + std_p10 + std_p01 + std_p11) * rcp(4);
*/