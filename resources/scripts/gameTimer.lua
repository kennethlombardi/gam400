local Script = {
	name = "gameTimer.lua",
};

local t = 0;
function Script.update(object, dt)  
	gameVariables = require("GameVariables");
	gameVariables:add("Timer", -dt);
	if (gameVariables:get("Timer") < 0) then
		require("MessageManager"):send("RAN_OUT_OF_TIME");
	end
	object:setText(string.format('Time Remaining: %d', gameVariables:get("Timer")));  

end

return Script;