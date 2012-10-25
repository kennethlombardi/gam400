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
local MOAIPropCreator = Creator:new();
local MOAILayerCreator = Creator:new();
--

-- PropCreator
function MOAIPropCreator:create(properties)
	local file = assert ( io.open ( 'shader.vsh', mode ))
	vsh = file:read ( '*all' )
	file:close ()

	local file = assert ( io.open ( 'shader.fsh', mode ))
	fsh = file:read ( '*all' )
	file:close ()

	local gfxQuad = MOAIGfxQuad2D.new ()
	gfxQuad:setTexture ( "../textures/moai.png" )
	gfxQuad:setRect ( -64, -64, 64, 64 )
	gfxQuad:setUVRect ( 0, 1, 1, 0 )

	-- create metaball to hook shader to
	local metaball = MOAIMetaBall.new();
	metaball:setDeck(gfxQuad);
	metaball:moveRot(0, 0, 360, 5, MOAIEaseType.LINEAR);
	metaball:setLoc(math.random(-200, 200), math.random(-200, 200), 0);

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

	gfxQuad:setShader ( shader )

	print("Creating prop: "..properties.name);

	return metaball;
end

function MOAIPropCreator:createFromFile(fileName)
	print("Trying to create prop from file");
end
--

-- LayerCreator
function MOAILayerCreator:create(properties)
	print("Creating: "..properties.name);
	print("Type: "..properties.type);
	local layer = require "MOAILayerPrototype";
	local newLayer = layer:new();
	newLayer:setUnderlyingType(MOAILayer.new());
	for k,v in pairs(properties.props) do 
		newLayer:insertProp( Factory:create(v.type, v) );
	end

	-- viewport
    local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- camera
    local newCamera = MOAICamera.new();
    newCamera:setLoc(0, 0, newCamera:getFocalLength(screenWidth));

    -- initialize the layer
    newLayer:setViewport(newViewport);
    newLayer:setCamera(camera);

	return newLayer;
end

function MOAILayerCreator:createFromFile(fileName)
	dofile "Pickle.lua";
	local newObjects = {};
	local objectIndex = 1;
	function deserialize(className, args)
		cucumber = unpickle(args);
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
	Factory:register("Prop", MOAIPropCreator:new());
	Factory:register("Layer", MOAILayerCreator:new());
end

initialize();

return Factory;


