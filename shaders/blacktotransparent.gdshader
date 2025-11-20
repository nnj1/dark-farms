shader_type canvas_item;

// --- Uniforms ---

// The color to make transparent. Must be vec4 for hint_color to work.
uniform vec3 target_color: source_color = vec3(0.0, 0.0, 0.0);

// How close the color must be to the target_color to be considered a match.
uniform float color_tolerance: hint_range(0.0, 0.1) = 0.01;

// The opacity threshold for a neighbor to be considered "part of the character."
uniform float alpha_threshold: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	// 1. Get the current pixel's color
	vec4 current_color = texture(TEXTURE, UV);
	
	// 2. Default output is the original color
	COLOR = current_color; 
	
	// Check 1: Is the current pixel close to the target color?
	bool is_target_color = distance(current_color.rgb, target_color.rgb) < color_tolerance;
	
	// Only proceed with outline detection if the pixel is the target color.
	if (is_target_color) {
		
		// --- Check 2: Neighbor Search ---
		
		vec2 pixel_size = TEXTURE_PIXEL_SIZE;
		bool has_opaque_neighbor = false;
		
		// Loop through a 3x3 kernel (8 neighbors)
		for (int x = -1; x <= 1; x++) {
			for (int y = -1; y <= 1; y++) {
				// Skip the center pixel (0, 0)
				if (x == 0 && y == 0) continue;
				
				vec2 neighbor_uv = UV + vec2(float(x) * pixel_size.x, float(y) * pixel_size.y);
				vec4 neighbor_color = texture(TEXTURE, neighbor_uv);
				
				// Check if the neighbor is opaque (part of the main character)
				if (neighbor_color.a > alpha_threshold) {
					has_opaque_neighbor = true;
					break; 
				}
			}
			if (has_opaque_neighbor) break;
		}
		
		// --- Final Decision ---
		if (has_opaque_neighbor) {
			// This black pixel is the outline. Make it transparent.
			COLOR = vec4(current_color.rgb, 0.0);
		} else {
			// This black pixel is isolated. Keep it as its original color (opaque black).
			// This is redundant since COLOR was defaulted to current_color, 
			// but it shows the logic flow.
			COLOR = current_color; 
		}
	}
	// The function completes naturally here.
}