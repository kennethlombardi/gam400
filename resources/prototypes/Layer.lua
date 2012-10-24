local LayerBase = {
	name = "LayerBase";
	hidden = false;
}

function LayerBase:hide()
	self.hidden = true;
	print("Hiding layer");
end

function LayerBase:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end


-- Layer --
local Layer = LayerBase:new();

function LayerBase:getname()
	return self.name;
end

return Layer;

