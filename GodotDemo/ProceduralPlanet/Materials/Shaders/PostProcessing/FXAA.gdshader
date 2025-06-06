shader_type canvas_item;

// Godot Nvidia FXAA 3.11 Port

// Usage: Drop this in to any 3D scene for FXAA! This is a port of the "PC High Quality Preset 39". However the medium quality
// parameters are also included. For medium quality, just comment out sections "PS 6" and above and uncomment the "med 13" variables.

// Motivation: As of this port, Godot's OpenGL ES 2.0 renderer does not natively support any form of anti aliasing.
// I want to port my game High Hat from ES 3.0 to 2.0 to support a wider range of hardware, but without AA, my game looks terrible!

// Note: By all rights the "lumaScale" uniform value should be one. I only got good results when I cranked it up to ~6
// If someone could tell me why this is needed that would be great!

// This software contains source code provided by NVIDIA Corporation.
// This is a derivative of NVIDIA FXAA 3.11 by TIMOTHY LOTTES
// Original source: https://github.com/NVIDIAGameWorks/GraphicsSamples/blob/80e8ba8f5e8935821513207033490735dd3279d8/samples/es3-kepler/FXAA/FXAA3_11.h
// Modifed by Carter Anderson (https://twitter.com/cart_cart) for use in Godot Engine
// Nvidia grants usage of the original FXAA code under the following license: https://github.com/NVIDIAGameWorks/GraphicsSamples/blob/master/license.txt
// As the author of the derivative (Carter Anderson), I grant you (the user) full rights to my changes.
// However if you use this, I am not liable for anything (positive or negative) that results from the use of this code.
// But I shouldn't need to say this. I'm sure you're a cool person :)

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float qualitySubpix = 1.0;
uniform float qualityEdgeThreshold = 0.0;
uniform float qualityEdgeThresholdMin = 0.0;
uniform float lumaScale = 1.0;

vec4 FxaaTexOff(sampler2D t, vec2 p, vec2 o, vec2 r)  { return textureLod(t, p + (o * r), 0.0); }
float FxaaLuma(vec4 rgba) { return lumaScale * dot(rgba.rgb, vec3(0.299, 0.587, 0.114)); }
float FxaaSat(float x) { return clamp(x, 0.0, 1.0); }

