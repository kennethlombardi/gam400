local Input = {};
Input.Mouse = 0;
Input.Keyboard = 0;

if MOAIInputMgr.device.pointer then			
	Input.Mouse = require "MouseInput";
end
if MOAIInputMgr.device.keyboard then
	Input.Keyboard = require "KeyboardInput";
end

return Input;