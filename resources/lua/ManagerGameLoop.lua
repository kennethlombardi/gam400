local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	local Factory = require "Factory"
	--local layer =  Factory:createFromFile("Layer", "pickleFile.lua");
	--layer:serializeToFile("../layers/pickleFileDiff.lua");
	--MOAISim.pushRenderPass(layer:getUnderlyingType());
	local layer = Factory:createFromFile("Layer", "pickleFileDiff.lua");
	MOAISim.pushRenderPass(layer:getUnderlyingType());
	--layer:serializeToFile("../layers/pickleFileDiffDiff.lua");
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