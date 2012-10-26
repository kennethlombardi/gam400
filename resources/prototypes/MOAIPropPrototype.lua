local PropPrototype = require "PropPrototype";

local MOAIPropPrototype = PropPrototype:new();

---[[
function MOAIPropPrototype:setName(name)
	self.name = name;
end
--]]

function MOAIPropPrototype:setLoc(newX, newY, newZ)
	self.position = {x = newX, y = newY, z = newZ}
	self.underlyingType:setLoc(newX or 0, newY or 0, newZ or 0);
end

return MOAIPropPrototype;