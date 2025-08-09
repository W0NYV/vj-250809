#version 440

#pragma include "shaders/mainGfx001.glsl"
#pragma include "shaders/mainGfx002.glsl"

out vec4 color;

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float dest1 = 0.0;
    float dest2 = 0.0;
    float dest = 0.0;

    int offset = 16;
    int minIdx = offset;
    for (int i = 0; i < 16; i++)
    {
        if (buttons[i + offset].y < buttons[minIdx].y)
        {
            minIdx = i + offset;
        }
    }
    
    dest1 = minIdx == offset ? m001(p) : dest1;
    dest1 = minIdx == offset + 1 ? m002() : dest1;
    dest1 = minIdx == offset + 2 ? m003(p) : dest1;
    dest1 = minIdx == offset + 3 ? m004(p) : dest1;
    dest1 = minIdx == offset + 4 ? m005(p) : dest1;
    dest1 = minIdx == offset + 5 ? m006() : dest1;
    dest1 = minIdx == offset + 6 ? m007() : dest1;
    dest1 = minIdx == offset + 7 ? m008(p) : dest1;
    dest1 = minIdx == offset + 8 ? m009(p) : dest1;
    dest1 = minIdx == offset + 9 ? m010() : dest1;
    dest1 = minIdx == offset + 10 ? m011() : dest1;
    dest1 = minIdx == offset + 11 ? m012(p) : dest1;
    dest1 = minIdx == offset + 12 ? m013(p) : dest1;
    dest1 = minIdx == offset + 13 ? m014(p) : dest1;
    dest1 = minIdx == offset + 14 ? m015() : dest1;
    dest1 = minIdx == offset + 15 ? m016() : dest1;

    dest2 = minIdx == offset ? m017() : dest2;
    dest2 = minIdx == offset + 1 ? m018(p) : dest2;
    dest2 = minIdx == offset + 2 ? m019(p) : dest2;
    dest2 = minIdx == offset + 3 ? m020() : dest2;
    dest2 = minIdx == offset + 4 ? m021() : dest2;
    dest2 = minIdx == offset + 5 ? m022() : dest2;
    dest2 = minIdx == offset + 6 ? m023() : dest2;
    dest2 = minIdx == offset + 7 ? m024() : dest2;
    dest2 = minIdx == offset + 8 ? m025() : dest2;
    dest2 = minIdx == offset + 9 ? m026(p) : dest2;
    dest2 = minIdx == offset + 10 ? m027() : dest2;
    dest2 = minIdx == offset + 11 ? m028() : dest2;
    dest2 = minIdx == offset + 12 ? m029() : dest2;
    dest2 = minIdx == offset + 13 ? m030() : dest2;
    dest2 = minIdx == offset + 14 ? m031() : dest2;
    dest2 = minIdx == offset + 15 ? m032() : dest2;

    dest = sliders[8].x<1.0 ? dest1 : dest2;
    
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    dest = sliders[7].x<1.0 ? dest : mod(floor(uv.x*7.0)+floor(beat), 2.0) == 0.0 ? dest1 : dest2;

    vec3 col = hsv2rgb(vec3(sliders[6], sliders[5], 1.0)) * dest * sliders[4];
    
    color = vec4(col, 1.0);
}