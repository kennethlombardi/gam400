local Script = {
	name = "PropMovement.lua",
};

local t = 0;
function Script.update(object, dt)
	local endPoint = {x = 300, y = 300, z = 0};
	local startPoint = {x = 0, y = 0, z = 0};
	local position = object:getLoc();

	t = t + dt;
	if t >= 1 then t = 0 end;
	local x = (1 - t) * startPoint.x + t * endPoint.x;
	object:setLoc(x, position.y, position.z); 
end

return Script;