local Layer = require "Layer";

MOAILayerPrototype = Layer:new();

local windowManager = require "WindowManager";

function MOAILayerPrototype:insertProp(prop)
	table.insert(self["props"], prop);
	if self["underlyingType"] == nil then print("Trying to insert prop into MOAILayerPrototype without underlying type"); return; end;
	self["underlyingType"]:insertProp(prop);
end

function MOAILayerPrototype:setCamera(camera)
	if self["underlyingType"] == nil then print("Trying to insert camera into MOAILayerPrototype without underlying type"); return; end;
	self["underlyingType"]:setCamera(camera);
end

function MOAILayerPrototype:setPosition(x, y)
	self.camera:setLoc(x, y, self.camera:getFocalLength(windowManager.screenWidth));
end

function MOAILayerPrototype:setViewport(viewport)
	if self["underlyingType"] == nil then print("Trying to insert viewport into MOAILayerPrototype without underlying type"); return; end;
	self["underlyingType"]:setViewport(viewport);
end



return MOAILayerPrototype;