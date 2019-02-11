#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float beat;
float x0;
float y0;
float timer;


float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy);
	float x0 = ceil((gl_FragCoord.x+(rand((time,time))*350.))/(100.*sin(time/5000.)));
	float y0 = ceil((gl_FragCoord.y+(rand((time,time))*500.))/(100.*sin(time/5000.)));
	float y = ceil(gl_FragCoord.y/mouse.y);
	//
	vec2 z = (200.,200.);
	
	//rand((sin(x),y+(rand((time*0.000002,time*x*0.000002)))))
	//float r = min((gl_FragCoord.x/resolution.x+gl_FragCoord.y/resolution.y)/2.,(z.x+z.y)/2.);
	float r = (gl_FragCoord.y/resolution.y)+rand((time,x0)) - 0.3;
	float g = (500/(gl_FragCoord.y/resolution.y)+rand((time,y0))) - 1500*r*(beat*100.+1.);
	float b = (500/(gl_FragCoord.y/resolution.y)+rand((time,y0)))*(beat*0.002);
	
	gl_FragColor = vec4(r,g,b,1);
}
