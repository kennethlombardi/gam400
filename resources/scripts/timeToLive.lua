local Script = {
	name = "timeToLive.lua",
};

function Script.update(object, dt)  
  local objectScl = object:getScl();
  object:setScl(objectScl.x*.8, objectScl.y*.8, objectScl.z*.8);
  if objectScl.x < 10 then
    object:destroy();
  end
end

return Script;