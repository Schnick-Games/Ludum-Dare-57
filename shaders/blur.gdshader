shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);
uniform vec4 tint: source_color;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount)*tint;
}
