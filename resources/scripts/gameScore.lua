local Script = {
	name = "gameScore.lua",
};

local t = 0;
function Script.update(object, dt)  
  object:setText(string.format('Score: %d', require("UserDataManager"):get("currentScore")));  
end

return Script;