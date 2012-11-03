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
	layer1 = require("LayerManager"):createFromFile("pickleFile.lua");

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
	require("LayerManager"):update();
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