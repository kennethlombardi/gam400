local PropContainerPrototype = {
	props = nil,
	currentIndex = 1;
}

function PropContainerPrototype:allocate()
	object = PropContainerPrototype:new {
		props = {},
		propsByIndex = {},
		currentIndex = 1,
		propsByName = {},
	}
	return object;
end

function PropContainerPrototype:decorateProp(prop, key, value)
    prop.underlyingType.mark = prop.underlyingType.mark or {};
    prop.underlyingType.mark[key] = value;
end

function PropContainerPrototype:free()
	for k,v in pairs(self.props) do 
		v:free();
		self.props[k] = nil;
	end
	self.props = nil;
end

function PropContainerPrototype:getRawPropDecoration(rawProp, key)
    rawProp.mark = rawProp.mark or {};
    return rawProp.mark[key];
end

function PropContainerPrototype:getPropDecoration(prop, key)
	return self:getRawPropDecoration(prop.underlyingType, key);
end

function PropContainerPrototype:getPropsForRawList(rawList, cookedList)
	local cookedList = cookedList or {};
	for k,v in pairs(rawList) do
		if type(v) ~= "number" then
			local index = self:getRawPropDecoration(v, "index");
			table.insert(cookedList, self.props[index]);
		end
	end
	return cookedList;
end

function PropContainerPrototype:registerPropByName(prop, name)
	self.propsByName[name] = prop;
end

function PropContainerPrototype:insertProp(prop)
	self:registerPropByName(prop, prop:getName());
end

function PropContainerPrototype:insertPropPersistent(prop)
	local index = self:nextIndex();
    self:decorateProp(prop, "index", index);
	table.insert(self.props, index, prop);
	self:registerPropByName(prop, prop:getName());	
end

function PropContainerPrototype:getPropByName(name)
	for k,v in ipairs(self.propsByName) do
		print(k, v);
	end
	return self.propsByName[name];
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

function PropContainerPrototype:removeProp(prop)
	local index = self:getPropDecoration(prop, "index");
	prop:free();
	self.props[index] = nil;
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