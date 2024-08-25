shader_type canvas_item;

uniform float lerp_percent : hint_range(0.0, 1.0);

void fragment() {
	// vec4 has four params; red, green, blue, alpha
	vec4 texture_initial_color = texture(TEXTURE, UV);
	vec4 texture_final_color = mix(texture_initial_color, vec4(1.0, 1.0, 1.0, texture_initial_color.a), lerp_percent);
	COLOR = texture_final_color;
}
