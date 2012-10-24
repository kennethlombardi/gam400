local LayerBase = {
	name = "LayerBase";
	hidden = false;
}

function LayerBase:getName()
	return self.name;
end

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
local Layer = LayerBase:new { 
	name = "Layer";
}

return Layer;

