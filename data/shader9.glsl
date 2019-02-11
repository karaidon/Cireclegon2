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

void main( void ) {

	vec2 p;
	p = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	float r;
	float g;
	float b;
	float a = 1;

	p.y = sin(rand((p.y,p.y+sin(time/5.)*300000.)));
	p.x = sin(rand((p.x,p.x+sin(time/5.)*300000.)));
	r = 300.0 / sqrt(pow((gl_FragCoord.x-(p.x*resolution.x)),2) + pow((gl_FragCoord.y-(p.y*resolution.y)),2)) - 0.9 - rand((p.x,p.x*p.y*9.)) + beat;
	g = 300.0 / sqrt(pow((gl_FragCoord.x-(p.x*resolution.x)),2) + pow((gl_FragCoord.y-(p.y*resolution.y)),2)) - 0.9 - rand((p.x,p.x*p.y*7.)) + beat;
	b = 300.0 / sqrt(pow((gl_FragCoord.x-(p.x*resolution.x)),2) + pow((gl_FragCoord.y-(p.y*resolution.y)),2)) - 0.9 - rand((p.x,p.x*p.y*2.)) + beat;
	float yF = 1.;
	float xF = 1.;
	
	
	gl_FragColor = vec4(r, g, b, a );
	
	timer = time;
}
