local Script = {
	name = "gameTimer.lua",
};

local t = 0;
function Script.update(object, dt)  
  gameVariables = require("gameVariables");
  gameVariables.gameTimer = gameVariables.gameTimer - dt;
  object:setText(string.format('Time Remaining: %d', gameVariables.gameTimer));  
end

return Script;