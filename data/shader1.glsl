#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float beat;
uniform float beat2;

float x;
float y;
float timer;
float rand(vec2 n);

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy );
	float s = -300.;
	float m = sqrt(sin(time*(0.00005+(beat/2.))*ceil(gl_FragCoord.x/3.)/ceil(gl_FragCoord.y/3.)));
	float r = (sin(s)/cos(m)/50.-(0.005*sin(time*50.)))+(beat/75.);
	float g = r/tan(m)*1.6;
	float b = r/tan(m)/1.5;
	
	gl_FragColor = vec4(r,g,b,1);
}