vec4 FxaaPixelShader(
    //
    // Use noperspective interpolation here (turn off perspective interpolation).
    // {xy} = center of pixel
    vec2 pos,
    //
    // Input color texture.
    // {rgb_} = color in linear or perceptual color space
    // if (FXAA_GREEN_AS_LUMA == 0)
    //     {___a} = luma in perceptual color space (not linear)
    sampler2D tex,
    //
    // Only used on FXAA Quality.
    // This must be from a constant/uniform.
    // {x_} = 1.0/screenWidthInPixels
    // {_y} = 1.0/screenHeightInPixels
    vec2 fxaaQualityRcpFrame,
    //
    // Only used on FXAA Quality.
    // This used to be the FXAA_QUALITY__SUBPIX define.
    // It is here now to allow easier tuning.
    // Choose the amount of sub-pixel aliasing removal.
    // This can effect sharpness.
    //   1.00 - upper limit (softer)
    //   0.75 - default amount of filtering
    //   0.50 - lower limit (sharper, less sub-pixel aliasing removal)
    //   0.25 - almost off
    //   0.00 - completely off
    float fxaaQualitySubpix,
    //
    // Only used on FXAA Quality.
    // This used to be the FXAA_QUALITY__EDGE_THRESHOLD define.
    // It is here now to allow easier tuning.
    // The minimum amount of local contrast required to apply algorithm.
    //   0.333 - too little (faster)
    //   0.250 - low quality
    //   0.166 - default
    //   0.125 - high quality
    //   0.063 - overkill (slower)
    float fxaaQualityEdgeThreshold,
    //
    // Only used on FXAA Quality.
    // This used to be the FXAA_QUALITY__EDGE_THRESHOLD_MIN define.
    // It is here now to allow easier tuning.
    // Trims the algorithm from processing darks.
    //   0.0833 - upper limit (default, the start of visible unfiltered edges)
    //   0.0625 - high quality (faster)
    //   0.0312 - visible limit (slower)
    // Special notes when using FXAA_GREEN_AS_LUMA,
    //   Likely want to set this to zero.
    //   As colors that are mostly not-green
    //   will appear very dark in the green channel!
    //   Tune by looking at mostly non-green content,
    //   then start at zero and increase until aliasing is a problem.
    float fxaaQualityEdgeThresholdMin
) {

	// high 39
    float FXAA_QUALITY__P0 =  1.0;
    float FXAA_QUALITY__P1 =  1.0;
    float FXAA_QUALITY__P2 =  1.0;
    float FXAA_QUALITY__P3 =  1.0;
    float FXAA_QUALITY__P4 =  1.0;
    float FXAA_QUALITY__P5 =  1.5;
    float FXAA_QUALITY__P6 =  2.0;
    float FXAA_QUALITY__P7 =  2.0;
    float FXAA_QUALITY__P8 =  2.0;
    float FXAA_QUALITY__P9 =  2.0;
    float FXAA_QUALITY__P10 =  4.0;
    float FXAA_QUALITY__P11 =  8.0;

	// med 13
    // float FXAA_QUALITY__P0 = 1.0;
    // float FXAA_QUALITY__P1 = 1.5;
    // float FXAA_QUALITY__P2 = 2.0;
    // float FXAA_QUALITY__P3 = 2.0;
    // float FXAA_QUALITY__P4 = 4.0;
    // float FXAA_QUALITY__P5 = 12.0;
    vec2 posM;
    posM.x = pos.x;
    posM.y = pos.y;

	vec4 rgbyM = textureLod(tex, posM, 0.0);
	float lumaM = FxaaLuma(rgbyM);
	float lumaS = FxaaLuma(FxaaTexOff(tex, posM, vec2( 0.0, 1.0), fxaaQualityRcpFrame.xy));
	float lumaE = FxaaLuma(FxaaTexOff(tex, posM, vec2( 1.0, 0.0), fxaaQualityRcpFrame.xy));
	float lumaN = FxaaLuma(FxaaTexOff(tex, posM, vec2( 0.0,-1.0), fxaaQualityRcpFrame.xy));
	float lumaW = FxaaLuma(FxaaTexOff(tex, posM, vec2(-1.0, 0.0), fxaaQualityRcpFrame.xy));

    float maxSM = max(lumaS, lumaM);
    float minSM = min(lumaS, lumaM);
    float maxESM = max(lumaE, maxSM);
    float minESM = min(lumaE, minSM);
    float maxWN = max(lumaN, lumaW);
    float minWN = min(lumaN, lumaW);
    float rangeMax = max(maxWN, maxESM);
    float rangeMin = min(minWN, minESM);
    float rangeMaxScaled = rangeMax * fxaaQualityEdgeThreshold;
    float range = rangeMax - rangeMin;
    float rangeMaxClamped = max(fxaaQualityEdgeThresholdMin, rangeMaxScaled);
    bool earlyExit = range < rangeMaxClamped;

    if(earlyExit)
		return rgbyM;

	float lumaNW = FxaaLuma(FxaaTexOff(tex, posM, vec2(-1.0,-1.0), fxaaQualityRcpFrame.xy));
	float lumaSE = FxaaLuma(FxaaTexOff(tex, posM, vec2( 1.0, 1.0), fxaaQualityRcpFrame.xy));
	float lumaNE = FxaaLuma(FxaaTexOff(tex, posM, vec2( 1.0,-1.0), fxaaQualityRcpFrame.xy));
	float lumaSW = FxaaLuma(FxaaTexOff(tex, posM, vec2(-1.0, 1.0), fxaaQualityRcpFrame.xy));

    float lumaNS = lumaN + lumaS;
    float lumaWE = lumaW + lumaE;
    float subpixRcpRange = 1.0/range;
    float subpixNSWE = lumaNS + lumaWE;
    float edgeHorz1 = (-2.0 * lumaM) + lumaNS;
    float edgeVert1 = (-2.0 * lumaM) + lumaWE;

    float lumaNESE = lumaNE + lumaSE;
    float lumaNWNE = lumaNW + lumaNE;
    float edgeHorz2 = (-2.0 * lumaE) + lumaNESE;
    float edgeVert2 = (-2.0 * lumaN) + lumaNWNE;

    float lumaNWSW = lumaNW + lumaSW;
    float lumaSWSE = lumaSW + lumaSE;
    float edgeHorz4 = (abs(edgeHorz1) * 2.0) + abs(edgeHorz2);
    float edgeVert4 = (abs(edgeVert1) * 2.0) + abs(edgeVert2);
    float edgeHorz3 = (-2.0 * lumaW) + lumaNWSW;
    float edgeVert3 = (-2.0 * lumaS) + lumaSWSE;
    float edgeHorz = abs(edgeHorz3) + edgeHorz4;
    float edgeVert = abs(edgeVert3) + edgeVert4;

    float subpixNWSWNESE = lumaNWSW + lumaNESE;
    float lengthSign = fxaaQualityRcpFrame.x;
    bool horzSpan = edgeHorz >= edgeVert;
    float subpixA = subpixNSWE * 2.0 + subpixNWSWNESE;

    if(!horzSpan) lumaN = lumaW;
    if(!horzSpan) lumaS = lumaE;
    if(horzSpan) lengthSign = fxaaQualityRcpFrame.y;
    float subpixB = (subpixA * (1.0/12.0)) - lumaM;

    float gradientN = lumaN - lumaM;
    float gradientS = lumaS - lumaM;
    float lumaNN = lumaN + lumaM;
    float lumaSS = lumaS + lumaM;
    bool pairN = abs(gradientN) >= abs(gradientS);
    float gradient = max(abs(gradientN), abs(gradientS));
    if(pairN) lengthSign = -lengthSign;
    float subpixC = FxaaSat(abs(subpixB) * subpixRcpRange);

    vec2 posB;
    posB.x = posM.x;
    posB.y = posM.y;
    vec2 offNP;
    offNP.x = (!horzSpan) ? 0.0 : fxaaQualityRcpFrame.x;
    offNP.y = ( horzSpan) ? 0.0 : fxaaQualityRcpFrame.y;
    if(!horzSpan) posB.x += lengthSign * 0.5;
    if( horzSpan) posB.y += lengthSign * 0.5;

    vec2 posN;
    posN.x = posB.x - offNP.x * FXAA_QUALITY__P0;
    posN.y = posB.y - offNP.y * FXAA_QUALITY__P0;
    vec2 posP;
    posP.x = posB.x + offNP.x * FXAA_QUALITY__P0;
    posP.y = posB.y + offNP.y * FXAA_QUALITY__P0;
    float subpixD = ((-2.0)*subpixC) + 3.0;
    float lumaEndN = FxaaLuma(textureLod(tex, posN, 0.0));
    float subpixE = subpixC * subpixC;
    float lumaEndP = FxaaLuma(textureLod(tex, posP, 0.0));

    if(!pairN) lumaNN = lumaSS;
    float gradientScaled = gradient * 1.0/4.0;
    float lumaMM = lumaM - lumaNN * 0.5;
    float subpixF = subpixD * subpixE;
    bool lumaMLTZero = lumaMM < 0.0;

    lumaEndN -= lumaNN * 0.5;
    lumaEndP -= lumaNN * 0.5;
    bool doneN = abs(lumaEndN) >= gradientScaled;
    bool doneP = abs(lumaEndP) >= gradientScaled;
    if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P1;
    if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P1;
    bool doneNP = (!doneN) || (!doneP);
    if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P1;
    if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P1;

    if(doneNP) {
        if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
        if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
        if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
        if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
        doneN = abs(lumaEndN) >= gradientScaled;
        doneP = abs(lumaEndP) >= gradientScaled;
        if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P2;
        if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P2;
        doneNP = (!doneN) || (!doneP);
        if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P2;
        if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P2;

		// PS 3
        if(doneNP) {
            if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
            if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
            if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
            if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
            doneN = abs(lumaEndN) >= gradientScaled;
            doneP = abs(lumaEndP) >= gradientScaled;
            if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P3;
            if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P3;
            doneNP = (!doneN) || (!doneP);
            if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P3;
            if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P3;

			// PS 4
            if(doneNP) {
                if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
                if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
                if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
                if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
                doneN = abs(lumaEndN) >= gradientScaled;
                doneP = abs(lumaEndP) >= gradientScaled;
                if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P4;
                if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P4;
                doneNP = (!doneN) || (!doneP);
                if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P4;
                if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P4;

				// PS 5
                if(doneNP) {
                    if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
                    if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
                    if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
                    if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
                    doneN = abs(lumaEndN) >= gradientScaled;
                    doneP = abs(lumaEndP) >= gradientScaled;
                    if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P5;
                    if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P5;
                    doneNP = (!doneN) || (!doneP);
                    if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P5;
                    if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P5;

					// PS 6
                    if(doneNP) {
                        if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
                        if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
                        if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
                        if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
                        doneN = abs(lumaEndN) >= gradientScaled;
                        doneP = abs(lumaEndP) >= gradientScaled;
                        if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P6;
                        if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P6;
                        doneNP = (!doneN) || (!doneP);
                        if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P6;
                        if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P6;

						// PS 7
                        if(doneNP) {
                            if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
                            if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
                            if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
                            if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
                            doneN = abs(lumaEndN) >= gradientScaled;
                            doneP = abs(lumaEndP) >= gradientScaled;
                            if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P7;
                            if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P7;
                            doneNP = (!doneN) || (!doneP);
                            if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P7;
                            if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P7;

							// PS 8
							if(doneNP) {
								if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
								if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
								if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
								if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
								doneN = abs(lumaEndN) >= gradientScaled;
								doneP = abs(lumaEndP) >= gradientScaled;
								if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P8;
								if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P8;
								doneNP = (!doneN) || (!doneP);
								if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P8;
								if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P8;

								// PS 9
								if(doneNP) {
									if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
									if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
									if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
									if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
									doneN = abs(lumaEndN) >= gradientScaled;
									doneP = abs(lumaEndP) >= gradientScaled;
									if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P9;
									if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P9;
									doneNP = (!doneN) || (!doneP);
									if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P9;
									if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P9;

									// PS 10
									if(doneNP) {
										if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
										if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
										if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
										if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
										doneN = abs(lumaEndN) >= gradientScaled;
										doneP = abs(lumaEndP) >= gradientScaled;
										if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P10;
										if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P10;
										doneNP = (!doneN) || (!doneP);
										if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P10;
										if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P10;

										// PS 11
										if(doneNP) {
											if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
											if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
											if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
											if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
											doneN = abs(lumaEndN) >= gradientScaled;
											doneP = abs(lumaEndP) >= gradientScaled;
											if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P11;
											if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P11;
											doneNP = (!doneN) || (!doneP);
											if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P11;
											if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P11;

											// PS 12
											// if(doneNP) {
											//     if(!doneN) lumaEndN = FxaaLuma(textureLod(tex, posN.xy, 0.0));
											//     if(!doneP) lumaEndP = FxaaLuma(textureLod(tex, posP.xy, 0.0));
											//     if(!doneN) lumaEndN = lumaEndN - lumaNN * 0.5;
											//     if(!doneP) lumaEndP = lumaEndP - lumaNN * 0.5;
											//     doneN = abs(lumaEndN) >= gradientScaled;
											//     doneP = abs(lumaEndP) >= gradientScaled;
											//     if(!doneN) posN.x -= offNP.x * FXAA_QUALITY__P12;
											//     if(!doneN) posN.y -= offNP.y * FXAA_QUALITY__P12;
											//     doneNP = (!doneN) || (!doneP);
											//     if(!doneP) posP.x += offNP.x * FXAA_QUALITY__P12;
											//     if(!doneP) posP.y += offNP.y * FXAA_QUALITY__P12;
											// }
										}
									}
								}
							}
                        }
                    }
                }
            }
        }
    }

    float dstN = posM.x - posN.x;
    float dstP = posP.x - posM.x;
    if(!horzSpan) dstN = posM.y - posN.y;
    if(!horzSpan) dstP = posP.y - posM.y;

    bool goodSpanN = (lumaEndN < 0.0) != lumaMLTZero;
    float spanLength = (dstP + dstN);
    bool goodSpanP = (lumaEndP < 0.0) != lumaMLTZero;
    float spanLengthRcp = 1.0/spanLength;

    bool directionN = dstN < dstP;
    float dst = min(dstN, dstP);
    bool goodSpan = directionN ? goodSpanN : goodSpanP;
    float subpixG = subpixF * subpixF;
    float pixelOffset = (dst * (-spanLengthRcp)) + 0.5;
    float subpixH = subpixG * fxaaQualitySubpix;

    float pixelOffsetGood = goodSpan ? pixelOffset : 0.0;
    float pixelOffsetSubpix = max(pixelOffsetGood, subpixH);
    if(!horzSpan) posM.x += pixelOffsetSubpix * lengthSign;
    if( horzSpan) posM.y += pixelOffsetSubpix * lengthSign;
	return vec4(textureLod(tex, posM, 0.0).xyz, lumaM);
}

void fragment()
{
    COLOR = FxaaPixelShader(
		SCREEN_UV,
		SCREEN_TEXTURE,
		SCREEN_PIXEL_SIZE,
		qualitySubpix,
		qualityEdgeThreshold,
		qualityEdgeThresholdMin);
}
