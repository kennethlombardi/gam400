local Script = {
	name = "earthSpinning.lua",
};


function Script.update(object, dt)
	local rotation = object:getRot();
	object:setRot(rotation.x, rotation.y + 30 * dt, rotation.z);
end

return Script;