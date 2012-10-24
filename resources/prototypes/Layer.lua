local Layer = {
    name = "Layer";
    hidden = false;
}

function Layer:getName()
    return self.name;
end

function Layer:hide()
    self.hidden = true;
    print("Hiding layer");
end

local function hackLayer()
	-- layer viewport
	local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- layer camera
    local newCamera = MOAICamera.new();
    newCamera:setLoc(0, 0, newCamera:getFocalLength(screenWidth));

    local layer = MOAILayer.new();
    layer:setViewport(newViewport);
    layer:setCamera(newCamera);

    return layer;
end

function Layer:new(object)
    object = object or {};
    setmetatable(object, self);
    self.__index = self;
    self.layer = hackLayer();
    return object;
end

return Layer;

--[[
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
]]