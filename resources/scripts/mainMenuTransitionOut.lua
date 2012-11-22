local Script = {
	name = "titleLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x + 1000 * dt, position.y, position.z);
end

return Script;