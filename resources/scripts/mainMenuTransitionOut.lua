local Script = {
	name = "titleLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x, position.y - 1000 * dt, position.z);
end

return Script;