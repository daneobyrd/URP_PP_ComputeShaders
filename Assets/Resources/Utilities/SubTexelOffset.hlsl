// https://www.reedbeta.com/blog/texture-gathers-and-coordinate-precision/
// https://www.shadertoy.com/view/flyGRd

#if SHADER_API_D3D11 | SHADER_API_METAL 
float gatherOffset =  1/512;
#elif SHADER_API_VULKAN
float gatherOffset =  1/256;
#endif
