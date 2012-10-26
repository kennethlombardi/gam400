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
	for i = 1, 10 do
		properties[i] = {type = "SERIALIZED PROP TYPE", name = "PROP NUMBER"..i}
	end
	return properties;
end

return PropContainer;