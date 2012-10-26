local PropPrototype = {
	underlyingType = nil,
	name = "PropPrototypeName",
	type = "PropPrototypeType",
}

function PropPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
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

return PropPrototype;