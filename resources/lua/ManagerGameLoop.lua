local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	local Factory = require "Factory"

	layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
	layer1:serializeToFile("../layers/pickleFileDiff.lua");
  	print("Initialized");
end

local done = false;
i = 0;
visible = false;
function gamesLoop ()
	preInitialize();
	initialize();
	while not done do
		coroutine.yield()
	end
end

return gamesLoop;