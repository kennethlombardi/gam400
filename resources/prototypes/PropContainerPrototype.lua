local PropContainerPrototype = {
	props = nil;
}

function PropContainerPrototype:free()
	for k,v in pairs(self.props) do 
		v:free();
		self.props[k] = nil;
	end
	self.props = nil;
end

function PropContainerPrototype:insertProp(prop)
	table.insert(self.props, prop);
end

function PropContainerPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	object.props = {};
	return object;
end

function PropContainerPrototype:serialize(properties)
	properties = properties or {};
	for i,v in pairs(self.props) do
		table.insert(properties, v:serialize());
	end
	return properties;
end

function PropContainerPrototype:update(dt)
	for k,v in pairs(self.props) do
		v:update(dt);
	end
end

return PropContainerPrototype;