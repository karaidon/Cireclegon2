#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform float beat2;
uniform float beat;
uniform vec2 mouse;
uniform vec2 resolution;
float x;
float y;
float move;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main( void ) {
	
	vec2 p = (gl_FragCoord.xy / resolution.xy );
	float s = pow(sin(30.)*tan(25.)+gl_FragCoord.y,-4.);
	//float m = sqrt(time*3.*p.x*sin(2.)*2.*gl_FragCoord.x);
	move += time;
	float m = sqrt(((time-1000.)/120000.)*3.*p.x*sin(2.)*2.*gl_FragCoord.x) - (100.*sin(time/5000.+(rand((time,time))/500.)));
	
	
	
	
	float r = (cos(s)/cos(m)/50.)*(1.+beat*10.);
	float g = r/tan(m)*1.6;
	float b = r/tan(m*2)/1.5;
	
	gl_FragColor = vec4(r,g,b,1);
	
	/*vec2 p = (gl_FragCoord.xy / 3000.);
	//float s = pow(sin(30.) * tan(25.) + gl_FragCoord.y, -4.);
	float s = time*10.;
	float m = sqrt(time/(0.5+beat*5.)*p.x*sin(122.5221)*2.*gl_FragCoord.x) + (time/50.);
	
	
	
	
	float r = (cos(s)/cos(m)/50.)*(beat+1.);
	float g = r/tan(m)*2.7;
	float b = r/tan(m+rand((time,time+gl_FragCoord.x)))/1.5;
	
	gl_FragColor = vec4(r,g,b,1);*/
}

