local Script = {
	name = "speedline.lua",
};
function Script.update(object, dt)  
  local objectScl = object:getScl();    
  Input = require("InputManager");
  local scale = 5;
  local limit = 5000;
  if Input.Keyboard then
    if Input:isKeyDown(Input.Key['SPACE']) then
      if objectScl.y < limit then
        object:setScl(objectScl.x, objectScl.y *1.2, objectScl.z);
      end
    else
      if objectScl.y > scale then
        object:setScl(objectScl.x, objectScl.y*.8, objectScl.z);
      end
    end
  elseif Input.Android then
    if Input:isScreenDown(0) then
      if objectScl.y < limit then
        object:setScl(objectScl.x, objectScl.y *1.2, objectScl.z);
      end
    else
      if objectScl.y > scale then
        object:setScl(objectScl.x, objectScl.y*.8, objectScl.z);
      end
    end
  end
  -- do a check to delete once they are flown by
  local objectPos = object:getLoc();  
  local playerPosition = gameVariables:get("Position");
  local diff = {};    
  
  diff.z = objectPos.z - playerPosition.z;
  diff.x = objectPos.x - playerPosition.x;
  diff.y = objectPos.y - playerPosition.y;
    
  if diff.z > 30 then  --past object
    --need to register message with layer to delete object, would be better
    --require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removeProp(object);
    --require("LayerManager"):getLayerByIndex(require("GameVariables"):GetLayer()):removePropPersistent(object);		         
    return;
  end
end

return Script;