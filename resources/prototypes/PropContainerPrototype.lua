local PropContainer = {
	props = {};
}

local count = 1;
function PropContainer:insertProp(prop)
	self.props[count] = prop;
	print("Inserting prop into prop container at position:"..count);
	count = count + 1;
end

function PropContainer:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function PropContainer:serialize(properties)
	properties = properties or {};
	for i,v in pairs(self.props) do
		local prop = {
			name = "Storage Prop Number:"..i, 
			type = "Storage Prop Type Test"
		};
		table.insert(properties, prop);
	end
	return properties;
end

return PropContainer;