local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initialize()
		MOAISim.setLeakTrackingEnabled(true);
	-- the hack world
	Factory = require "Factory"
	Input = require "InputManager"

	Editor = require "LevelEditor"
	layer1 = Factory:createFromFile("Layer", "pickleFile0.lua");
	
	local bgprop = {};
	bgprop.position = {};
	bgprop.position.x = 0;
	bgprop.position.y = 0;
	bgprop.position.z = -2000;
	bgprop.scale =  {};
	bgprop.scale.x = 5000;
	bgprop.scale.y = 5000;
	bgprop.bg = 1;
	bg = Factory:create("Prop", bgprop)
	layer1:insertProp(bg);	
	
	initialCamPos = layer1:getLoc();
	initialCamPos.z = 5000;
	layer1:setLoc(initialCamPos.x, initialCamPos.y, initialCamPos.z);
	-- simulation state
	MOAIGfxDevice.setClearDepth ( true );
	
  	print("Initialized");
end

local function update(dt)
	Input:Update();
end

local done = false;
t = 0;
timeStep = .01;
local editMode = false;
function gamesLoop ()
	preInitialize();
	initialize();
	local x = initialCamPos.x;
	local y = initialCamPos.y;
	local z = initialCamPos.z;
	while not done do
		bg:setLoc(x, y, z - 5000);
		update();
		if Input:IsKeyTriggered(Input.Key["esc"]) then --escape
			done = not done;
		end		
		
		if Input:IsKeyTriggered(Input.Key["e"]) then
			editMode = not editMode;
		end
		
		if Input:IsKeyTriggered(Input.Key["r"]) then
			x = initialCamPos.x; 
			y = initialCamPos.y;
			z = initialCamPos.z;	
		end
		
		if not editMode then
			t = t + timeStep;
			if (t >= 1) then
				local newproperties = {};
				newproperties.type = "PropCube";
				newproperties.name = "NewProp";
				newproperties.position = {};
				newproperties.position.x = math.random(-500, 500);
				newproperties.position.y = math.random(-500, 500);
				newproperties.position.z = z - 6000;
				newproperties.scale = {x = 100, y = 100, z = 100};
				layer1:insertPropPersistent(Factory:create("PropCube", newproperties));
				t = 0;				
			end
		
			if Input:IsKeyPressed(Input.Key["SPACE"]) then
				z = z - 10
			end
			z = z - 10			
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
			layer1:setLoc(x, y, z);
			layer1.camera:setRot((360 - Input.Mouse.windowY)/30, (640 - Input.Mouse.windowX)/30, 0);
			
			
		else
			Editor:Update(layer1);			
		end		
		
		coroutine.yield()
	end

	 	MOAISim.reportLeaks(true);
	os.exit();
end

return gamesLoop;