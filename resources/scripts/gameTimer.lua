local Script = {
	name = "gameTimer.lua",
};

local t = 0;
function Script.update(object, dt)  
  gameVariables = require("gameVariables");
  gameVariables.gameTimer = gameVariables.gameTimer - dt;
  if (gameVariables.gameTimer < 0) then
    os.exit();
  end
  object:setText(string.format('Time Remaining: %d', gameVariables.gameTimer));  
end

return Script;