local Script = {
	name = "starfieldLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x, position.y, position.z - 3000 * dt);
	if position.z > 3000 then
		require("MessageManager"):send("LAYER_FINISHED_TRANSITION", object:getName());
	end
end

return Script;