/*
// Convolve by row for 9x9 with symmetrical x-shaped filter.
// Center pixel is inv_x.

/*
┌───┬───┬───┬───┬───┬───┬───┬───┬───┐
│[a]│ b │ c │ d │ e │ f │ g │ h │[i]│
return
    x * (a + i)
    + inv_x * (b + c + d + e + f + g + h);
#1#
float4 row0(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return
        x * (a + i)
        + inv_x * (b + c + d + e + f + g + h);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │[b]│ c │ d │ e │ f │ g │[h]│ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (b + h)
    + inv_x * (a + c + d + e + f + g + i);
#1#
float4 row1(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)

{
    return
        x * (b + h)
        + inv_x * (a + c + d + e + f + g + i);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │[c]│ d │ e │ f │[g]│ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (c + g)
    + inv_x * (a + b + d + e + f + h + i);
#1#
float4 row2(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return
        x * (c + g)
        + inv_x * (a + b + d + e + f + h + i);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │ c │[d]│ e │[f]│ g │ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (d + f)
    + inv_x * (a + b + c + e + g + h + i);
#1#
float4 row3(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return
        x * (d + f)
        + inv_x * (a + b + c + e + g + h + i);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│[a]│[b]│[c]│[d]│[e]│[f]│[g]│[h]│[i]│
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (a + b + c + d + e + f + g + h + i);
#1#
float4 row4(float mask, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{ return cnv_shared_value(mask, a, b, c, d, e, f, g, h, i); }

// All following rows are symmetrical to rows 3 - 0.

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │ c │[d]│ e │[f]│ g │ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (d + f)
    + inv_x * (a + b + c + e + g + h + i);
#1#
float4 row5(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return row3(x, inv_x, a, b, c, d, e, f, g, h, i);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │[c]│ d │ e │ f │[g]│ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (c + g)
    + inv_x * (a + b + d + e + f + h + i);
#1#
float4 row6(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return row2(x, inv_x, a, b, c, d, e, f, g, h, i);
}

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │[b]│ c │ d │ e │ f │ g │[h]│ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (b + h)
    + inv_x * (a + c + d + e + f + g + i);
#1#
float4 row7(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return row1(x, inv_x, a, b, c, d, e, f, g, h, i);
}

/*
│[a]│ b │ c │ d │ e │ f │ g │ h │[i]│
└───┴───┴───┴───┴───┴───┴───┴───┴───┘
return
    x * (a + i)
    + inv_x * (b + c + d + e + f + g + h);
#1#
float4 row8(float x, float inv_x, float4 a, float4 b, float4 c, float4 d, float4 e, float4 f, float4 g, float4 h, float4 i)
{
    return row0(x, inv_x, a, b, c, d, e, f, g, h, i);
}

// Versions with neg_x for values along anti-diagonal.

/*
┌───┬───┬───┬───┬───┬───┬───┬───┬───┐
│[a]│ b │ c │ d │ e │ f │ g │ h │{i}│
return
    x * a
    + (-x * i)
    + inv_x * (b + c + d + e + f + g + h);
#1#
float4 edge_row0(float4 a, float4 i) { return 0.5 * a + (-0.5 * i); }

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │[b]│ c │ d │ e │ f │ g │[h]│ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (b + h)
    + inv_x * (a + c + d + e + f + g + i);
#1#
float4 edge_row1(float4 b, float4 h) { return 0.5 * b + (-0.5 * h); }

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │[c]│ d │ e │ f │[g]│ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (c + g)
    + inv_x * (a + b + d + e + f + h + i);
#1#
float4 edge_row2(float4 c, float4 g) { return 0.5 * c + (-0.5 * g); }

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │ c │[d]│ e │[f]│ g │ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (d + f)
    + inv_x * (a + b + c + e + g + h + i);
#1#
float4 edge_row3(float4 d, float4 f) { return 0.5 * d + (-0.5 * f); }

// Row 4 is all zero

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │ c │[d]│ e │[f]│ g │ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (d + f)
    + inv_x * (a + b + c + e + g + h + i);
#1#
float4 edge_row5(float4 d, float4 f) { return edge_row3(d, f); }

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │ b │[c]│ d │ e │ f │[g]│ h │ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (c + g)
    + inv_x * (a + b + d + e + f + h + i);
#1#
float4 edge_row6(float4 c, float4 g) { return edge_row2(c, g); }

/*
├───┼───┼───┼───┼───┼───┼───┼───┼───┤
│ a │[b]│ c │ d │ e │ f │ g │[h]│ i │
├───┼───┼───┼───┼───┼───┼───┼───┼───┤

return
    x * (b + h)
    + inv_x * (a + c + d + e + f + g + i);
#1#
float4 edge_row7(float4 b, float4 h) { return edge_row1(b, h); }

/*
│[a]│ b │ c │ d │ e │ f │ g │ h │{i}│
└───┴───┴───┴───┴───┴───┴───┴───┴───┘

return
    x * a
    + (-x * i)
    + inv_x * (b + c + d + e + f + g + h);
#1#
float4 edge_row8(float4 a, float4 i) { return edge_row0(a, i); }



*//*1##1#11##131##11##void Store2Pixels(uint index, float4 pixel1, float4 pixel2)
{
    gs_cacheR[index] = f32tof16(pixel1.r) | f32tof16(pixel2.r) << 16;
    gs_cacheG[index] = f32tof16(pixel1.g) | f32tof16(pixel2.g) << 16;
    gs_cacheB[index] = f32tof16(pixel1.b) | f32tof16(pixel2.b) << 16;
    gs_cacheA[index] = f32tof16(pixel1.a) | f32tof16(pixel2.a) << 16;
}

// Load pixels from gs_cache 
void Load2Pixels(uint index, out float4 pixel1, out float4 pixel2)
{
    uint rr = gs_cacheR[index];
    uint gg = gs_cacheG[index];
    uint bb = gs_cacheB[index];
    uint aa = gs_cacheA[index];
    pixel1 = float4(f16tof32(rr), f16tof32(gg), f16tof32(bb), f16tof32(aa));
    pixel2 = float4(f16tof32(rr >> 16), f16tof32(gg >> 16), f16tof32(bb >> 16), f16tof32(aa >> 16));
}

// Store pixels in gs_cache
void Store1Pixel(uint index, float4 pixel)
{
    gs_cacheR[index] = asuint(pixel.r);
    gs_cacheG[index] = asuint(pixel.g);
    gs_cacheB[index] = asuint(pixel.b);
    gs_cacheA[index] = asuint(pixel.a);
}

void Load1Pixel(uint index, out float4 pixel)
{
    pixel = asfloat(uint4(gs_cacheR[index], gs_cacheG[index], gs_cacheB[index], gs_cacheA[index]));
}

// Row by Row

void CacheEdgeRow0(uint outIndex, uint leftMostIndex)
{
    float4 s00, s10, /*s20, s30, s40, s50, s60, s70,#1# s80, s90;
    Load2Pixels(leftMostIndex + 0, s00, s10);
    /*
    Load2Pixels(leftMostIndex + 1, s20, s30);
    Load2Pixels(leftMostIndex + 2, s40, s50);
    Load2Pixels(leftMostIndex + 3, s60, s70);
    #1#
    Load2Pixels(leftMostIndex + 4, s80, s90);

    Store1Pixel(outIndex, edge_row0(s00, s80));
    // No further operations because triangular area is multiplied by 0

    Store1Pixel(outIndex + 1, edge_row0(s10, s90));
}

void CacheEdgeRow1(uint outIndex, uint leftMostIndex)
{
    float4 s01, s11, s21, s31, s41, s51, s61, s71, s81, s91;
    Load2Pixels(leftMostIndex + 0, s01, s11);
    Load2Pixels(leftMostIndex + 1, s21, s31);
    Load2Pixels(leftMostIndex + 2, s41, s51);
    Load2Pixels(leftMostIndex + 3, s61, s71);
    Load2Pixels(leftMostIndex + 4, s81, s91);

    Add1Pixel(outIndex, edge_row1(s11, s71)); //c00, c10
    Add1Pixel(outIndex + 1, edge_row1(s21, s81)); //c01, c11
}

void Edge_2(uint outIndex, uint leftMostIndex)
{
    float4 /*s02, s12,#1# s22, s32, /*s42, s52,#1# s62, s72; //s82, s92;

    // Load2Pixels(leftMostIndex + 0, s02, s12);
    Load2Pixels(leftMostIndex + 1, s22, s32);
    // Load2Pixels(leftMostIndex + 2, s42, s52);
    Load2Pixels(leftMostIndex + 3, s62, s72);
    // Load2Pixels(leftMostIndex + 4, s82, s92);

    Store1Pixel(outIndex, edge_row2(s22, s62)); //c00 or c10
    Store1Pixel(outIndex + 1, edge_row2(s32, s72)); //c01 or c11
}

void Edge_3(uint outIndex, uint leftMostIndex)
{
    float4 s33, s43, s53, s63;
    Load2Pixels(leftMostIndex + 1, s33, s43);
    Load2Pixels(leftMostIndex + 2, s53, s63);

    Store1Pixel(outIndex, edge_row3(s33, s53));
    Store1Pixel(outIndex + 1, edge_row3(s43, s63));
}

// Edge row 4 filter is all (0)
*/
