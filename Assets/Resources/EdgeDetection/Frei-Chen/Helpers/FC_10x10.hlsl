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

/*

Top-left to bottom-right
┌──── ┌─────┐------------------------------------------------
│ s00 │ s10 │     -     -     -     -     -     -     -     -
┌──── ┌─────┐ ────┐ ──────────────────────────────────┐------ 
│ s01 │ s11 │ s21 │ s31 -     -     -     -     -     │     - 
└──── └─────┼─────┐ ────┐-----------------------------│------ 
- s02 │ s12 │ s22 │ s32 │     -     -     -     -     │     - 
------└──── └─────┼─────┐ ────┐-----------------------│------ 
-     │     │ s23 │ s33 │ s43 │ s53 -     -     -     │     - 
------│-----└──── └─────┘••••••••••••-----------------│------ 
-     │     - s24 │ s34 • s44 • s54 •     -     -     │     - 
------│-----------└──── ••••••••••••• ────┐-----------│------ 
-     │     -     -     • s45 • s55 • s65 │ s75 -     │     - 
------│-----------------••••••••••••┌─────┐ ────┐-----│------ 
-     │     -     -     - s46 │ s56 │ s66 │ s76 │     │     - 
------│-----------------------└──── └─────┼─────┐ ────┐------ 
-     │     -     -     -     -     │ s67 │ s77 │ s87 │ s97 -
------│-----------------------------└──── └─────┼─────┐ ────┐
-     │     -     -     -     -     - s68 │ s78 │ s88 │ s98 │
------└────────────────────────────────── └──── └─────┘ ────┘
-     -     -     -     -     -     -     -     │ s89 │ s99 │
------------------------------------------------└─────┘ ────┘

void get_diagonal(uint topLeftMostIndex, out float diag00, out float diag_ex00,
                                         out float diag10, out float diag_ex10,
                                         out float diag01, out float diag_ex01,
                                         out float diag11, out float diag_ex11)
{
    
    float
    o00, o10,           
    o01, i11, i21, i31, 
    o02, i12, i22, i32, 
              i23, i33, i43, i53,
              i24, i34, i44, i54,
                        i45, i55, i65, i75,
                        i46, i56, i66, i76,
                                  i67, i77, i87, o97,
                                  i68, i78, i88, o98,
                                            o89, o99;
    // i53 and i46 are included in get_anti_diagonal
    
    Load2Pixels(topLeftMostIndex, o00, o10);
    Load2Pixels(topLeftMostIndex + 8u, o01, i11);
    
    Load2Pixels(topLeftMostIndex + 9u, i21, i31);
    
    Load2Pixels(topLeftMostIndex + 16u, o02, i12);
    Load2Pixels(topLeftMostIndex + 17u, i22, i32);
    
    Load2Pixels(topLeftMostIndex + 25u, i23, i33);
    Load2Pixels(topLeftMostIndex + 26u, i43, i53);

    Load2Pixels(topLeftMostIndex + 33u, i24, i34);
    Load2Pixels(topLeftMostIndex + 34u, i44, i54);
    
    Load2Pixels(topLeftMostIndex + 42u, i45, i55);
    Load2Pixels(topLeftMostIndex + 43u, i65, i75);

    Load2Pixels(topLeftMostIndex + 50u, i46, i56);
    Load2Pixels(topLeftMostIndex + 51u, i66, i76);
    
    Load2Pixels(topLeftMostIndex + 59u, i67, i77);
    Load2Pixels(topLeftMostIndex + 60u, i87, o97);

    Load2Pixels(topLeftMostIndex + 67u, i68, i78);
    Load2Pixels(topLeftMostIndex + 68u, i88, o98);

    Load2Pixels(topLeftMostIndex + 76u, o89, o99);

    /*
        A• B• ──────────────────────┐
        •C AD B• ────────────────┐  │
        │  •C AD B•              │  │
        │  │  •C AD B•           │  │
        │  │     •C aD b•        │  │
        │  │        c• Ad B•     │  │
        │  │           •C AD B•  │  │
        │  │              •C AD B•  │
        │  └──────────────── •C AD B•
        └────────────────────── •C •D
    
    const float diag_AD_center =i11 + i22 + i33 + i66 + i77 + i88; // diag00 needs 00, 55. diag11 needs 44, 99
    const float diag_B_center = i43 + i21 + i32 + i65 + i76 + i87; // Needs 10, 98
    const float diag_C_center = i12 + i23 + i34 + i67 + i78 + i56; // Needs 01, 89
    
    diag00 = o00 + diag_AD_center + i55;
    diag10 = o10 + diag_B_center + o98;
    diag01 = o01 + diag_C_center + o89;
    diag11 = diag_AD_center + i44 + o99;
    
    const float shared_extra = i31 + i24 + i75 + i68;
    
    diag_ex00 = o10 + o01 + o02 + diag_B_center + diag_C_center + shared_extra + i44 + i54 + i45;
    diag_ex10 = diag_AD_center + diag_C_center + o97 + shared_extra + i44 + i54 + i55;
    diag_ex01 = o02 + diag_AD_center + diag_B_center + shared_extra + i44 + i45 + i55;
    diag_ex11 = diag_B_center + diag_C_center + shared_extra + o97 + o98 + o89 + i45 + i54 + i55;
}


Top-right to bottom-left
------------------------------------------------┌─────┐ ────┐
-     -     -     -     -     -     -     -     │ s80 │ s90 │
------┌────────────────────────────────── ┌──── ┌─────┐ ────┘
-     │     -     -     -     -     - s61 │ s71 │ s81 │ s91 │
------│-----------------------------┌──── ┌─────┼─────┘ ────┘
-     │     -     -     -     -     │ s62 │ s72 │ s82 │ s92 -
------│-----------------------┌──── ┌─────┼─────┘ ────┘------
-     │     -     -     - s43 │ s53 │ s63 │ s73 │     │     -
------│-----------------••••••└──── └─────┘ ────┘-----│------
-     │     -     -     • s44 • s54 │ s64 │ s74 -     │     -
------│-----------┌─────┐••• ─┼─ •••└─────┘-----------│------
-     │     - s25 │ s35 │ s45 • s55 •     -     -     │     -
------│-----┌──── ┌─────┐ ────┐••••••-----------------│------
-     │     │ s26 │ s36 │ s46 │ s56 -     -     -     │     -
------┌──── ┌─────┼─────┘ ────┘-----------------------│------ 
- s07 │ s17 │ s27 │ s37 │     -     -     -     -     │     -
┌──── ┌─────┼─────┘ ────┘-----------------------------│------
│ s08 │ s18 │ s28 │ s38 -     -     -     -     -     │     -
└──── └─────┘ ────┘ ──────────────────────────────────┘------
│ s09 │ s19 │     -     -     -     -     -     -     -     -
└──── └─────┘------------------------------------------------

void get_anti_diagonal(uint topLeftMostIndex, out float anti_diag00, out float a_extra00,
                                           out float anti_diag10, out float a_extra10,
                                           out float anti_diag01, out float a_extra01,
                                           out float anti_diag11, out float a_extra11)
{
    float
                                            o80, o90,
                                  i61, i71, i81, o91,
                                  i62, i72, i82, o92,
                        i43, i53, i63, i73,
                        i44, i54, i64, i74,
              i25, i35, i45, i55,
              i26, i36, i46, i56,
    o07, i17, i27, i37,
    o08, i18, i28, i38,
    o09, o19;
    // i43, i44, i55, i56 are included in get_diagonal
    
    Load2Pixels(topLeftMostIndex + 4u,  o80, o90);
    Load2Pixels(topLeftMostIndex + 11u, i61, i71);
    Load2Pixels(topLeftMostIndex + 12u, i81, o91);
    
    Load2Pixels(topLeftMostIndex + 19u, i62, i72);
    Load2Pixels(topLeftMostIndex + 20u, i82, o92);
    
    Load2Pixels(topLeftMostIndex + 26u, i43, i53);
    Load2Pixels(topLeftMostIndex + 27u, i63, i73);
    
    Load2Pixels(topLeftMostIndex + 34u, i44, i54);
    Load2Pixels(topLeftMostIndex + 35u, i64, i74);
    
    Load2Pixels(topLeftMostIndex + 41u, i25, i35);
    Load2Pixels(topLeftMostIndex + 42u, i45, i55);
    
    Load2Pixels(topLeftMostIndex + 49u, i26, i36);
    Load2Pixels(topLeftMostIndex + 50u, i46, i56);
    Load2Pixels(topLeftMostIndex + 57u, i27, i37);
    
    Load2Pixels(topLeftMostIndex + 56u, o07, i17);
    Load2Pixels(topLeftMostIndex + 64u, o08, i18);
    Load2Pixels(topLeftMostIndex + 65u, i28, i38);
    
    Load2Pixels(topLeftMostIndex + 72u, o09, o19);
    
    /*
    ┌────────────────────── A• B•
    │                    A• BC •D
    │                 A• BC •D  │
    │              A• BC •D     │
    │           a• bC •D        │
    │        A• Bc •d           │
    │     A• BC •D              │
    │  A• BC •D                 │
    A• BC •D                    │
    •C •D ──────────────────────┘
    
    const float anti_diag_A_shared = i71 + i62 + i53 + i35 + i26 + i17;
    const float anti_diag_BC_shared = i81 + i72 + i63 + i36 + i27 + i18;
    const float anti_diag_D_shared = i82 + i73 + i64 + i46 + i37 + i28;
    
    anti_diag00 = o80 + anti_diag_A_shared + o08;
    anti_diag10 = o90 + anti_diag_BC_shared + i45;
    anti_diag01 = anti_diag_BC_shared + i54 + o09;
    anti_diag11 = o91 + anti_diag_D_shared + o19;
    
    const float shared_extra = i61 + i74 + i25 + i38;
    
    a_extra00 = anti_diag_BC_shared + o07 + shared_extra;
    a_extra10 = anti_diag_A_shared + o91 + shared_extra;
    a_extra01 = o08 + anti_diag_A_shared + anti_diag_D_shared + shared_extra;
    a_extra11 = anti_diag_A_shared + anti_diag_BC_shared + o92 + shared_extra;
}

/*
----------- ┌─────┬─────┬─────┬─────┬─────┬─────┐ -----------
-     -     │ s20 │ s30 │ s40 │ s50 │ s60 │ s70 │     -     -
------┌──── └─────┴─────┼─────┼─────┼─────┴─────┘ ────┐------
-     │                 │ s41 │ s51 │                 │     -
------│                 ├─────┼─────┤                 │------
-     │                 │ s42 │ s52 │                 │     -
┌──── ├─────┐           └─────┴─────┘           ┌─────┤ ────┐
│ s03 │ s13 │                                   │ s83 │ s93 │
├──── ├─────┤                                   ├─────┤ ────┤
│ s04 │ s14 │                                   │ s84 │ s94 │
├──── ├─────┤                                   ├─────┤ ────┤
│ s05 │ s15 │                                   │ s85 │ s95 │
├──── ├─────┤                                   ├─────┤ ────┤
│ s06 │ s16 │                                   │ s86 │ s96 │
└──── ├─────┘           ┌─────┬─────┐           └─────┤ ────┘
-     │                 │ s47 │ s57 │                 │     -
------│                 ├─────┼─────┤                 │------
-     │                 │ s48 │ s58 │                 │     -
------└──── ┌─────┬─────┼─────┼─────┼─────┬─────┐ ────┘------
-     -     │ s29 │ s39 │ s49 │ s59 │ s69 │ s79 │     -     -
----------- └─────┴─────┴─────┴─────┴─────┴─────┘ -----------

void get_remaining(uint topLeftMostIndex,
                    out float sum00,
                    out float sum10,
                    out float sum01,
                    out float sum11)
{
    uint
    u20_u30, u40_u50, u60_u70,
             u41_u51,
             u42_u52,

             u47_u57,
             u48_u58,
    u29_u39, u49_u59, u69_u79;
    
    float
    s03, s13,    s83, s93,
    s04, s14,    s84, s94,
    s05, s15,    s85, s95,
    s06, s16,    s86, s96;
    
    Load1Uint(topLeftMostIndex + 1u,  u20_u30); // 
    Load1Uint(topLeftMostIndex + 2u,  u40_u50); //            
    Load1Uint(topLeftMostIndex + 3u,  u60_u70); // s20, s30, s40, s50, s60, s70                    
    Load1Uint(topLeftMostIndex + 10u, u41_u51); //           s41, s51, 
    Load1Uint(topLeftMostIndex + 18u, u42_u52); //           s42, s52,
    
    Load2Pixels(topLeftMostIndex + 24u, s03, s13); // s03, s13,          
    Load2Pixels(topLeftMostIndex + 32u, s04, s14);  // s04, s14,
    Load2Pixels(topLeftMostIndex + 40u, s05, s15);  // s05, s15,  	
    Load2Pixels(topLeftMostIndex + 48u, s06, s16);  // s06, s16,
    
    Load2Pixels(topLeftMostIndex + 28u, s83, s93); // s83, s93
    Load2Pixels(topLeftMostIndex + 36u, s84, s94); // s84, s94
    Load2Pixels(topLeftMostIndex + 44u, s85, s95); // 		  s85, s95,
    Load2Pixels(topLeftMostIndex + 52u, s86, s96); //        s86, s96
    
    Load1Uint(topLeftMostIndex + 58u, u47_u57); //           s47, s57,
    Load1Uint(topLeftMostIndex + 66u, u48_u58); //           s48, s58,
    Load1Uint(topLeftMostIndex + 73u, u29_u39); // s29, s39, s49, s59, s69, s79
    Load1Uint(topLeftMostIndex + 74u, u49_u59); 
    Load1Uint(topLeftMostIndex + 75u, u69_u79); 
    
    // By keeping some values as uints, we can eliminate the number of additions.
    // Add uint4s (two packed floats) and then add first and last 16 bits at the end.
    const uint uint_sum =
                  u41_u51
                + u42_u52
    
                + u47_u57
                + u48_u58;
    
    float uint_sum_f;
    AddFirst16AndLast16Bits(uint_sum, uint_sum_f);
    
    const float shared_sum =
    s13 +                             s83 + 
    s14 +                             s84 + 
    s15 +                             s85 + 
    s16 +                             s86 + uint_sum_f;

    const uint up_uint = u20_u30 + u40_u50 + u60_u70;
    float up;
    AddFirst16AndLast16Bits(up_uint, up);
    const uint down_uint = u29_u39 + u49_u59 + u69_u79;
    float down;
    AddFirst16AndLast16Bits(down_uint, down);

    const float left = s03 + s04 + s05 + s06;
    const float right = s93 + s94 + s95 + s96;
    
    sum00 = shared_sum + up + left;
    sum10 = shared_sum + up + right;
    sum01 = shared_sum + down + left;
    sum11 = shared_sum + down + right;
}
*/

/*
/*
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
#1#
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
