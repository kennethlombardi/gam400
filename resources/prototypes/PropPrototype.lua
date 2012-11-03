local PropPrototype = {
	underlyingType = nil,
	name = "PropPrototypeName",
	type = "PropPrototypeType",
	position = nil,
}

function PropPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	position = {};
	return object;
end

function PropPrototype:baseFree()
	self.underlyingType = nil;
end

function PropPrototype:free()
	self:baseFree();
end

function PropPrototype:getUnderlyingType()
	return self.underlyingType;
end

function PropPrototype:setName(name)
	self.name = name;
end

function PropPrototype:setType(type)
	self.type = type;
end

function PropPrototype:setUnderlyingType(newObjectReference)
	self.underlyingType = newObjectReference;
end

function PropPrototype:contains(x, y, z)
	print("PropPrototype:contains is UNIMPLEMENTED");
	return 0;
end

return PropPrototype;