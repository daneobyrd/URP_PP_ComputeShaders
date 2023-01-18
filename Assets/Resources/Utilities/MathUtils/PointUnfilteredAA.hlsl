#ifndef POINT_UNFILTERED_AA_INCLUDED
#define POINT_UNFILTERED_AA_INCLUDED

// Anti-Aliasing for point (unfiltered) texture sampling (intended for guilty gear style straight line UV setups)
// using simple UV modifications to trick bilinear filtering into anti-aliasing the color transitions.
void guiltyGear_AA(TEXTURE2D (_InputTex), float2 uv, float4 _InputTex_TexelSize, out float4 color)
{
    float2 texelCenter = (floor(uv * _InputTex_TexelSize.zw) + .5) * _InputTex_TexelSize.xy;
    float2 texelBorder = round(uv * _InputTex_TexelSize.zw) * _InputTex_TexelSize.xy;
    float2 d = min(abs(uv - texelBorder) / fwidth(uv) * 2, 1); //distance, in half pixels, to the boundary 
    float2 samplePoint = lerp(texelBorder, texelCenter, d);
    //Such that when the current pixel is within half a pixel from the boundary we interpolate between a snapped UV coordinate and the blurred boundry coordinate.
    color = SAMPLE_TEXTURE2D(_InputTex, samplePoint);
}

#endif
