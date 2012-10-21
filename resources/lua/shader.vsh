// Copyright (c) 2010-2011 Zipline Games, Inc. All Rights Reserved.
// http://getmoai.com

attribute lowp vec4 position;
attribute lowp vec2 uv;
attribute lowp vec4 color;

varying lowp vec4 colorVarying;
varying lowp vec2 uvVarying;

void main () {
    gl_Position = position; 
	uvVarying = uv;
    colorVarying = color;
}
