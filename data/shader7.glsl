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

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//
// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author: Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/ashima/webgl-noise
//

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+1.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}

// Classic Perlin noise
float cnoise(vec2 P)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

void main( void ) {

	vec2 p;
	p = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	float r;
	float g;
	float b;

	for(int i=1;i<6;i++) 
	{
		p.y = 0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)-i*i*i))) + 0.7;
		p.x = 0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)+i*i))) + 0.5;
		r += (0.7 + sin(time/(i*384))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		g += (0.7 + sin(time/(i*154))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		b += (0.7 + sin(time/(i*756))) * (1+5*beat) * (i/5.) * (1+5*beat) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
	}
	for(int i=1;i<6;i++) 
	{
		p.y = 1/0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)-i*i*i))) + 0.7;
		p.x = 1/0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)+i*i))) + 0.5;
		r += (0.7 + sin(time/(i*236))) * (1+5*beat) * (i/5.) * 6. / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		g += (0.7 + sin(time/(i*636))) * (1+5*beat) * (i/5.) * 6. / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		b += (0.7 + sin(time/(i*156))) * (1+5*beat) * (i/5.) * 6. / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
	}
	for(int i=1;i<6;i++) 
	{
		p.y = -0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)-i*i*i))) + 0.7;
		p.x = -0.5*sin(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)+i*i))) + 0.5;
		r += (0.7 + sin(time/(i*856))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		g += (0.7 + sin(time/(i*258))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		b += (0.7 + sin(time/(i*214))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
	}
	for(int i=1;i<8;i++) 
	{
		p.y = (0.5*cos(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)-i*i*i))) + 0.7);
		p.x = -(0.5*cos(time/(1000)-rand((gl_FragCoord.x,0.00000001*sin(time/5000.)+i*i))) + 0.5)+1;
		r += (0.7 + sin(time/(i*153))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		g += (0.7 + sin(time/(i*675))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
		b += (0.7 + sin(time/(i*546))) * (1+5*beat) * (i/5.) * 1.5 / sqrt(pow((gl_FragCoord.x+(500.*rand((gl_FragCoord.x,i)))-(p.x*resolution.x)),2) + pow((gl_FragCoord.y+(500.*rand((gl_FragCoord.x,i)))-(p.y*resolution.y)),2)) - 0.0;
	}
	
	float yF = 1.;
	float xF = 1.;
	
	
	gl_FragColor = vec4(r, g, b, 1.0 );
	
	timer = time;
}
