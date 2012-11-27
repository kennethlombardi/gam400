local Script = {
	name = "earthSpinning.lua",
};

function Script.update(object, dt)
	local rotation = object:getRot();
	object:setRot(rotation.x, rotation.y + 5 * dt, rotation.z);
  local position = object:getLoc();
  object:setLoc(position.x, position.y, require("GameVariables"):get("Position").z - 7000);
end

return Script;