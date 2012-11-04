local Script = {
	name = "LayerMovement.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	local step = 10;
	object:setLoc(position.x + step, position.y, position.z);
end

return Script;