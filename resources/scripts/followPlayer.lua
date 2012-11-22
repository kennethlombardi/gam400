local Script = {
	name = "followPlayer.lua",
};


function Script.update(object, dt)
	local rotation = object:getRot();
	object:setRot(rotation.x, rotation.y + 30 * dt, rotation.z);
  local position = GameVariables:GetPlayerPos();
  object:setLoc(position.x, position.y, position.z - 5);
end

return Script;