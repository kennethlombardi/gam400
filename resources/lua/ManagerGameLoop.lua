local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
	-- the hack world
	local Factory = require "Factory"
	Input = require "InputManager"

	Editor = require "LevelEditor"
	layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
	layer1:serializeToFile("pickleFileDiff.lua");
	layer1:childCall();
	initialCamPos = layer1:getLoc();

	-- simulation state
	MOAIGfxDevice.setClearDepth ( true );
	
  	print("Initialized");
end

local done = false;
t = 0;
timeStep = .01;
local editMode = false;
function gamesLoop ()
	preInitialize();
	initialize();
	local x = 0;
	local y = 0;
	while not done do
		Input:Update();
		if Input:IsKeyTriggered(Input.Key["esc"]) then --escape
			done = not done;
		end		
		
		if Input:IsKeyTriggered(Input.Key["e"]) then
			editMode = not editMode;
		end
		
		if not editMode then
			t = t + timeStep;
			if (t >= 1) then
				timeStep = timeStep * -1;
			end
			if (t <= 0) then
				timeStep = timeStep * -1;
			end
			
			local z = (1 - t) * 1100 + t * 5000;
			if Input:IsKeyPressed(Input.Key["a"]) then
				x = x - 10;			
			end
			if Input:IsKeyPressed(Input.Key["d"]) then
				x = x + 10;
			end
			if Input:IsKeyPressed(Input.Key["s"]) then
				y = y - 10;			
			end
			if Input:IsKeyPressed(Input.Key["w"]) then
				y = y + 10;
			end
			layer1:setLoc(x, y, z);	-- globally access the layer from init		
			layer1.camera:setRot((360 - Input.Mouse.windowY)/30, (640 - Input.Mouse.windowX)/30, 0);
			
			
		else
			Editor:Update(layer1);			
		end		
		--]]
		
		coroutine.yield()
	end
	os.exit();
end

return gamesLoop;