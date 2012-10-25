local Factory = {
	
};

objectCreators = {}

local Creator = {}

function Creator:new(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self;
	return object;
end

-- custom creators
local PropCreator = Creator:new();
local LayerCreator = Creator:new();

-- PropCreator
function PropCreator:create(properties)
	print("Created prop");
	return MOAIProp.new();
end
--

-- LayerCreator
function LayerCreator:create(properties)
	properties = properties or "nil";
	print("Created layer with properties: "..properties.name);
	return MOAILayer.new();
end
--

function Factory:create(object, properties)
	return objectCreators[object]:create(properties);
end

function Factory:register(type, creator)
	objectCreators[type] = creator;
end

local function initialize()
	Factory:register("Prop", PropCreator:new());
	Factory:register("Layer", LayerCreator:new());
end

initialize();

return Factory;


