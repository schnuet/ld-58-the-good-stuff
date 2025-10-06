shader_type canvas_item;

// Up to 30 mask textures
uniform sampler2D mask_textures[30];

// (offset_x_px, offset_y_px, scale_x, scale_y)
// offset is in **pixels**, scale is relative (1.0 = normal size)
uniform vec4 mask_transform[30];

// Per-texture pixel sizes (e.g. 1280x720)
uniform vec2 mask_sizes[30];

// CanvasItem pixel size (e.g. 1920x1080)
uniform vec2 canvas_size;

void fragment() {
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

    // Convert CanvasItem UV (0–1) → pixel space
    vec2 pixel_uv = UV * canvas_size;

    for (int i = 0; i < 30; i++) {
        vec2 offset_px = mask_transform[i].xy;  // offset in pixels
        vec2 scale = mask_transform[i].zw;      // relative scale

        // Compute texture UVs in pixel space:
        // subtract pixel offset, then divide by scaled texture size
      	vec2 tex_uv = (pixel_uv - offset_px) * (1.0 / scale) / mask_sizes[i];

        // Sample the mask texture
        vec4 mask = texture(mask_textures[i], tex_uv);
		float darkness = 1.0 - mask.r;

        // Combine masks by minimum alpha (change as needed)
        color.a = min(color.a, mask.a);
		color.a = min(color.a, darkness);
    }

    COLOR = color;
}