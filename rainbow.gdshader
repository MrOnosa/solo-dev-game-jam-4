shader_type canvas_item;

// Speed of the color rotation (settable from the editor)
uniform float speed = -0.3;

// Width of the rainbow stripes (affects how many stripes fit across the sprite width)
uniform float stripe_width = 5.2;

// Control the size of the pixelation (the larger the value, the more pixelated it looks)
uniform float pixel_size = 8.0;

uniform bool enabled = false;

void fragment() {
	if(enabled)
	{
	    // Get the UV coordinates (position on the sprite)
	    vec2 uv = UV;

	    // Snap UVs to create the pixelation effect
	    uv = floor(uv * pixel_size) / pixel_size;
		
	    // Calculate time-based shift for rotating the colors
	    float time_shift = TIME * speed;

	    // Calculate the hue using sine waves and UV coordinates to create the horizontal stripes
	    float hue = fract(uv.y / stripe_width + time_shift);

	    // Convert hue to RGB for the rainbow effect
	    vec3 color = vec3(abs(sin(hue * 6.28318)), abs(sin((hue + 0.33) * 6.28318)), abs(sin((hue + 0.66) * 6.28318)));

	    // Get the original sprite's alpha for transparency
	    vec4 texture_color = texture(TEXTURE, UV);

	    // Output the final color with the original sprite's alpha
	    COLOR = vec4(color, texture_color.a);
	}
}
