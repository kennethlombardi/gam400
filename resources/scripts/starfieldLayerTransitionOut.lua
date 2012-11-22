local Script = {
	name = "starfieldLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x, position.y, position.z + 3000 * dt);
end

return Script;