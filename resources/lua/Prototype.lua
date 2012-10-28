
local Mouse;
local Keyboard;
local layerManager = require "LayerManager"
local windowManager = require "WindowManager";
local backgroundLayerIndex = layerManager:createLayer();
local backgroundLayer = layerManager:getLayerAtIndex(backgroundLayerIndex);
MOAISim.pushRenderPass(backgroundLayer.layer);
local bg = require "background";
local foregroundLayerIndex = layerManager:createLayer();
local foregroundLayer = layerManager:getLayerAtIndex(foregroundLayerIndex);
bg(foregroundLayer.layer, windowManager.screenWidth, windowManager.screenHeight);
MOAISim.pushRenderPass(foregroundLayer.layer);
local camera;

local function Initialize()

	local BoxManager = require "BoxMesh";
	local mesh = BoxManager.makeCube(128, '../textures/moai.png')
	local prop = MOAIProp.new()
    prop:setDeck(mesh)
    prop:setLoc(0, 0)
    --prop:moveRot(0, 2160, 0, 120)
	--prop:setPiv(100,0,0);
    prop:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
    prop:setCullMode ( MOAIProp.CULL_BACK )
    foregroundLayer.layer:insertProp ( prop )
	camera = MOAICamera.new()
	camera:setLoc(0,0, camera:getFocalLength(windowManager.screenWidth))
	foregroundLayer.layer:setCamera(camera)
	print("Initialized");
	if MOAIInputMgr.device.pointer then			
		Mouse = require "MouseInput";
	end
	if MOAIInputMgr.device.keyboard then
		Keyboard = require "KeyboardInput";
	end
end



local done = false
local function gamesLoop()
	Initialize();

	while not done do
		Mouse.Update(foregroundLayer.layer, camera);
		for i = 1, 255, 1 do
			if Keyboard.IsKeyTriggered(i) then
				print(i);
			end
		end
		coroutine.yield()
	end
end

return gamesLoop;
