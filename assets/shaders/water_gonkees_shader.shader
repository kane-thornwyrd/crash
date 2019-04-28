shader_type canvas_item;

uniform vec4 tint : hint_color;
uniform sampler2D water_texture;
uniform float y_offset;

uniform mat4 o2v_projection_reflection;
uniform sampler2D reflection_sampler;
varying vec3 interpolatedVertexObject;

vec4 blur(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  vec4 color = vec4(0.0);
  vec2 off1 = vec2(1.411764705882353) * direction;
  vec2 off2 = vec2(3.2941176470588234) * direction;
  vec2 off3 = vec2(5.176470588235294) * direction;
  color += texture(image, uv) * 0.1964825501511404;
  color += texture(image, uv + (off1 / resolution)) * 0.2969069646728344;
  color += texture(image, uv - (off1 / resolution)) * 0.2969069646728344;
  color += texture(image, uv + (off2 / resolution)) * 0.09447039785044732;
  color += texture(image, uv - (off2 / resolution)) * 0.09447039785044732;
  color += texture(image, uv + (off3 / resolution)) * 0.010381362401148057;
  color += texture(image, uv - (off3 / resolution)) * 0.010381362401148057;
  return color;
}

float rand(vec2 coord){
  return fract(sin(dot(coord, vec2(12.9898, 78.233)))* 43758.5453123);
}

float noise(vec2 coord){
  vec2 i = floor(coord);
  vec2 f = fract(coord);

  // 4 corners of a rectangle surrounding our point
  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));

  vec2 cubic = f * f * (3.0 - 2.0 * f);

  return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm (in vec2 st) {
    // Initial values
    float value = 0.0;
    float amplitud = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < 6; i++) {
        value += amplitud * noise(st);
        st *= 2.;
        amplitud *= .5;
    }
    return value;
}

float edge(float v, float center, float edge0, float edge1) {
    return 1.0 - smoothstep(edge0, edge1, abs(v - center));
}

void fragment(){
  vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
  vec2 uv = vec2(FRAGCOORD.xy / iResolution.xy);
  vec2 st = FRAGCOORD.xy / uv.xy;

  vec2 noisecoord1 = UV * 8.;
  vec2 noisecoord2 = UV * 8. + 4.0;
  vec2 noisecoord3 = UV * 4.;

  vec2 motion1 = vec2(TIME * 0.3, TIME * -0.3);
  vec2 motion2 = vec2(TIME * 0.1, TIME * 0.3);

  vec2 distort1 = vec2(noise(noisecoord1 + motion1), noise(noisecoord2 + motion1)) - vec2(0.5);
  vec2 distort2 = vec2(noise(noisecoord1 + motion2), noise(noisecoord2 + motion2)) - vec2(0.5);

  vec2 distort_sum = (distort1 + distort2) / 60.0;

  vec4 color;
  vec2 direction = vec2(1.5,.5);
  color = blur(SCREEN_TEXTURE, SCREEN_UV + distort_sum, iResolution, direction);

  color = mix(color, tint, 0.2);
  color.rgb = mix(vec3(0.2), color.rgb, 1.4);
  color = mix(color,texture(water_texture, FRAGCOORD.xy + distort_sum), .2);

  COLOR = color;


}