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
local MOAILayerDDCreator = Creator:new();
local PropPrototypeCreator = Creator:new();
local MOAIPropPrototypeCreator = Creator:new();
local MOAIPropCubeCreator = Creator:new();
local MOAITextBoxCreator = Creator:new();
local MOAIScriptCreator = Creator:new();
local MOAIShaderCreator = Creator:new();
local MOAISphereCreator = Creator:new();
local MOAITorusCreator = Creator:new();
local MOAIModelCreator = Creator:new();
local MOAIMeshCreator = Creator:new();
--

-- MOAILayerDDCreator
function MOAILayerDDCreator:create(properties)
	local layerdd = Factory:create("Layer", properties);
	layerdd:setCamera(MOAICamera2D.new());

	return layerdd;
end
--

-- MOAILayerCreator
function MOAILayerCreator:create(properties)
	local layer = require "MOAILayerPrototype";
	local newLayer = layer:allocate();
	local newMoaiLayer = MOAILayer.new();
	local newMoaiPartition = MOAIPartition.new();
	newMoaiLayer:setPartition(newMoaiPartition);
	newLayer:setUnderlyingType( newMoaiLayer );
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
	newLayer:setLoc(properties.position.x, properties.position.y, properties.position.z);--newCamera:getFocalLength(screenWidth)

	-- scripts
	for k,scriptName in pairs(properties.scripts) do
		newLayer:registerScript(Factory:createFromFile("Script", scriptName))
	end

	return newLayer;
end

function MOAILayerCreator:createFromFile(fileName)
	dofile "Pickle.lua";
	local newObject;
	local objectIndex = 1;
	function deserialize(className, properties)
		local cucumber = unpickle(properties);
		newObject = Factory:create(cucumber.type, cucumber)
		objectIndex = objectIndex + 1;
	end
	local path = "../layers/"..fileName;
	dofile (path)
	if objectIndex > 2 then print("MORE THAN ONE LAYER IN LAYER FILE: "..path) end;
	return newObject;
end
--

-- MOAIMeshCreator
function MOAIMeshCreator:create(properties)
	local ShapesLibrary = require "ShapesLibrary";
	if properties.type == "PropCube" then
		return ShapesLibrary.makeCube(properties.textureName);
	elseif properties.type == "Sphere" then
		return ShapesLibrary.makeSphere(properties.textureName);
	elseif properties.type == "Torus" then
		return ShapesLibrary.makeTorus(properties.textureName);
	end
	return ShapesLibrary.makeCube(properties.textureName);
end
--

-- MOAIModelCreator
function MOAIModelCreator:create(properties)
	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	local cubeMesh = Factory:create("Mesh", {type = properties.type, textureName = properties.textureName});
	local shader = Factory:create("Shader", properties.shaderName);

	propPrototype:setShader(shader, properties.shaderName);
	propPrototype:getUnderlyingType():setDeck(cubeMesh);
	propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
	return propPrototype;
end
--

-- MOAIPropCreator
function MOAIPropCreator:create(properties)
	-- gfx quad with texture
	local gfxQuad = MOAIGfxQuad2D.new ()
	local texture = require("ResourceManager"):load("Texture", properties.textureName);
	gfxQuad:setTexture(texture:getUnderlyingType());
	gfxQuad:setRect(-properties.scale.x, -properties.scale.y, properties.scale.x, properties.scale.y);
	gfxQuad:setUVRect ( 0, 1, 1, 0 )

	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	propPrototype:getUnderlyingType():setDeck(gfxQuad);

	return propPrototype;
end
--

-- MOAIPropCubeCreator
function MOAIPropCubeCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAIPropPrototypeCreator
function MOAIPropPrototypeCreator:create(properties)
	local propPrototype = require "MOAIPropPrototype";
	local newObject = propPrototype:allocate();

	newObject:setUnderlyingType(MOAIProp.new());
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	properties.scale = properties.scale or newObject.scale;
	newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
	newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
	if properties.rotation then
		newObject:setRot(properties.rotation.x, properties.rotation.y, properties.rotation.z);
	end
	newObject:setTextureName(properties.textureName);
	newObject:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);

	-- register scripts
	for k,scriptName in pairs(properties.scripts or {}) do
		newObject:registerScript(Factory:createFromFile("Script", scriptName));
	end

	-- shader
	local shader = Factory:create("Shader", properties.shaderName);
	newObject:setShader(shader, properties.shaderName);

	return newObject;
end
--

-- MOAIPropTorusCreator
function MOAITorusCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAIScriptCreator
function MOAIScriptCreator:create(properties)
	Factory:createFromFile("Script", properties.fileName);
end

function MOAIScriptCreator:createFromFile(fileName)
	return require("ResourceManager"):load("Script", fileName);
end
--

-- MOAIShaderCreator
function MOAIShaderCreator:create(fileName) -- Change this to properties soon
	return require("ResourceManager"):load("Shader", fileName);
end
--

-- MOAISphereCreator
function MOAISphereCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAITextBoxCreator
function MOAITextBoxCreator:create(properties)
	local MOAITextBoxPrototype = require("MOAITextBoxPrototype");
	local newObject = MOAITextBoxPrototype:allocate();
	
	newObject:setUnderlyingType(MOAITextBox.new());
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
	newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
	newObject:setFont(require("ResourceManager"):load("Font", properties.fileName));

	newObject:setTextSize(properties.textSize);
	newObject:setRect( 	properties.rectangle.x1, 
						properties.rectangle.y1, 
						properties.rectangle.x2, 
						properties.rectangle.y2 );
	newObject:getUnderlyingType():setAlignment(MOAITextBox.LEFT_JUSTIFY)
	newObject:getUnderlyingType():setYFlip(true)
	newObject:setText(properties.string);

	for k,scriptName in pairs(properties.scripts) do
		newObject:registerScript(Factory:createFromFile("Script", scriptName));
	end

	return newObject;
end
--

-- PropContainerCreator
function PropContainerCreator:create(properties)
	propContainerPrototype = require "PropContainerPrototype";
	return propContainerPrototype:allocate();
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
	return objectCreators[objectType]:create(properties);
end

function Factory:register(objectType, creator)
	objectCreators[objectType] = creator;
end
--

local function initialize()
	Factory:register("PropPrototype", PropPrototypeCreator:new());
	Factory:register("MOAIPropPrototype", MOAIPropPrototypeCreator:new());
	Factory:register("Prop", MOAIPropCreator:new());
	Factory:register("PropContainer", PropContainerCreator:new());
	Factory:register("Layer", MOAILayerCreator:new());
	Factory:register("LayerDD", MOAILayerDDCreator:new());
	Factory:register("PropCube", MOAIPropCubeCreator:new());
	Factory:register("TextBox", MOAITextBoxCreator:new());
	Factory:register("Script", MOAIScriptCreator:new());
	Factory:register("Shader", MOAIShaderCreator:new());
	Factory:register("Sphere", MOAISphereCreator:new());
	Factory:register("Torus", MOAITorusCreator:new());
	Factory:register("Model", MOAIModelCreator:new());
	Factory:register("Mesh", MOAIMeshCreator:new());
end

initialize();

return Factory;


