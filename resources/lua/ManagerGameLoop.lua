local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	local Factory = require "Factory"

	local layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
	MOAISim.pushRenderPass(layer1:getUnderlyingType());

	--local layer2 = Factory:createFromFile("Layer", "pickleFileDiff.lua");
	--MOAISim.pushRenderPass(layer2:getUnderlyingType());

	layer1:serializeToFile("../layers/pickleFileDiff.lua");
	--layer2:serializeToFile("../layers/pickleFileDiff.lua");
  	print("Initialized");
end

local done = false;
function gamesLoop ()
	preInitialize();
	initialize();
	while not done do
		coroutine.yield()
	end
end

return gamesLoop;