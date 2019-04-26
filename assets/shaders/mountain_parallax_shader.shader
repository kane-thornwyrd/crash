shader_type canvas_item;

void fragment() {
  vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 p = FRAGCOORD.xy / iResolution.xy;

	float x = p.x;
	float w = 1.;

	float t = 0.;

	float a = 0.2;

	float size = 20.0;

	for(float i = 0.; i < size; i+=1.0) {
		x *= 20.;
		w = sin(x) * 0.01;

		p.x += i;
		float s = TIME * i / size * 0.5;
		
		x = (p.x + s) * 2.53;
		w += sin(x) * 0.21 * s * 0.01;

		x = (p.x + s) * 1.53;
		w += sin(x) * 0.41;
		
		t = (10. - i) / size + w;

		if(p.y < t) {
			a = max(a, smoothstep(t+.1, t, p.y) * i/(size-1.));
		}
	}



	COLOR = vec4(vec3(a), 1.0);
}
