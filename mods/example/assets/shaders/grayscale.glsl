vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec4 pixel = Texel(texture, texture_coords);

	// Calculate the luminance of the pixel using the NTSC standard
	float gray = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));

	// Return the grayscale color
	return vec4(gray, gray, gray, pixel.a) * color;

}
