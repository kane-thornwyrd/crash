shader_type canvas_item;

float rand(vec2 co, float seed)
{
    return fract(sin(dot(co.xy ,vec2(12.9898 + seed,78.233 - seed))) * 43758.5453);
}

void fragment()
{
  vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = FRAGCOORD.xy / iResolution.xy;
	
    float xdist = (.5 - uv.x)*2.;
    float ydist = (.5 - uv.y)*2.;
    float dist = 1. - sqrt(xdist*xdist/2. + ydist*ydist/2.);
    
    float deEffect = 6.;// + abs(cos(iTime));
    
    vec2 lensShift = uv + vec2(xdist*dist/deEffect, ydist*dist/deEffect);
    vec2 colorShift = lensShift - vec2(.01 + .001 * sin(uv.y * 300. + TIME  * 50.), 0.);
    float linearShift = abs(sin(uv.y * 3. + TIME * 20.));
    
    COLOR = 
        texture(TEXTURE, lensShift) *  (1. - .1 * rand(uv, TIME))
        / (vec4(1.,1.,1.,1.) - texture(TEXTURE, colorShift) + vec4(linearShift, linearShift, linearShift, 1.) * .05) * .3;
        + (-.1 + rand(uv, TIME) * .2);
}