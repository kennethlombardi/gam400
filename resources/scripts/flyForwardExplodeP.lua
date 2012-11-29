local Script = {
	name = "flyForwardExplodeP.lua",
};
function Script.update(object, dt)  
  local objectPos = object:getLoc();  
  objectPos.z = objectPos.z - 2000*dt;
  object:setLoc(objectPos.x, objectPos.y, objectPos.z);  
  local playPos = require("GameVariables"):get("Position");
  if math.abs(objectPos.z - playPos.z) >= 2000 then
    object:clearAllScripts();
    object:destroy();
    require("GameVariables"):add("Timer", 3);  
    require("MessageManager"):send("ADD_TIMER", objectPos);
    --play explosion, show +1
  end    
    
end

return Script;