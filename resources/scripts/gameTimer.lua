local Script = {
	name = "gameTimer.lua",
};

local t = 0;
function Script.update(object, dt)  
  gameVariables = require("GameVariables");
  gameVariables:AddGameTimer(-dt);
  if (gameVariables:GetGameTimer() < 0) then
    os.exit();
  end
  object:setText(string.format('Time Remaining: %d', gameVariables:GetGameTimer()));  
end

return Script;