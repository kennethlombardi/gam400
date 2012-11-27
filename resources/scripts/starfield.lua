local Script = {
	name = "starfield.lua",
};
local zPressed = 1;
local zMax = 5;
local spawnTimer = 0;

function Script.update(object, dt)
  spawnTimer = spawnTimer + dt;
	local position = object:getLoc();
	object:setLoc(position.x, position.y, position.z - dt * 30);
    if spawnTimer > .5 then    
      spawnTimer = 0;
      local newprop = require("Generator"):spawnCube(position.z - 3000);  
      object:insertPropPersistent(newprop);
      object:insertProp(newprop);
    end
end

return Script;