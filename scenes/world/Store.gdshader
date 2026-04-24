shader_type canvas_item;

uniform sampler2D mask_texture;

uniform vec4 roof_color : source_color;
uniform vec4 wall_color : source_color;
uniform vec4 door_color : source_color;

uniform vec3 baseline = vec3(0.5, 0.5, 0.5);

void fragment() {
	vec3 og_roof_color = vec3(0,0,0);
    vec4 base = texture(TEXTURE, UV);
    vec3 mask = texture(mask_texture, UV).rgb;

    vec3 detail = base.rgb - baseline;
    vec3 result = base.rgb;

    if (mask.r > 0.9) {
        result = roof_color.rgb - og_roof_color + detail;
    }
    else if (mask.g > 0.9) {
        result = wall_color.rgb + detail;
    }
    else if (mask.b > 0.9) {
        result = door_color.rgb + detail;
    }

    COLOR = vec4(result, base.a);
}