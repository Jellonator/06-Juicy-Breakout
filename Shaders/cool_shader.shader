shader_type canvas_item;
render_mode unshaded, blend_mix;

uniform float Scatter : hint_range(0.0, 1.0) = 0;
uniform float Fade : hint_range(0.0, 1.0) = 0;

float easeOutBounce( float t ) {
	float PI = 3.1415926535;
    return 1.0 - pow( 2.0, -6.0 * t ) * abs( cos( t * PI * 3.5 ) );
}

void fragment()
{
	float offset = sin(TIME * 0.8) * 0.4 + TIME * 0.2;
	float ycut = 0.0;
	float timemod = (1.0-Scatter);
	float yoffset = min(1.0, mod(TIME, 8.0));
	if (mod(UV.y*4.0 - cos(TIME * 0.4) * 1.0, 1.0) < 0.5)
	{
		ycut = 0.0625 + yoffset;
		if (timemod < 1.0)
		{
			ycut += easeOutBounce(timemod);
		}
	}
	else
	{
		ycut = -0.0625 - yoffset;
		if (timemod < 1.0)
		{
			ycut -= easeOutBounce(timemod);
		}
	}
	float value = mod(offset + UV.x*10.0 + UV.y + ycut, 1.0);
	if (value > 0.5)
	{
		COLOR = vec4(0.0, 0.15, 0.2, 1.0);
	}
	else
	{
		COLOR = vec4(0.1, 0.1, 0.1, 1.0);
	}
	if (abs(UV.y*2.0-1.0) < (1.0-Fade)*2.0-value)
	{
		COLOR.a = 0.0;
	}
	COLOR.r += Scatter * 0.25;
}