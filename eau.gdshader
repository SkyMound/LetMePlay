shader_type canvas_item;
uniform float dis_str = 0.2;
uniform sampler2D noise : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform vec2 scroll = vec2(0.1,0.1);
uniform vec2 scroll2 = vec2(-0.1,-0.1);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 color :source_color;

void fragment() {
	float global_time = TIME * 0.1; // Contrôle de la vitesse du mouvement du bruit
	float depth = texture(noise, UV + global_time * scroll).r * texture(noise2, UV + global_time * scroll2).r;
	//vec4 noise_col = texture(noise, UV + global_time * scroll);
	vec4 screen_col = texture(screen_texture,UV + dis_str * vec2(depth));
	COLOR = screen_col * color;
}
