local PropPrototype = {
	underlyingType = nil,
	name = "PropPrototypeName",
	type = "PropPrototypeType",
	scale = {x = 1, y = 1, z = 1},
	position = {x = 0, y = 0, z = 0},
}

function PropPrototype:baseUpdate(dt)

end

function PropPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function PropPrototype:baseFree()
	self.underlyingType = nil;
end

function PropPrototype:baseSetLoc(x, y, z)
	self.position.x = x;
	self.position.y = y;
	self.position.z = z;
end

function PropPrototype:baseSetScale(x, y, z)
	self.scale.x = x;
	self.scale.y = y;
	self.scale.z = z;
end

function PropPrototype:contains(x, y, z)
	print("PropPrototype:contains is UNIMPLEMENTED");
	return 0;
end

function PropPrototype:free()
	self:baseFree();
end

function PropPrototype:getUnderlyingType()
	return self.underlyingType;
end

function PropPrototype:setLoc(x, y, z)
	self:baseSetLoc(x, y, z);
end

function PropPrototype:setName(name)
	self.name = name;
end

function PropPrototype:setScale(x, y, z)
	self:baseSetScale(x, y, z);
end

function PropPrototype:setType(type)
	self.type = type;
end

function PropPrototype:setUnderlyingType(newObjectReference)
	self.underlyingType = newObjectReference;
end

function PropPrototype:update(dt)
	self:baseUpdate(dt);
end

return PropPrototype;