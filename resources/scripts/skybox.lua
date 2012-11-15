local Script = {
	name = "LayerMovement.lua",
};
local zPressed = 1;
local zMax = 5;
function Script.update(object, dt)
	local position = object:getLoc();
	--object:setLoc(position.x, position.y, position.z - dt * 30);
end

return Script;