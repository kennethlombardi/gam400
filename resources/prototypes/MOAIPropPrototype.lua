local PropPrototype = require "PropPrototype";

local MOAIPropPrototype = PropPrototype:new();

function MOAIPropPrototype:allocate()
	object = MOAIPropPrototype:new{
		position = {x = 0, y = 0, z = 0},
		scale = {x = 1, y = 1, z = 1}
	}
	return object;
end

function MOAIPropPrototype:contains(x, y, z)
	return self.underlyingType:inside(x, y, z);
end

function MOAIPropPrototype:setName(name)
	self.name = name;
end

function MOAIPropPrototype:setLoc(newX, newY, newZ)
	self:baseSetLoc(newX, newY, newZ);
	self.underlyingType:setLoc(newX, newY, newZ);
end

function MOAIPropPrototype:update(dt)
	self:baseUpdate(dt);
end

return MOAIPropPrototype;