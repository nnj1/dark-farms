shader_type canvas_item;

// Prefer the Godot 4 hint name
uniform sampler2D texture : hint_default_white;

// Threshold for what is considered "black".
uniform float black_threshold : hint_range(0.0, 0.2) = 0.01; 

void fragment() {
    // 1. Initialize final color to the current pixel's color
    vec4 current_color = texture(TEXTURE, UV);
    vec4 final_color = current_color;

    // 2. Check if the current pixel is "black"
    float max_channel = max(current_color.r, max(current_color.g, current_color.b));
    bool is_black = max_channel < black_threshold;
    
    // 3. Conditional logic to check neighbors ONLY if the pixel is black
    if (is_black) {
        // Get the size of one pixel in UV coordinates
        vec2 pixel_size = TEXTURE_PIXEL_SIZE; 
        
        // Define UV offsets for the four neighbors
        vec2 up_uv    = UV + vec2(0.0, -pixel_size.y);
        vec2 down_uv  = UV + vec2(0.0, pixel_size.y);
        vec2 left_uv  = UV + vec2(-pixel_size.x, 0.0);
        vec2 right_uv = UV + vec2(pixel_size.x, 0.0);
        
        // Get the colors of the four neighbors
        vec4 up_color    = texture(TEXTURE, up_uv);
        vec4 down_color  = texture(TEXTURE, down_uv);
        vec4 left_color  = texture(TEXTURE, left_uv);
        vec4 right_color = texture(TEXTURE, right_uv); // Typo corrected from previous answer: should use right_uv

        // Get the colors of the four neighbors
        up_color    = texture(TEXTURE, up_uv);
        down_color  = texture(TEXTURE, down_uv);
        left_color  = texture(TEXTURE, left_uv);
        right_color = texture(TEXTURE, right_uv);
        
        // Check if a neighbor is a "different color" (i.e., not close to black)
        bool up_is_diff    = max(up_color.r, max(up_color.g, up_color.b)) > black_threshold;
        bool down_is_diff  = max(down_color.r, max(down_color.g, down_color.b)) > black_threshold;
        bool left_is_diff  = max(left_color.r, max(left_color.g, left_color.b)) > black_threshold;
        bool right_is_diff = max(right_color.r, max(right_color.g, right_color.b)) > black_threshold;
        
        // The black pixel is preserved only if ALL four neighbors are a different color.
        bool all_neighbors_diff = up_is_diff && down_is_diff && left_is_diff && right_is_diff;
        
        if (!all_neighbors_diff) {
            // Condition not met: Not fully surrounded by different colors. Make it transparent.
            // We only change final_color if we need to make it transparent.
            final_color.a = 0.0;
        }
    }
    
    // 4. Output the final determined color
    COLOR = final_color;
}