screenWidth = MOAIEnvironment.horizontalResolution screenHeight = MOAIEnvironment.verticalResolutionprint("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. MOAIEnvironment.osVersion)
 
require "GameLoop"
local testGameLoop = require "TestGameLoop"
local drawingGameLoop = require "DrawingTestLoop"
-- screen and device size
if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end
assert (not (screenWidth == nil))

-- the main game window
MOAISim.openWindow ("W.A.T.", screenWidth, screenHeight)

local viewport = MOAIViewport.new()
viewport:setScale (screenWidth, screenHeight)
viewport:setSize (screenWidth, screenHeight)

local camera = MOAICamera.new()
camera:setLoc(0,0, camera:getFocalLength(screenWidth))

layer = MOAILayer2D.new()
layer:setViewport (viewport)
layer:setCamera(camera);

-- add layers
MOAISim.pushRenderPass (layer)

local bg = require "background" --put background in
--bg(layer, screenWidth, screenHeight)

-- create and run the game loop thread
local test = true;
mainThread = MOAIThread.new();
if not test then
  mainThread:run(gameLoop);
else
  mainThread:run(drawingGameLoop);
end
