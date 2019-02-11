#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform float beat2;
uniform float beat;
uniform vec2 mouse;

float timer = 0;
float rotF = 0;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	
	rotF = sin(time/2000);
	//if (rotF > 1) rotF = 1;
	
	float tempX = p.x;
	p.x = p.x + (rotF*p.y);
	p.y = p.y - (rotF*tempX);
	
	float s = sin(time);
	float dy = 1. / ( 50. * abs(p.y) / (2+(6*beat)));
	float dx = 1. / ( 50. * abs(p.x) / (2+(6*beat)));
	
	float yF = 1.;
	float xF = 1.;
	
	
	float r = (yF*dy) * 0.2 * (xF*dx) * (3.5+(4*sin(time/200)));
	float g = 0.5 * (yF*dy) * (xF*dx) * (3.5+(4*sin(time/500)));
	float b = (xF*dx) * (yF*dy) * (3.5+(4*sin(time/400)));
	gl_FragColor = vec4(r, g, b, 1.0 );
	
	timer = time;
}
