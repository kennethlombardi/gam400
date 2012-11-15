local function preInitialize()
	-- require managers to perform singleton initialization
	require "SimulationManager";
	require "WindowManager";
	require "ResourceManager";
	require "LayerManager";
	require("SoundManager");
	require("InputManager");
 	print("PreInitialized");
end

local function initialize()
	require("SimulationManager"):setLeakTrackingEnabled(true);
	require("SimulationManager"):setHistogramEnabled(true);

	-- the hack world
	bg = require("LayerManager"):createLayerFromFile("skyBox.lua");
	layer0 = require("LayerManager"):createLayerFromFile("gameLayer.lua");
	layer1 = require("LayerManager"):createLayerFromFile("gameHud.lua");

	-- simulation state
	MOAIGfxDevice.setClearDepth(true);
	
	-- song
	require("SoundManager"):play("mono16.wav", false);

	-- some variables
	require("gameVariables").gameTimer = 30;

  	print("Initialized");
end

local function preShutdown()
	--require("LayerManager"):getLayerByName("pickleFile0.lua"):serializeToFile("pickleFileDiff0.lua");
	--require("LayerManager"):serializeLayerToFile(require("LayerManager"):getLayerIndexByName("pickleFile1.lua"), "pickleFileDiff1.lua");
end

local function shutdown()
	require("LayerManager"):shutdown();
	require("ResourceManager"):shutdown();
	require("WindowManager"):shutdown();
	require("SoundManager"):shutdown();
	require("ShapesLibrary"):shutdown();
	
	require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):reportLeaks();
	require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):reportHistogram();
	
	require("SimulationManager"):shutdown();
end
local spawnTimer = 0;
local function update(dt)
	require("InputManager"):update(dt);
	require("LayerManager"):update(dt);
	require("SoundManager"):update(dt);
	
	spawnTimer = spawnTimer + dt;
	
	if spawnTimer > 1 then		
		spawnTimer = 0;
		
		local properties = {};
		properties.type = "PropCube";
		properties.name = "NewProp";
		local layerPosition = require("LayerManager"):getLayerByIndex(layer0):getLoc();
		local position = {};
		properties.scale = {x = 10, y = 10, z = 10};		
		position.x = math.random(- 200, 200);
		position.y = math.random(- 200, 200);
		position.z = layerPosition.z - 1500;
		properties.position = position;		
		properties.shaderName = "shader";
		properties.scripts = {"collisionTest.lua"};
		properties.textureName = "rock.png";
		newprop = require("Factory"):create("PropCube", properties);
		require("LayerManager"):getLayerByIndex(layer0):insertPropPersistent(newprop);		
		require("LayerManager"):getLayerByIndex(layer0):insertProp(newprop);
	end
end


local done = false;
function gamesLoop ()
	preInitialize();
	initialize();
	require("InputManager"):reCal();	
	while not done do
		update(require("SimulationManager"):getStep());
		done = require("InputManager"):isKeyTriggered(require("InputManager").Key["esc"]);			
		coroutine.yield()
	end
	
	preShutdown();
	shutdown();
	os.exit();
end

return gamesLoop;