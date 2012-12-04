local Script = {
	name = "gameTimer.lua",
};

local t = 0;
local triggeredOutOfTime = false;
function Script.update(object, dt)  
	gameVariables = require("GameVariables");
	gameVariables:add("Timer", -dt);
	if (gameVariables:get("Timer") < 0) then
    if triggeredOutOfTime == false then
      object:setText(string.format('Time Remaining: %d', gameVariables:get("Timer")));  
		  require("MessageManager"):send("RAN_OUT_OF_TIME");
      object:replaceAllScripts(require("Factory"):createFromFile("Script", ""));
    end
    return;
	end
	object:setText(string.format('Time Remaining: %d', gameVariables:get("Timer")));  
  -- local Input = require("InputManager")
  -- object:setText(string.format('x = %f y = %f z = %f', Input.Android.diffAccel.x, Input.Android.diffAccel.y, Input.Android.diffAccel.z));
end

return Script;