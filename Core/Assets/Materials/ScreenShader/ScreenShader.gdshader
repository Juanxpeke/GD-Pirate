/* Reference: https://www.youtube.com/watch?v=E401x98N6iA&t */
shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

/* Modifiable uniforms */
uniform float curvature            = 0.0;

uniform bool  cutoff_enabled       = true;

uniform bool  scanlines_enabled    = false;
uniform float scanlines_dispersion = 0.0;

uniform bool  vignette_enabled             = true;
uniform float vignette_dispersion_exponent = 4.0;
uniform float vignette_intensity           = 0.2;

/* Special uniforms */
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// Top left SCREEN_UV is (0, 0), centered_uv is (-0.5, -0.5)
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
	// 
	vec2 uv_offset = centered_uv.yx * curvature;
	
	vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
	
	vec3 screen_color = textureLod(screen_texture, (warped_uv + 1.0) / 2.0, 0.2).rgb;

	if (cutoff_enabled) {
		vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
		screen_color *= cutoff;
	}
	if (scanlines_enabled) {
		vec3 scanlines = vec3(sin(2.0 * warped_uv.y * 180.0) * 0.1 + 0.9);
		screen_color *= scanlines;
	}
	if (vignette_enabled) {
		vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(vignette_dispersion_exponent)) * vignette_intensity));
		screen_color -= vignette;
	}
	
	COLOR = vec4(screen_color, 1.0);
}
