local Script = {
	name = "oscillate.lua",
};

function Script.update(object, dt)    
  local originalPos = object:getLoc();
  local rndAngle = math.random(0, 359);
  local t = 0;
  local radtodeg = 3.14/180;
  t = t + 10*dt;
  object:setLoc(originalPos.x + 10*math.cos(rndAngle)*math.cos(t*radtodeg) , originalPos.y + 10*math.cos(rndAngle)*math.cos(t*radtodeg), originalPos.z);             
end

return Script;