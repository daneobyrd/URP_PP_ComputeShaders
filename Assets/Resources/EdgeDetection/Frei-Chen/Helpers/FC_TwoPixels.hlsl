/*
static uint packed_offset[25] =
{
    0,  1,   2,   3,  4,
    8,  9,  10,  11, 12,
    16, 17, 18,  19, 20,
    24, 25, 26,  27, 28,
    32, 33, 34,  35, 36
};

static uint cache_offset[128] =
{
      0,	  1,	  2,	  3,	  4,	  5,	  6,	  7,
      8,	  9,	 10,	 11,	 12,	 13,	 14,	 15,
     16,	 17,	 18,	 19,	 20,	 21,	 22,	 23,
     24,	 25,	 26,	 27,	 28,	 29,	 30,	 31,
     32,	 33,	 34,	 35,	 36,	 37,	 38,	 39,
     40,	 41,	 42,	 43,	 44,	 45,	 46,	 47,
     48,	 49,	 50,	 51,	 52,	 53,	 54,	 55,
     56,	 57,	 58,	 59,	 60,	 61,	 62,	 63,
     64,	 65,	 66,	 67,	 68,	 69,	 70,	 71,
     72,	 73,	 74,	 75,	 76,	 77,	 78,	 79,
     80,	 81,	 82,	 83,	 84,	 85,	 86,	 87,
     88,	 89,	 90,	 91,	 92,	 93,	 94,	 95,
     96,	 97,	 98,	 99,	100,    101,    102,	103,
    104,	105,	106,	107,	108,	109,	110,	111,
    112,	113,	114,	115,	116,	117,	118,	119,
    120,	121,	122,	123,	124,	125,	126,	127,
};

1#
Top-left to bottom-right
┌──── ┌─────┐-----------------------------------------┐------
│ s00 │ s10 │     -     -     -     -     -     -     │     -
├──── ├─────┼─────┐-----------------------------------│------ 
│ s01 │ s11 │ s21 │ s31 -     -     -     -     -     │     - 
└──── ├─────┼─────┼─────┐-----------------------------│------ 
-     │     │ s22 │ s32 │     -     -     -     -     │     - 
------│-----└─────┼─────┤-----------------------------│------ 
-     │     - s23 │ s33 │     -     -     -     -     │     - 
------│-----------└─────┘-----------------------------│------ 
-     │     -     -     -     -     -     -     -     │     - 
------│-----------------------------┌─────┐-----------│------ 
-     │     -     -     -     -     │ s65 │ s75 -     │     - 
------│-----------------------------├─────┼─────┐-----│------ 
-     │     -     -     -     -     │ s66 │ s76 │     │     - 
------│-----------------------------└─────┼─────┼─────┤ ────┐ 
-     │     -     -     -     -     - s67 │ s77 │ s87 │ s97 │
------│-----------------------------------└─────┼─────┤ ────┤
-     │     -     -     -     -     -     -     │ s88 │ s98 │
------└-----------------------------------------└─────┘ ────┘
#1
void fetch_diagonal2(uint leftMostIndex, out float4 diag1, out float4 d_extra1,
                                        out float4 diag2, out float4 d_extra2)
{
    float4
    s00, s10,           
    s01, s11, s21, s31, 
              s22, s32, 
              s23, s33, 

                                  s65, s75,
                                  s66, s76,
                                  s67, s77, s87, s97,
                                            s88, s98;

    Load2Pixels(leftMostIndex, s00, s10);
    Load2Pixels(leftMostIndex + 8u, s01, s11);
    
    Load2Pixels(leftMostIndex + 9u, s21, s31);
    Load2Pixels(leftMostIndex + 17u, s22, s32);
    Load2Pixels(leftMostIndex + 25u, s23, s33);
    
    Load2Pixels(leftMostIndex + 43u, s65, s75);
    Load2Pixels(leftMostIndex + 51u, s66, s76);
    Load2Pixels(leftMostIndex + 59u, s67, s77);
    
    Load2Pixels(leftMostIndex + 60u, s87, s97);
    Load2Pixels(leftMostIndex + 68u, s88, s98);

    // The overlap is the 8x9 region that both 9x9 samples need.
    const float4 diag1_shared = s11 + s22 + s33 + s66 + s77 + s88; // Needs 43
    const float4 diag2_shared = s10 + s21 + s32 + s65 + s76 + s87; // Needs 55
    
    diag1 = diag1_shared + s00;
    diag2 = diag2_shared + s98;
    
    const float4 sharedTriSum = s31 + s23 + s75 + s67;
    
    d_extra1 = diag2_shared + s01 + sharedTriSum;
    d_extra2 = diag1_shared + s97 + sharedTriSum;
}

#1
Top-right to bottom-left
------┌-----------------------------------------┌─────┐ ────┐
-     │     -     -     -     -     -     -     │ s80 │ s90 │
------│-----------------------------------┌─────┼─────┤ ────┘ 
-     │     -     -     -     -     - s61 │ s71 │ s81 │ s92 - 
------│-----------------------------┌─────┼─────┼─────┤------ 
-     │     -     -     -     -     │ s62 │ s72 │     │     - 
------│-----------------------------├─────┼─────┘-----│------ 
-     │     -     -     -     -     │ s63 │ s73 -     │     - 
------│-----------------------------└─────┘-----------│------ 
-     │     -     -     -     -     -     -     -     │     - 
------│-----------┌─────┐-----------------------------│------ 
-     │     - s25 │ s35 │     -     -     -     -     │     - 
------│-----┌─────┼─────┤-----------------------------│------ 
-     │     │ s26 │ s36 │     -     -     -     -     │     - 
------├─────┼─────┼─────┘-----------------------------│------ 
- s07 │ s17 │ s27 │ s37 -     -     -     -     -     │     -
┌──── ├─────┼─────┘-----------------------------------│------
│ s08 │ s18 │     -     -     -     -     -     -     │     -
└──── └─────┘-----------------------------------------┘------
1#
void fetch_anti_diagonal2(uint leftMostIndex, out float4 anti_diag1, out float4 a_extra1,
                                             out float4 anti_diag2, out float4 a_extra2)
{
    float4
                                           s80, s90,
                                 s61, s71, s81, s91,
                                 s62, s72,
                                 s63, s73,
         
              s25, s35,
              s26, s36,
    s07, s17, s27, s37,
    s08, s18;
    
    Load2Pixels(leftMostIndex + 4u, s80, s90);
    Load2Pixels(leftMostIndex + 12u, s81, s91);
    
    Load2Pixels(leftMostIndex + 11u, s61, s71);
    Load2Pixels(leftMostIndex + 19u, s62, s72);
    Load2Pixels(leftMostIndex + 27u, s63, s73);
    
    Load2Pixels(leftMostIndex + 41u, s25, s35);
    Load2Pixels(leftMostIndex + 49u, s26, s36);
    Load2Pixels(leftMostIndex + 57u, s27, s37);
    
    Load2Pixels(leftMostIndex + 56u, s07, s17);
    Load2Pixels(leftMostIndex + 64u, s08, s18);
    
    // The overlap is the 8x9 region that both 9x9 samples need.
    
    // Missing s53
    const float4 anti_diag1_shared = s80 + s71 + s62 + s35 + s26 + s17;
    // Missing s45
    const float4 anti_diag2_shared = s81 + s72 + s63 + s36 + s27 + s18;
    
    anti_diag1 = anti_diag1_shared + s08;
    anti_diag2 = anti_diag2_shared + s90;
    
    const float4 sharedTriSum = s61 + s73 + s25 + s37;
    
    a_extra1 = anti_diag2_shared + s07 + sharedTriSum;
    a_extra2 = anti_diag1_shared + s91 + sharedTriSum;
}

void fetch_center2(uint leftMostIndex, out float4 s43, out float4 s53,
                                      out float4 s44, out float4 s54,
                                      out float4 s45, out float4 s55)
{
    Load2Pixels(leftMostIndex + 26u, s43, s53);
    Load2Pixels(leftMostIndex + 34u, s44, s54);
    Load2Pixels(leftMostIndex + 42u, s45, s55);
}

#1
------┌ - - ┌─────┬─────┬─────┬─────┬─────┬─────┐ - - ┐------
-     │     │ s20 │ s30 │ s40 │ s50 │ s60 │ s70 │     │     -
------│     └─────┴─────┼─────┼─────┼─────┴─────┘     │------
-     │                 │ s41 │ s51 │                 │     - 
┌──── ├─────┐           ├─────┼─────┤           ┌─────┤ ────┐ 
│ s02 │ s12 │           │ s42 │ s52 │           │ s82 │ s92 │ 
├──── ├─────┤           └─────┴─────┘           ├─────┤ ────┤ 
│ s03 │ s13 │                                   │ s83 │ s93 │ 
├──── ├─────┼─────┬─────┐           ┌─────┬─────┼─────┤ ────┤ 
│ s04 │ s14 │ s24 │ s34 │           │ s64 │ s74 │ s84 │ s94 │ 
├──── ├─────┼─────┴─────┘           └─────┴─────┼─────┤ ────┤ 
│ s05 │ s15 │                                   │ s85 │ s95 │ 
├──── ├─────┤           ┌─────┬─────┐           ├─────┤ ────┤ 
│ s06 │ s16 │           │ s46 │ s56 │           │ s86 │ s96 │ 
└──── ├─────┘           ├─────┼─────┤           └─────┤ ────┘ 
-     │                 │ s47 │ s57 │                 │     -
------│     ┌─────┬─────┼─────┼─────┼─────┬─────┐     │------
-     │     │ s28 │ s38 │ s48 │ s58 │ s68 │ s78 │     │     -
------└ - - └─────┴─────┴─────┴─────┴─────┴─────┘ - - ┘------
1#
void fetch_remaining2(uint leftMostIndex, out float4 sum1, out float4 sum2)
{
    uint4 u20_u30, u40_u50, u60_u70,
                   u41_u51,
                   u42_u52,
          u24_u34,          u64_u74,
                   u46_u56,
                   u47_u57,
          u28_u38, u48_u58, u68_u78;
    
    float4 s02, s12,    s82, s92,
           s03, s13,    s83, s93,
           s04, s14,    s84, s94,
           s05, s15,    s85, s95,
           s06, s16,    s86, s96;
    
    Load1Uint(leftMostIndex + 1u,  u20_u30); // 
    Load1Uint(leftMostIndex + 2u,  u40_u50); //            
    Load1Uint(leftMostIndex + 3u,  u60_u70); // s20, s30, s40, s50, s60, s70                    
    Load1Uint(leftMostIndex + 10u, u41_u51); //           s41, s51, 
    Load1Uint(leftMostIndex + 18u, u42_u52); //           s42, s52,

    Load2Pixels(leftMostIndex + 16u, s02, s12); // s02, s12,          
    Load2Pixels(leftMostIndex + 24u, s03, s13); // s03, s13,          
    Load2Pixels(leftMostIndex + 32u, s04,s14);  // s04, s14, s24, s34,
    Load1Uint(leftMostIndex + 33u, u24_u34);             //
    Load2Pixels(leftMostIndex + 40u, s05,s15);  // s05, s15,  	
    Load2Pixels(leftMostIndex + 48u, s06,s16);  // s06, s16,

    Load2Pixels(leftMostIndex + 20u, s82,s92); //           s82, s92
    Load2Pixels(leftMostIndex + 28u, s83,s93); //           s83, s93
    Load2Pixels(leftMostIndex + 36u, s84,s94); // s64, s74, s84, s94
    Load1Uint(leftMostIndex + 35u, u64_u74);            //
    Load2Pixels(leftMostIndex + 44u, s85,s95); // 		  s85, s95,
    Load2Pixels(leftMostIndex + 52u, s86,s96); //           s86, s96

    Load1Uint(leftMostIndex + 50u, u46_u56); //           s46, s56,
    Load1Uint(leftMostIndex + 58u, u47_u57); //           s47, s57,
    Load1Uint(leftMostIndex + 65u, u28_u38); // s28, s38, s48, s58, s68, s78
    Load1Uint(leftMostIndex + 66u, u48_u58); //          
    Load1Uint(leftMostIndex + 67u, u68_u78); //                    

    // By keeping some values as uints, we can eliminate the number of additions.
    // Add uint4s (two packed float4s) and then add first and last 16 bits at the end.
    const uint4 uint_sum =          u20_u30 + u40_u50 + u60_u70
                                            + u41_u51
                                            + u42_u52
                                  + u24_u34           + u64_u74
                                            + u46_u56
                                            + u47_u57
                                  + u28_u38 + u48_u58 + u68_u78;

    const float4 shared_sum = s12                               + s82 
                            + s13                               + s83 
                            + s14                               + s84 
                            + s15                               + s85 
                            + s16                               + s86
                            + AddFirst16AndLast16Bits(uint_sum);

    
    const float4 left = s02 + s03 + s04 + s05 + s06;
    const float4 right = s92 + s93 + s94 + s95 + s96;
    
    sum1 = shared_sum + left;
    sum2 = shared_sum + right;
}

#1
┌──── ┌─────┐ - - - - - - - - - - - - - - - - - ┌─────┐ ────┐
│ s00 │ s10 │                                   │ s80 │ s90 │
└──── ├─────┼─────┐                       ┌─────┼─────┤ ────┘ 
-     │ s11 │ s21 │                       │ s71 │ s81 │     - 
------├─────┼─────┼─────┐           ┌─────┼─────┼─────┤------ 
-     │     │ s22 │ s32 │           │ s62 │ s72 │     │     - 
------│     └─────┼─────┼ ────┬──── ┼─────┼─────┘     │------ 
-     │           │ s33 │ s43 │ s53 │ s63 │           │     - 
- - - │           └─────┼ ────┼──── ┼─────┘           │------ 
-     │                 │ s44 │ s54 │                 │     - 
------│           ┌─────┼ ────┼──── ┼─────┐           │------ 
-     │           │ s35 │ s45 │ s55 │ s65 │           │     - 
------│     ┌─────┼─────┼ ────┴──── ┼─────┼─────┐     │------ 
-     │     │ s26 │ s36 │           │ s66 │ s76 │     │     - 
------├─────┼─────┼─────┘           └─────┼─────┼─────┤------ 
-     │ s17 │ s27 │                       │ s77 │ s87 │     -
┌──── ├─────┼─────┘                       └─────┼─────┤ ────┐
│ s08 │ s18 │                                   │ s88 │ s98 │
└──── └─────┘ - - - - - - - - - - - - - - - - - └─────┘ ────┘
1#
void edge_subspace(uint2 outIndex, uint leftMostIndex)
{
    float4 sum_diag1, sum_diag2;
    float4 sum_anti_diag1, sum_anti_diag2;
    float4 d_extra1, d_extra2;
    float4 a_extra1, a_extra2;


    fetch_diagonal2(leftMostIndex, sum_diag1, d_extra1, sum_diag2, d_extra2);
    fetch_anti_diagonal2(leftMostIndex, sum_anti_diag1, a_extra1, sum_anti_diag2, a_extra2);

    float4 s43, s53,
           s44, s54,
           s45, s55;

    fetch_center2(leftMostIndex, s43, s53,
                                s44, s54,
                                s45, s55 );
    
    const float4 pixel1 = (sum_diag1 + s55) * edge_proj_diag + (sum_anti_diag1 + s53) * edge_proj_anti_diag;
    const float4 pixel2 = (sum_diag2 + s43) * edge_proj_diag + (sum_anti_diag2 + s45) * edge_proj_anti_diag;

    // Store1Pixel(outIndex, pixel1);
    // Store1Pixel(outIndex + 1, pixel2);
}

void line_subspace(uint2 outIndex, uint leftMostIndex)
{
    float4 diag1, diag2,
           anti_diag1, anti_diag2,
           d_extra1, d_extra2,
           a_extra1, a_extra2;

    fetch_diagonal2(leftMostIndex, diag1, d_extra1, diag2, d_extra2);
    fetch_anti_diagonal2(leftMostIndex, anti_diag1, a_extra1, anti_diag2, a_extra2);

    float4 s43, s53,
           s44, s54,
           s45, s55;

    fetch_center2(leftMostIndex, s43, s53,
                                s44, s54,
                                s45, s55 );


    const float4 pixel1 = ((diag1 + s55 + anti_diag1 + s53) * line_proj_diag) + ((d_extra1 + s43 + s44 + s54 + s45 + a_extra1) * line_proj_inv);
    const float4 pixel2 = ((diag2 + s43 + anti_diag2 + s45) * line_proj_diag) + ((d_extra2 + s53 + s44 + s54 + s55 + a_extra2) * line_proj_inv);

    // Store1Pixel(outIndex, pixel1);
    // Store1Pixel(outIndex + 1, pixel2);
}
*/