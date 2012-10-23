local LayerManager = {};
local layers = {};
local currentLayerIndex = 1;

local function createCamera()
	return MOAICamera.new();
end

local function createCameraInLayer(layerIndex)
	-- if the layer doesn't exist
	if layers[layerIndex] == nil then
		print("Layer at index "..layerIndex.."does not exist.");
		return;
	end

	-- if there is already a camera on the layer
	-- -- TODO destroy old camera
	local windowManager = require "WindowManager";
	local screenWidth = windowManager.screenWidth;
	local newCamera = createCamera();
	newCamera:setLoc(0, 0, newCamera:getFocalLength(screenWidth));

	layers[layerIndex].camera = newCamera;
	layers[layerIndex]:setCamera(newCamera);
end

-- Creates and returns a new viewport
local function createViewport()
	return MOAIViewport.new();
end

-- Creates a new viewport
-- Adds new viewport to layer
local function createViewportInLayer(layerIndex)
	if layers[layerIndex] == nil then
		print("Cannot create viewport in layer index "..layerIndex);
		print("Layer does not exist");
		return;
	end

	-- TODO If layer already has viewport add another one
	local windowManager = require "WindowManager";
	local screenWidth = windowManager.screenWidth;
	local screenHeight = windowManager.screenHeight;
	local newViewport = createViewport();
	newViewport:setSize(screenWidth, screenHeight);
	newViewport:setScale(screenWidth, screenHeight);
	layers[layerIndex].viewport = newViewport;
	layers[layerIndex]:setViewport(newViewport);
end

-- Creates a layer at new index
-- Adds a camera to layer
local function createLayer()
	layers[currentLayerIndex] = MOAILayer.new();
	local layerIndex = currentLayerIndex;
	currentLayerIndex = currentLayerIndex + 1;
	createCameraInLayer(layerIndex);
	createViewportInLayer(layerIndex);
	return layerIndex;
end

-- Returns the layer at index
local function getLayerAtIndex(layerIndex)
	if layers[layerIndex] == nil then
		print("getLayerAtIndex["..layerIndex.."] is nil");
	end
	return layers[layerIndex];
end

LayerManager.createLayer = createLayer;
LayerManager.getLayerAtIndex = getLayerAtIndex;

return LayerManager;