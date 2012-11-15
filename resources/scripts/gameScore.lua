local Script = {
	name = "gameScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  gameVariables = require("gameVariables");  
  object:setText(string.format('Score: %d', gameVariables.score));  
end

return Script;