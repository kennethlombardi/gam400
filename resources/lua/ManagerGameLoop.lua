local function preInitialize()
	-- require managers to perform singleton initialization
	require "SimulationManager";
	require "WindowManager";
	require "ResourceManager";
	require "LayerManager";
	
 	print("PreInitialized");
end

local function initialize()
	require("SimulationManager"):setLeakTrackingEnabled(true);
	require("SimulationManager"):setHistogramEnabled(true);

	-- the hack world
	layer0 = require("LayerManager"):createLayerFromFile("pickleFile0.lua");
	layer1 = require("LayerManager"):createLayerFromFile("pickleFile1.lua");

	-- simulation state
	MOAIGfxDevice.setClearDepth ( true );
	
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
	require("ShapesLibrary"):shutdown();
		
	require("SimulationManager"):reportHistogram();
	require("SimulationManager"):reportLeaks();
	require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):shutdown();
end

local function update(dt)
	require("InputManager"):Update(dt);
	require("LayerManager"):update(dt);
end


local done = false;
function gamesLoop ()
	preInitialize();
	initialize();
	
	while not done do
		update(require("SimulationManager"):getStep());
		done = require("InputManager"):IsKeyTriggered(require("InputManager").Key["esc"]);
		coroutine.yield()
	end
	preShutdown();
	shutdown();
	os.exit();
end

return gamesLoop;