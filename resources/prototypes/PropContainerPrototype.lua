local PropContainer = {
	props = {};
}

function PropContainer:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function PropContainer:serialize(properties)
	properties = properties or {};
	properties.type = "SERIALIZED PROP";
	properties.name = "SERIALIZED PROP NAME";
	return properties;
end

return PropContainer;