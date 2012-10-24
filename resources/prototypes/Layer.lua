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