local Script = {
	name = "flyForwardExplodeP.lua",
};
function Script.update(object, dt)  
  local objectPos = object:getLoc();  
  local t = 0;
  if t < 4 then
    objectPos.z = objectPos.z - 100*dt;
    object:setLoc(objectPos.x, objectPos.y, objectPos.z);
    t = t + dt;
  end
  
  if t >= 4 then
    object:destroy();
    require("GameVariables"):add("Timer", 1);
    require("GameVariables"):add("Score", 100);
    --play explosion, show +1
  end    
    
end

return Script;