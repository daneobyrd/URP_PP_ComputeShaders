// https://iquilezles.org/articles/texture/
// https://www.shadertoy.com/view/XsfGDn

// The MIT License
// Copyright © 2013 Inigo Quilez
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// This is the implementation for my article "improved texture interpolation"
// 
// https://iquilezles.org/articles/texture
//
// It shows how to get some smooth texture interpolation without resorting to the regular
// bicubic filtering, which is pretty expensive because it needs 9 texels instead of the 
// 4 the hardware uses for bilinear interpolation.
//
// With this techinque here, you can get smooth interpolation while still using only
// 1 bilinear fetche, by tricking the hardware. The idea is to get the fractional part
// of the texel coordinates and apply a smooth curve to it such that the derivatives are
// zero at the extremes. The regular cubic or quintic smoothstep functions are just
// perfect for this task.

// include unity references for adapting this from shadertoy
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityInput.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"

struct TextureParameters
{
	uniform float2      iResolution;           // viewport resolution (in pixels)
	// uniform float		iTime;                 // shader playback time (in seconds)
	// uniform float	    iTimeDelta;            // render time (in seconds)
	// uniform float	    iFrameRate;            // shader frame rate
	// uniform int			iFrame;                // shader playback frame
	// uniform float		iChannelTime[4];       // channel playback time (in seconds)
	uniform float3      iChannelResolution[4]; // channel resolution (in pixels)
	// uniform float4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
	// uniform sampler2D   iChannel0;			   // input channel. XX = 2D/Cube
	// uniform float4      iDate;                 // (year, month, day, time in seconds)
	// uniform float		iSampleRate;           // sound sample rate (i.e., 44100)};
};

void iq_TexLoad( out float4 fragColor, in float2 fragCoord, in TEXTURE2D(texture))
{
    float2 p = fragCoord/_ScreenSize.x;
    float2 uv = p * 0.1;	
	
    //---------------------------------------------	
	// regular texture map filtering
    //---------------------------------------------	
	float3 colA = SAMPLE_TEXTURE2D( texture, default_sampler_Linear_Repeat, uv ).xyz;

    //---------------------------------------------	
	// my own filtering 
    //---------------------------------------------
	float textureResolution; // = param.iChannelResolution[0].x;
	texture.GetDimensions(0, textureResolution, 0, 0);
	uv = uv*textureResolution + 0.5;
	float2 iuv = floor( uv );
	float2 fuv = frac( uv );
	uv = iuv + fuv*fuv*(3.0-2.0*fuv); // fuv*fuv*fuv*(fuv*(fuv*6.0-15.0)+10.0);;
	uv = (uv - 0.5)/textureResolution;
	float3 colB = SAMPLE_TEXTURE2D( texture, default_sampler_Linear_Repeat, uv ).xyz;
	
    //---------------------------------------------	
    // final color
    //---------------------------------------------	
	float f = sin(PI * p.x + 0.7 * _TimeParameters.x);
	float3 col = (f>=0.0) ? colA : colB;
	col *= smoothstep( 0.0, 0.01, abs(f-0.0) );
	
    fragColor = float4( col, 1.0 );
}