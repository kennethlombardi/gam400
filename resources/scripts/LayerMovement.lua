local Script = {
	name = "LayerMovement.lua",
};
local zPressed = 1;
local zMax = 5;
function Script.update(object, dt)
	local position = object:getLoc();
	local step = 10;
  local InputManager = require("InputManager");
  local gameVariables = require("gameVariables");
  gameVariables.lastPosition = {x = position.x, y = position.y, z = position.z};
  if InputManager.Android then
    local move = InputManager.Android.diffAccel;
    local scale = 5;    
    local newPos = {x = position.x + move.y*scale, y =  position.y - move.x*scale, z = position.z};
    local limit = 500;
    
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
    
    if InputManager:isScreenPressed(0) then
      if zPressed < zMax then
        zPressed = zPressed + dt;      
      end
      newPos.z = newPos.z - scale*zPressed;
    else
      if zPressed > 0 then
        zPressed = zPressed * .9;
      else
        zPressed = 0;
      end
    end
    
    if InputManager:isScreenTriggered(1) then
      InputManager:reCal();
    end	
    
    object:setLoc(newPos.x, newPos.y, newPos.z);
  end
  
  if InputManager.Keyboard then    
    local scale = 5;    
    local newPos = {x = position.x, y = position.y, z = position.z};
    
    if InputManager:isKeyDown(InputManager.Key['w']) then
      newPos.y = newPos.y + scale;
    elseif InputManager:isKeyDown(InputManager.Key['s']) then
      newPos.y = newPos.y - scale;
    end
    
    if InputManager:isKeyDown(InputManager.Key['d']) then
      newPos.x = newPos.x + scale;
    elseif InputManager:isKeyDown(InputManager.Key['a']) then
      newPos.x = newPos.x - scale;
    end
    
    if InputManager:isKeyDown(InputManager.Key['SPACE']) then      
      if zPressed < zMax then
        zPressed = zPressed + scale*dt;      
      end
      newPos.z = newPos.z - scale*zPressed;
    else
      if zPressed > 1 then
        zPressed = zPressed - scale*dt;
      else
        zPressed = 1;
      end
      newPos.z = newPos.z - scale*zPressed;
    end    
    
    local limit = 500;
    
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
    object:setLoc(newPos.x, newPos.y, newPos.z);
    gameVariables.playerPosition = {x = newPos.x, y = newPos.y, z = newPos.z};
  end
	
end

return Script;