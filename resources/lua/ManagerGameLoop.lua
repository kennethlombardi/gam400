local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	-- the hack world
	local Factory = require "Factory"
	if MOAIInputMgr.device.pointer then			
		Mouse = require "MouseInput";
	end
	if MOAIInputMgr.device.keyboard then
		Keyboard = require "KeyboardInput";
	end
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
	local x = 0;
	local y = 0;
	while not done do
		---[[
		--(1 - t) * 400 + t * -400;
		-- (1 - t) * 0 + t * 0;
		local z = (1 - t) * 1100 + t * 5000;
		if Keyboard:IsKeyPressed("a") then
			x = x - 10;			
		end
		if Keyboard:IsKeyPressed("d") then
			x = x + 10;
		end
		if Keyboard:IsKeyPressed("s") then
			y = y - 10;			
		end
		if Keyboard:IsKeyPressed("w") then
			y = y + 10;
		end
		layer1:setLoc(x , y, z);	-- globally access the layer from init
		Mouse.Update(layer1);
		layer1.camera:setRot((360 - Mouse.windowY)/30, (640 - Mouse.windowX)/30, 0);
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