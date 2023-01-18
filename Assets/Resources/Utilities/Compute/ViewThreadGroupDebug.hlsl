#ifndef VIEW_THREAD_GROUP_DEBUG_INCLUDED
#define VIEW_THREAD_GROUP_DEBUG_INCLUDED

void DrawThreadGroupEdges(RWTexture2D<float4> dest, bool section, float4 color, bool4 row_or_col, uint2 id00)
{
    const uint2 id10 = id00 + uint2(1, 0);
    const uint2 id01 = id00 + uint2(0, 1);
    const uint2 id11 = id00 + uint2(1, 1);

    // row_or_col
    // x = left_col
    // y = right_col
    // z = top_row
    // w = bottom_row
    if (!section) return;
    // if (any(dest[id00]))
    // {
    //     color = 1;
    // }
    if (row_or_col.x)
    {
        dest[id00] = color;
        dest[id01] = color;
    }
    else if (row_or_col.y)
    {
        dest[id00] = color;
        dest[id11] = color;
    }
    else if (row_or_col.z)
    {
        dest[id00] = color;
        dest[id10] = color;
    }
    else if (row_or_col.w)
    {
        dest[id01] = color;
        dest[id11] = color;
    }
}

void DrawThreadGroupBorders(bool show, RWTexture2D<float4> dest, uint2 threadUL, uint2 groupDim, uint2 groupId,
                            uint2 groupThreadId)
{
    if (!show) return;

    // const uint2 id10 = id00 + uint2(1, 0);
    // const uint2 id01 = id00 + uint2(0, 1);
    // const uint2 id11 = id00 + uint2(1, 1); 

    const float4 red = float4(.5, 0, 0, 0);
    const float4 green = float4(0, .5, 0, 0);
    const float4 blue = float4(0, 0, .5, 0);
    const float4 orange = float4(1, 0.5, 0, 0);

    bool left_col = (groupThreadId.x == 0u);
    bool right_col = (groupThreadId.x == (groupDim.x - 1u));
    bool top_row = (groupThreadId.y == 0u);
    bool bottom_row = (groupThreadId.y == groupDim.y - 1u);
    const bool4 edge = bool4(left_col, right_col, top_row, bottom_row);

    const bool NW = all(groupId + 1 & 1u);
    const bool NE = (groupId.x & 1u) == 1u && (groupId.y & 1u) == 0u;
    const bool SW = (groupId.x & 1u) == 0u && (groupId.y & 1u) == 1u;
    const bool SE = all(groupId & 1u);

    DrawThreadGroupEdges(dest, NW, red, edge, threadUL);
    DrawThreadGroupEdges(dest, NE, blue, edge, threadUL);
    DrawThreadGroupEdges(dest, SW, orange, edge, threadUL);
    DrawThreadGroupEdges(dest, SE, green, edge, threadUL);
}

void DrawThreadGradient(bool show, RWTexture2D<float4> dest, uint2 threadUL, uint2 groupSize, uint2 groupId,
                        uint groupIndex)
{
    if (!show) return;

    const uint totalThreads = (groupSize.x * groupSize.y);
    const uint2 id10 = threadUL + uint2(1, 0);
    const uint2 id01 = threadUL + uint2(0, 1);
    const uint2 id11 = threadUL + uint2(1, 1);

    // black = 0
    const float4 red = float4(1, 0, 0, 0);
    const float4 blue = float4(0, 0, 1, 0);
    const float4 green = float4(0.09765625, 0.40625, 0, 0);
    const float4 orange = float4(0.972549, 0.4, 0, 0);

    const float idGrad = float((groupIndex + 1) / totalThreads);
    float4 startColor;
    float4 endColor;
    float4 color;
    float4 gate = 1;

    if (groupId.x & 1u)
    {
        startColor = red;
        endColor = 0;
    }
    else
    {
        startColor = orange;
        endColor = green;
    }

    /*
    if (groupIndex & 8u)
    {
        color = 0.25;
    }
    else
    {
        color = 0.125;
    }
    */
    // startColor *= idGrad;
    // endColor *= idGrad;

    dest[threadUL] = lerp(startColor, endColor, idGrad);
    dest[id10] = lerp(startColor, endColor, idGrad);
    dest[id01] = lerp(startColor, endColor, idGrad);
    dest[id11] = lerp(startColor, endColor, idGrad);

    /*
    if (all(dest[threadUL].rgba < gate))
    {
        dest[threadUL] = color;
        dest[id10] = color;
        dest[id01] = color;
        dest[id11] = color;
    }
*/
}

