local Script = {
	name = "LayerMovement.lua",
};
local zPressed = 1;
local zMax = 5;
local xRot = 0;
local yRot = 0;
local LayerManager = require("LayerManager");
local spawnTimer = 0;
local spawnTimer2 = 0;
function Script.update(object, dt)
    spawnTimer = spawnTimer + dt;
    spawnTimer2 = spawnTimer2 + dt;
    local position = object:getLoc();
    
    if spawnTimer > 1 then   
      if math.random(0, 10) > 1 then
        spawnTimer = -5;
        local newprops = require("Generator"):spawnPattern(nil, nil, position.z - 1500);  
        for i = 1, #newprops do
          object:insertPropPersistent(newprops[i]);
          object:insertProp(newprops[i]);
        end
      else     
        spawnTimer = 0;
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
    
	local step = 10;
  local InputManager = require("InputManager");
  local gameVariables = require("GameVariables");  
  if InputManager.Android then
    local move = InputManager.Android.diffAccel;
    local scale = 5;    
    local newPos = {x = position.x + move.y*scale, y =  position.y - move.x*scale, z = position.z};
    local limit = 500;
    
    yRot = yRot - move.y*scale*dt;
    xRot = xRot + move.x*scale*dt;
    
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

    
    if InputManager:isScreenPressed(0) then
      if zPressed < zMax then
        zPressed = zPressed + dt;      
      end
      newPos.z = newPos.z - scale*zPressed;
    else
      if zPressed > 1 then
        zPressed = zPressed * .9;
      else
        zPressed = 1;
      end
      newPos.z = newPos.z - scale*zPressed;
    end
    
    if InputManager:isScreenTriggered(1) then
      InputManager:reCal();
    end	
    object:setRot(xRot, yRot, 0);
    object:setLoc(newPos.x, newPos.y, newPos.z);
    gameVariables:set("Position", newPos);
  end
  
  if InputManager.Keyboard then    
    local scale = 5;    
    local newPos = {x = position.x, y = position.y, z = position.z};
    
    if InputManager:isKeyDown(InputManager.Key['w']) then
      xRot = xRot - scale*dt;
      newPos.y = newPos.y + scale;
    elseif InputManager:isKeyDown(InputManager.Key['s']) then
      xRot = xRot + scale*dt;
      newPos.y = newPos.y - scale;      
    else
      if xRot then
        if xRot < -scale*dt then
          xRot = xRot + scale*dt;
        elseif xRot > scale*dt then
          xRot = xRot - scale*dt;        
        end
      else
        xRot = 0;
      end
    end
    
    if InputManager:isKeyDown(InputManager.Key['d']) then
      yRot = yRot - scale*dt;
      newPos.x = newPos.x + scale;
    elseif InputManager:isKeyDown(InputManager.Key['a']) then
      yRot = yRot + scale*dt;
      newPos.x = newPos.x - scale;
    else
      if yRot then
        if yRot < -scale*dt then
          yRot = yRot + scale*dt;
        elseif yRot > scale*dt then
          yRot = yRot - scale*dt;        
        end
      else
        yRot = 0;
      end
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
    object:setRot(xRot,yRot,0);--newPos.x - position.x, newPos.y - position.y, 0);
    object:setLoc(newPos.x, newPos.y, newPos.z);
    gameVariables:set("Position", newPos);
  end
	
end

return Script;