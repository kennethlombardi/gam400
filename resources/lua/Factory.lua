local Factory = {};
local objectCreators = {}
local Creator = {}

function Creator:new(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self;
	return object;
end

-- custom creators
local MOAIPropCreator = Creator:new();
local PropContainerCreator = Creator:new();
local MOAILayerCreator = Creator:new();
local PropPrototypeCreator = Creator:new();
local MOAIPropPrototypeCreator = Creator:new();
local MOAIPropCubeCreator = Creator:new();
--

-- MOAILayerCreator
function MOAILayerCreator:create(properties)
	print("Creating: "..properties.name);
	print("Type: "..properties.type);
	local layer = require "MOAILayerPrototype";
	local newLayer = layer:new();
	newLayer:setUnderlyingType( MOAILayer.new() );
	local propContainer = Factory:create("PropContainer");

	-- fill the prop container then insert into layer
	for k,v in pairs(properties.propContainer) do 
		local newProp = Factory:create(v.type, v);
		propContainer:insertProp( newProp );
	end
	newLayer:setPropContainer( propContainer );

	-- viewport
    local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- camera
    local newCamera = MOAICamera.new();
    
    -- initialize the layer
    newLayer:setViewport(newViewport);
    newLayer:setCamera(newCamera);
    newLayer:setName(properties.name);
    newLayer:setType(properties.type);
    newLayer:setVisible(properties.visible == "true");
	newLayer:setLoc(properties.position.x, properties.position.y, newCamera:getFocalLength(screenWidth));

	return newLayer;
end

function MOAILayerCreator:createFromFile(fileName)
	dofile "Pickle.lua";
	local newObjects = {};
	local objectIndex = 1;
	function deserialize(className, properties)
		cucumber = unpickle(properties);
		newObjects[objectIndex] = self:create(cucumber)
		objectIndex = objectIndex + 1;
		print(cucumber.name);
	end
	local path = "../layers/"..fileName;
	dofile (path)
	if objectIndex > 2 then print("MORE THAN ONE LAYER IN LAYER FILE: "..path) end;
	return newObjects[1];
end
--

local ResourceManager = require("ResourceManager");
local texture = ResourceManager:load("Texture", "spacebox/space_front5.png");


-- MOAIPropCreator
function MOAIPropCreator:create(properties)
	local file = assert ( io.open ( 'shader.vsh', mode ))
	vsh = file:read ( '*all' )
	file:close ()

	local file = assert ( io.open ( 'shader.fsh', mode ))
	fsh = file:read ( '*all' )
	file:close ()

	local gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture(texture);
	gfxQuad:setRect ( -64, -64, 64, 64 )
	if properties.scale then
		gfxQuad:setRect(-properties.scale.x, -properties.scale.y, properties.scale.x, properties.scale.y);
	end
	gfxQuad:setUVRect ( 0, 1, 1, 0 )

	-- create prop to hook shader to	
	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	propPrototype:setLoc(properties.position.x, properties.position.y, properties.position.z);
	--hack initialize prop without mirroring and hiding internal functionality of underlying type
	propPrototype:getUnderlyingType():setDeck(gfxQuad);
	--propPrototype:getUnderlyingType():moveRot(0, 0, 1500, 30, MOAIEaseType.LINEAR);
	propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);

	local color = MOAIColor.new ()
	color:setColor ( 0, 0, 1, 0 )
	color:seekColor(1, 1, 1, 1, 5, MOAIEaseType.LINEAR);

	local shader = MOAIShader.new ()
	shader:reserveUniforms ( 1 )
	shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )
	shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )
	shader:setVertexAttribute ( 1, 'position' )
	shader:setVertexAttribute ( 2, 'uv' )
	shader:setVertexAttribute ( 3, 'color' )	
	shader:load ( vsh, fsh )
	

	if not properties.bg then
		gfxQuad:setShader ( shader )
	end

	return propPrototype;
end

function MOAIPropCreator:createFromFile(fileName)
	print("Trying to create prop from file? Maybe soon.");
end
--

-- MOAIPropCubeCreator
function MOAIPropCubeCreator:create(properties)
	local BoxMesh = require "BoxMesh";
	local cubeMesh = BoxMesh.makeCube(50, "../textures/moai.png");
	local prop = Factory:create("Prop", properties);
	prop:getUnderlyingType():setDeck(cubeMesh);
	return prop;
end

function MOAIPropCubeCreator:createFromFile(filename)
	
end
--

-- MOAIPropPrototypeCreator
function MOAIPropPrototypeCreator:create(properties)
	local propPrototype = require "MOAIPropPrototype";
	local newObject = propPrototype:new();
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	newObject:setUnderlyingType(MOAIProp.new());
	return newObject;
end
--

-- PropContainerCreator
function PropContainerCreator:create(properties)
	propContainerPrototype = require "PropContainerPrototype";
	return propContainerPrototype:new();
end
--

-- PropPrototypeCreator
function PropPrototypeCreator:create(properties)
	local propPrototype = require "PropPrototype";
	local newObject = propPrototype:new();
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	return newObject;
end
--

-- Factory methods
function Factory:createFromFile(objectType, fileName)
	return objectCreators[objectType]:createFromFile(fileName);
end

function Factory:create(objectType, properties)
	print("Factory:create("..objectType..")");
	return objectCreators[objectType]:create(properties);
end

function Factory:register(objectType, creator)
	objectCreators[objectType] = creator;
end
--

local function initialize()
	Factory:register("PropPrototype", PropPrototypeCreator:new());
	Factory:register("Prop", MOAIPropCreator:new());
	Factory:register("PropContainer", PropContainerCreator:new());
	Factory:register("Layer", MOAILayerCreator:new());
	Factory:register("MOAIPropPrototype", MOAIPropPrototypeCreator:new());
	Factory:register("MOAIPropCube", MOAIPropCubeCreator:new());
end

initialize();

return Factory;


