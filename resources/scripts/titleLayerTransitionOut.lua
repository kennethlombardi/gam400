local Script = {
	name = "titleLayerTransitionOut.lua",
};

function Script.update(object, dt)
	local position = object:getLoc();
	object:setLoc(position.x + 1000 * dt, position.y, position.z);
	if(position.x > 1000) then
		require("MessageManager"):send("LAYER_FINISHED_TRANSITION", object:getName());
	end
end

return Script;