void DrawThreadGroupArea(bool show, RWTexture2D<float4> dest, uint2 readUL, uint2 writeUL,
                         uint2 gridCenterSize,
                         uint2 groupSize,
                         uint2 groupId,
                         uint2 groupThreadId,
                         uint groupIndex)
{
    if (!show) return;

    const uint totalThreads = (groupSize.x * groupSize.y);

    const uint2 c00 = readUL;
    const uint2 c10 = readUL + uint2(1, 0);
    const uint2 c01 = readUL + uint2(0, 1);
    const uint2 c11 = readUL + uint2(1, 1);

    const uint2 id00 = writeUL;
    const uint2 id10 = writeUL + uint2(1, 0);
    const uint2 id01 = writeUL + uint2(0, 1);
    const uint2 id11 = writeUL + uint2(1, 1);

    const bool threadGroupCenter = all((groupThreadId & gridCenterSize) == 8u); //(groupSize >> 1u));
    // const bool notThreadGroupEdge = all(groupThreadId % (groupSize - 2));

    const bool NW = all(groupId + 1 & 1u);
    const bool NE = (groupId.x & 1u) == 1u && (groupId.y & 1u) == 0u;
    const bool SW = (groupId.x & 1u) == 0u && (groupId.y & 1u) == 1u;
    const bool SE = all(groupId & 1u);

    const float4 red = float4(1., 0.58, 0.58, 0.5);
    const float4 red_dark = float4(0.749, 0.435, 0.435, 0.5);

    const float4 yellow = float4(1., 0.882, 0.58, 0.5);
    const float4 yellow_dark = float4(0.749, 0.663, 0.435, 0.5);

    const float4 green = float4(0.788, 1, 0.58, 0.5);
    const float4 green_dark = float4(0.592, 0.749, 0.435, 0.5);

    const float4 blue = float4(0.58, 0.949, 1, 0.5);
    const float4 blue_dark = float4(0.435, 0.71, 0.749, 0.5);

    const float4 orange = float4(0.972549, 0.4, 0, 0.5);

    const float idGrad = float((groupIndex + 1) / totalThreads);

    float4 edgeColor;
    float4 centerColor;
    float4 color;

    if (NW)
    {
        edgeColor = red;
        centerColor = red_dark;
    }
    if (NE)
    {
        edgeColor = yellow;
        centerColor = yellow_dark;
    }
    if (SW)
    {
        edgeColor = green;
        centerColor = green_dark;
    }
    if (SE)
    {
        edgeColor = blue;
        centerColor = blue_dark;
    }

    // Clamp to small area for testing
    const bool lower_bound = all(groupId >= uint2(41, 41));
    const bool upper_bound = all(groupId <= uint2(64, 66));
    if (!(lower_bound && upper_bound)) return;

    // if (!(NW || NE)) return;
    if (!any(dest[c00]) && !any(dest[c00])) return;
    
    dest[c00] = edgeColor;
    dest[c10] = edgeColor;
    dest[c01] = edgeColor;
    dest[c11] = edgeColor;

    if (threadGroupCenter)
    {
        dest[id00] = centerColor;
        dest[id10] = centerColor;
        dest[id01] = centerColor;
        dest[id11] = centerColor;
    }
}
#endif