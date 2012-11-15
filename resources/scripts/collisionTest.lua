local Script = {
	name = "collisionTest.lua",
};

local t = 0;
function Script.update(object, dt)
  local gameVariables = require("gameVariables");
	local diff = object:getLoc();
	local playerPosition = gameVariables.playerPosition;
  diff.x = diff.x - playerPosition.x;
  diff.y = diff.y - playerPosition.y;
  diff.z = diff.z - playerPosition.z;
  
  local distSqrd = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
  local objectRadius = 100;
  if distSqrd < objectRadius then
    gameVariables.gameTimer = gameVariables + 5;
  end
	--object:setLoc(position.x + step, position.y, position.z); 
end

return Script;