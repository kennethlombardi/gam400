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

	-- the hack world
	for i = 1, 30 do
		layer1 = require("LayerManager"):createFromFile("pickleFile.lua");
	end
	
	

	-- simulation state
	MOAIGfxDevice.setClearDepth ( true );
	
  	print("Initialized");
end

local function preShutdown()
	require("LayerManager"):shutdown();
	require("ResourceManager"):shutdown();
	require("WindowManager"):shutdown();
	require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):shutdown();
end

local function shutdown()
	MOAISim.reportLeaks(true);
end

local function update(dt)
	require("InputManager"):Update();
end


local done = false;
function gamesLoop ()
	preInitialize();
	initialize();
	
	while not done do
		update();
		done = require("InputManager"):IsKeyTriggered(require("InputManager").Key["esc"]);
		coroutine.yield()
	end
	preShutdown();
	shutdown();
	os.exit();
end

return gamesLoop;