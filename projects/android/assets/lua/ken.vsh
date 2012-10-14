attribute vec4 position;
attribute vec2 uv;
attribute vec4 color;
uniform float timeUniform;

varying vec4 colorVarying;
varying vec2 uvVarying;

void main () {
  gl_Position = position; 
	uvVarying = uv;
  colorVarying = color;
}
