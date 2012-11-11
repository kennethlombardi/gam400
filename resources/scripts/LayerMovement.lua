local Script = {
	name = "LayerMovement.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	local step = 10;
  local InputManager = require("InputManager");
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
      newPos.z = newPos.z - scale;
    end
    
    if InputManager:isScreenTriggered(1) then
      InputManager:reCal();
    end	
    
    object:setLoc(newPos.x, newPos.y, newPos.z);
  end
	
end

return Script;