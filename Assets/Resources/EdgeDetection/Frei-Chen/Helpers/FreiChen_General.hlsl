#ifndef FREI_CHEN_GENERAL_INCLUDED
#define FREI_CHEN_GENERAL_INCLUDED

// Generalization of Frei and Chen’s approach to extract the lines and edges of a digital image
// F. Moreno, S. Moreno, E. Cortes
// Published 10 February 2006

/*
2.1 Projection matrixes for 3×3 masks
Following with the proposal of Frei and Chen, we consider
edge, line and measurement subspaces formed by the vectors
of 2. To calculate the projection matrix onto the edge
subspace we use matrix B, whose columns are the vectors
given in masks g0, g1, g2 and g3, regardless of the layout
order The projection matrix onto the mentioned subspace is
obtained from the matrix product:

p_b = B(B^T * B)^−1 * B^T,

that is,
*/

/*
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ 0.5 │  0  │  0  │  0  │  0  │  0  │  0  │  0  │ -.5 │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │ 0.5 │  0  │  0  │  0  │  0  │  0  │ -.5 │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │  0  │ 0.5 │  0  │  0  │  0  │ -.5 │  0  │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │  0  │  0  │ 0.5 │  0  │ -.5 │  0  │  0  │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │  0  │  0  │  0  │  0  │  0  │  0  │  0  │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │  0  │  0  │ -.5 │  0  │ 0.5 │  0  │  0  │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │  0  │ -.5 │  0  │  0  │  0  │ 0.5 │  0  │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│  0  │ -.5 │  0  │  0  │  0  │  0  │  0  │ 0.5 │  0  │ 
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ -.5 │  0  │  0  │  0  │  0  │  0  │  0  │  0  │ 0.5 │ 
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
*/

// Projection matrix onto the Edge subspace

const float edge_diag_coeff = 0.5;
const float edge_anti_diag_coeff = -0.5;
// const float edge_inv = 0;

/*
Using the same reasoning for the line subspace, the
matrix whose columns are the vectors given by masks
g4, g5, g6 and g7, is called L. We obtain the projection matrix
onto the line subspace
*/

/*
┌──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┬──────┐
│ 7/18 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ -1/9 │ 7/18 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │ -1/9 │
├──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┼──────┤
│ 7/18 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ -1/9 │ 7/18 │
└──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┴──────┘
*/

// Projection matrix onto the line subspace.

// 7/18
const float line_x_coeff = 0.3888888;
// -1/9
const float line_inv_coeff = -0.1111111;
// 1/9
const float measurement_coeff = 0.1111111;

float cnv_shared_value(float x, float row[9])
{
    return x * (row[0] + row[1] + row[2] + row[3] + row[4] + row[5] + row[6] + row[7] + row[8]);
}
float cnv_shared_value(float x, float a, float b, float c, float d, float e, float f, float g, float h, float i)
{
    return x * (a + b + c + d + e + f + g + h + i);
}

/* Original Algorithm overview

       ┌────────────────────┐
       │ Input Texture(i,j) │
       └────────────────────┘
                 ↓
┌────────────────────────────────────────────────────┐
│ Calculate the mean of standard deviation for the   │
│ aleatory elected pixels from entire texture : I_MS │
└────────────────────────────────────────────────────┘        ┌──────────────┐      
                 ↓                                            │ Go to next   │               
       ┌────────────────────┐ ←────────────────────────────── │ pixel (i, j) │ ←──────────────── No ──┐        
       │  is mean std-dev   │                                 └──────────────┘                        │
       │ pixel(i,j) > I_MS? │ ─── No ───→ ┌────────────────────────────────────────┐                  │                                                              
       └────────────────────┘             │ Project pixel to measurement subspace: │     ┌──────────────────┐
                 ↓                        │ is part of uniform luminance region    │ ──→ │  is last pixel?  │
┌──────────────────────────────────┐      └────────────────────────────────────────┘     └──────────────────┘
│ calculate square norms of        │                                                       ↑           │                              
│ edge and line projection vectors │                                                       │           │
└──────────────────────────────────┘              ┌────────────────────────────────┐       │          Yes    
                 ↓                                │ Project pixel to edge subspace │ ──────┤           │            
┌──────────────────────────────────┐ ─── Yes ───→ └────────────────────────────────┘       │           │            
│   is ||edge||^2 > ||line||^2?    │              ┌────────────────────────────────┐       │           │
└──────────────────────────────────┘ ─── No ────→ │ Project pixel to line subspace │ ──────┘           │                  
                                                  └────────────────────────────────┘                   ↓
                                                                                          ┌──────────────────────────┐      
                                                                                          │ Transformed Texture(i,j) │            
                                                                                          └──────────────────────────┘     
*/
#endif
