local Script = {
	name = "AccelerometerDebug.lua",
};

local t = 0;
local InputManager = require("InputManager");
function Script.update(object, dt)
	object:setText(string.format('X %f : Y %f : Z %f', InputManager.Android.accel.x, InputManager.Android.accel.y, InputManager.Android.accel.z));
end

return Script;