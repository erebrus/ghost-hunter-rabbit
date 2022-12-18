shader_type canvas_item;

uniform float pct=.8;

void fragment(){
	vec4 modulate =  MODULATE;
	float npct = pct;
	vec4 bgColor = modulate;
	vec4 fgColor = texture(SCREEN_TEXTURE,SCREEN_UV);//texture(TEXTURE, UV);
	COLOR= step(1.-npct,UV.y)*bgColor+step(npct,1.-UV.y)*fgColor;
}