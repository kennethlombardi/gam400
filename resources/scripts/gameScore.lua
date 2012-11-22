local Script = {
	name = "gameScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  gameVariables = require("GameVariables");  
  object:setText(string.format('Score: %d', GameVariables:GetScore()));  
end

return Script;