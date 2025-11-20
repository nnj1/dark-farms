shader_type canvas_item;

void fragment() {
    // Get the texture color
    vec4 color = texture(TEXTURE, UV);

    // Check if the pixel is black
    if (color.rgb == vec3(0.0, 0.0, 0.0)) {
        // Make it fully transparent
        color.a = 0.0;
    }

    // Apply the color to the final output
    COLOR = color;
}
