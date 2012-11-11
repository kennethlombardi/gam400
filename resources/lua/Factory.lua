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

-- MOAIPropCreator
function MOAIPropCreator:create(properties)
	local file = assert ( io.open ( 'shader.vsh', mode ))
	vsh = file:read ( '*all' )
	file:close ()

	local file = assert ( io.open ( 'shader.fsh', mode ))
	fsh = file:read ( '*all' )
	file:close ()

	local gfxQuad = MOAIGfxQuad2D.new ()	
	gfxQuad:setTexture(require("ResourceManager"):load("Texture", "spacebox/space_front5.png"));
	gfxQuad:setRect ( -64, -64, 64, 64 )
	if type(properties.scale) == 'table' then
		gfxQuad:setRect(-properties.scale.x, -properties.scale.y, properties.scale.x, properties.scale.y);
	end	
	gfxQuad:setUVRect ( 0, 1, 1, 0 )

	-- create prop to hook shader to	
	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	propPrototype:setLoc(properties.position.x, properties.position.y, properties.position.z);
	propPrototype:getUnderlyingType():setDeck(gfxQuad);
	propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
	if type(properties.rotation) == 'table' then
		propPrototype:getUnderlyingType():setRot(properties.rotation.x, properties.rotation.y, properties.rotation.z);
	end

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
	
	-- scripts
	for k,scriptName in pairs(properties.scripts or {}) do
		propPrototype:registerScript(Factory:createFromFile("Script", scriptName));
	end

	if properties.shaderName ~= "skybox" then
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
	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	local ShapeLibrary = require "ShapesLibrary";

	properties.scale = properties.scale or propPrototype.scale;
	local cubeMesh = ShapeLibrary.makeCube("../textures/moai.png");

	local shader = Factory:create("Shader", properties.shaderName);
	cubeMesh:setShader(shader);
	propPrototype:setShaderName(properties.shaderName);
	
	--cubeMesh:setShader(MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
	--propPrototype:getUnderlyingType():moveScl(100, 100, 100, 5);
	--propPrototype:getUnderlyingType():moveRot(1080, 1080, 1080, 20);
	
	propPrototype:getUnderlyingType():setDeck(cubeMesh);
	propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
	propPrototype:setScl(properties.scale.x, properties.scale.y, properties.scale.z);

	
	return propPrototype;
end

function MOAIPropCubeCreator:createFromFile(filename)
	
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
	newObject:setScale(properties.scale.x, properties.scale.y, properties.scale.z);
	newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
	
	-- register scripts
	for k,scriptName in pairs(properties.scripts or {}) do
		newObject:registerScript(Factory:createFromFile("Script", scriptName));
	end

	return newObject;
end
--

-- MOAIScriptCreator
function MOAIScriptCreator:create(properties)
	print("MOAIScriptCreator:create is UNIMPLEMENTED");
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

-- MOAITextBoxCreator
function MOAITextBoxCreator:create(properties)
	local MOAITextBoxPrototype = require("MOAITextBoxPrototype");
	local newObject = MOAITextBoxPrototype:allocate();
	
	newObject:setUnderlyingType(MOAITextBox.new());
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	newObject:setScale(properties.scale.x, properties.scale.y, properties.scale.z);
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
end

initialize();

return Factory;


