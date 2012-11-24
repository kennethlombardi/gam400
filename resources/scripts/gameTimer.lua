local Script = {
	name = "gameTimer.lua",
};

local t = 0;
function Script.update(object, dt)  
	gameVariables = require("GameVariables");
	gameVariables:AddGameTimer(-dt);
	if (gameVariables:GetGameTimer() < 0) then
		require("MessageManager"):send("RAN_OUT_OF_TIME");
	end
	object:setText(string.format('Time Remaining: %d', gameVariables:GetGameTimer()));  
end

return Script;