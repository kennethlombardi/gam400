local PropContainerPrototype = {
	props = nil,
	propsByIndex = {},
	currentIndex = 1;
}

function PropContainerPrototype:decorate(prop, key, value)
    prop.mark = prop.mark or {};
    prop.mark[key] = value;
end

function PropContainerPrototype:free()
	for k,v in pairs(self.props) do 
		v:free();
		self.props[k] = nil;
	end
	self.props = nil;
end

function PropContainerPrototype:getPropDecoration(prop, key)
    prop.mark = prop.mark or {};
    return prop.mark[key];
end

function PropContainerPrototype:insertProp(prop)
	local index = self:nextIndex();
    self:decorate(prop, "index", index);
    self.propsByIndex[index] = prop;
	table.insert(self.props, index, prop);
end

function PropContainerPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	object.props = {};
	return object;
end

function PropContainerPrototype:nextIndex()
    local index = self.currentIndex;
    self.currentIndex = index + 1;
    return index;
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