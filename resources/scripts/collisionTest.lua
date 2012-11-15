local Script = {
	name = "collisionTest.lua",
};

local t = 0;
function Script.update(object, dt)
  local gameVariables = require("gameVariables");
	local objectPos = object:getLoc();  
	local playerPosition = gameVariables.playerPosition;
  local diff = {};    
  
  diff.x = objectPos.x - playerPosition.x;
  diff.y = objectPos.y - playerPosition.y;
  diff.z = objectPos.z - playerPosition.z;
  
  local distSqrd = diff.x * diff.x + diff.y * diff.y + diff.z * diff.z;
  local objectRadius = 150;
  
  if distSqrd < objectRadius then
    gameVariables.gameTimer = gameVariables.gameTimer + 3;
    object:setLoc(objectPos.x, objectPos.x, objectPos.z + 500); 
    require("SoundManager"):play("mono16.wav", false);
    gameVariables.score = gameVariables.score + 100;
  end
	
end

return Script;