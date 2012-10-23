local screenWidth = MOAIEnvironment.horizontalResolution 
local screenHeight = MOAIEnvironment.verticalResolution
print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. MOAIEnvironment.osVersion)


-- screen and device size
if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end
assert (not (screenWidth == nil))

-- the main game window
MOAISim.openWindow ("W.A.T.", screenWidth, screenHeight)

layerManager = require "LayerManager"
layer = layerManager.getLayerAtIndex(layerManager.createLayer());


-- add layers
MOAISim.pushRenderPass (layer)

local bg = require "background" --put background in
bg(layer, screenWidth, screenHeight)

-- create and run the game loop thread
gameLoop = require "GameLoop"
drawingGameLoop = require "DrawingTestLoop"
local test = true;
mainThread = MOAIThread.new();
if not test then
  mainThread:run(gameLoop);
else
  mainThread:run(drawingGameLoop);
end
