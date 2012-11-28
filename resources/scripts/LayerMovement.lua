local Script = {
	name = "LayerMovement.lua",
};
local zPressed = 1;
local zMax = 5;
local xRot = 0;
local yRot = 0;
local LayerManager = require("LayerManager");
local lastZSpawn = 0;
local spawnTimer2 = 0;
function Script.update(object, dt)
    
  spawnTimer2 = spawnTimer2 + dt;
  local position = object:getLoc();
  
  if math.abs(lastZSpawn - position.z) > 5000 then
    lastZSpawn = 0
  end
  
  if lastZSpawn - position.z > 500 then   
    if math.random(0, 10) > 1 then
      lastZSpawn = position.z -2500;
      local newprops = require("Generator"):spawnPattern(nil, nil, position.z - 1500);  
      for i = 1, #newprops do
        object:insertPropPersistent(newprops[i]);
        object:insertProp(newprops[i]);
      end
    else     
      lastZSpawn = position.z - 1500;
      local newprop = require("Generator"):spawnObject(nil, nil, position.z - 1500);  
      object:insertPropPersistent(newprop);
      object:insertProp(newprop);
    end
  end
  
  if spawnTimer2 > .3 then
    spawnTimer2 = 0;    
    local newprop = require("Generator"):spawnCube(position.z - 3000);  
    object:insertPropPersistent(newprop);
    object:insertProp(newprop);
  end
  
  local InputManager = require("InputManager");
  local gameVariables = require("GameVariables");    
  if InputManager.Android then
    if InputManager:isScreenTriggered(1) then
      InputManager:reCal();
    end	
  end
  
  local move = InputManager:getMove();
  local scale = 5; 
  
  local newPos = {x = position.x + scale*move.x, y =  position.y + scale*move.y, z = position.z};
  local limit = 500;
  scale = 10;
  yRot = yRot - move.x*scale*dt;
  xRot = xRot + move.y*scale*dt;
  
  if newPos.x > limit then
    newPos.x = limit;
  elseif newPos.x < -limit then
    newPos.x = -limit;
  end
  
  if newPos.y > limit then
    newPos.y = limit;
  elseif newPos.y < -limit then
    newPos.y = -limit;
  end

  rotLimit = scale/2;
  if xRot > rotLimit then
    xRot = rotLimit;
  elseif xRot < -rotLimit then
    xRot = -rotLimit;
  end
  
  if yRot > rotLimit then
    yRot = rotLimit;
  elseif yRot < -rotLimit then
    yRot = -rotLimit;
  end

  
  if InputManager:isPressed() then
    if zPressed < zMax then
      zPressed = zPressed + 3*dt;      
    end
  else
    if zPressed > 1 then
      zPressed = zPressed * .9;
    else
      zPressed = 1;
    end
    
  end
  newPos.z = newPos.z - 5*zPressed;
  object:setRot(xRot, yRot, 0);
  object:setLoc(newPos.x, newPos.y, newPos.z);
  gameVariables:set("Position", newPos);
  gameVariables:set("Distance", -newPos.z); 
  
end

return Script;
