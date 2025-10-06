shader_type canvas_item;

// Up to 30 mask textures
uniform sampler2D main_texture;

void fragment() {
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 tex = texture(main_texture, UV);
	
	float darkness = 1.0 - tex.r;

    // Combine masks by minimum alpha (change as needed)
    color.a = min(color.a, tex.a);
	color.a = min(color.a, darkness);

    COLOR = color;
}