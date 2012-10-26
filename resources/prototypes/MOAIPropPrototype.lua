local PropPrototype = require "PropPrototype";

local MOAIPropPrototype = PropPrototype:new();

--[[
function MOAIPropPrototype:setName()
	print("Called MOAIPropPrototype:setName");
	getmetatable(PropPrototype):setName(name);
end
--]]

function MOAIPropPrototype:setPosition(newX, newY, newZ)
	self.position = {x = newX, y = newY}
	self.underlyingType:setLoc(newX or 0, newY or 0, newZ or 0);
end

return MOAIPropPrototype;