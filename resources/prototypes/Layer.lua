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

local function hackLayer(self)
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

    self.layer = layer;
    self.camera = newCamera;
    self.viewport = newViewport;
end

local function serializeLayer(self)
    
end

function Layer:new(object)
    object = object or {};
    setmetatable(object, self);
    self.__index = self;
    hackLayer(object);
    --serializeLayer();
    return object;
end

function Layer:setPosition(x, y)
	local windowManager = require "WindowManager";
	self.camera:setLoc(x, y, self.camera:getFocalLength(windowManager.screenWidth));
end

return Layer;