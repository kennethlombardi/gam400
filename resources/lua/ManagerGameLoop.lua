local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	-- the hack world
	local Factory = require "Factory"
	layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
	layer1:serializeToFile("../layers/pickleFileDiff.lua");

	-- simulation state
	MOAIGfxDevice.setClearDepth ( true );
	
  	print("Initialized");
end

local done = false;
t = 0;
timeStep = .01;
function gamesLoop ()
	preInitialize();
	initialize();
	while not done do
		---[[
		local x = (1 - t) * 400 + t * -400;
		local y = (1 - t) * 0 + t * 0;
		local z = (1 - t) * 1100 + t * 5000;
		layer1:setLoc(0 , y, z);	-- globally access the layer from init
		t = t + timeStep;
		if (t >= 1) then
			timeStep = timeStep * -1;
		end
		if (t <= 0) then
			timeStep = timeStep * -1;
		end
		--]]
		coroutine.yield()
	end
end

return gamesLoop;