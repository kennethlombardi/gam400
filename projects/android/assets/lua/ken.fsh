varying MEDP vec2 uvVarying;
uniform sampler2D sampler;
uniform float timeUniform;

void main() { 
	gl_FragColor = texture2D ( sampler, uvVarying)  * timeUniform ;
}
