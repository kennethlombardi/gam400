local Layer = require "Layer";

MOAILayerPrototype = Layer:new();

local windowManager = require "WindowManager";

function MOAILayerPrototype:insertProp(prop)
	if self["underlyingType"] == nil then print("Trying to insert prop into MOAILayerPrototype without underlying type"); return; end;
	self["underlyingType"]:insertProp(prop:getUnderlyingType());
end

function MOAILayerPrototype:setCamera(camera)
	if self["underlyingType"] == nil then print("Trying to insert camera into MOAILayerPrototype without underlying type"); return; end;
	self.camera = camera;
	self["underlyingType"]:setCamera(camera);
end

function MOAILayerPrototype:setPosition(x, y)
	getmetatable(self):setPosition(x, y);
	if self.camera ~= nil then
		self.camera:setLoc(x, y, self.camera:getFocalLength(windowManager.screenWidth));
	end
end

function MOAILayerPrototype:setPropContainer(propContainer)
	self.propContainer = propContainer;
	for i,prop in pairs(propContainer.props) do
		self:insertProp(prop);
	end
end

function MOAILayerPrototype:setViewport(viewport)
	if self["underlyingType"] == nil then print("Trying to insert viewport into MOAILayerPrototype without underlying type"); return; end;
	self["underlyingType"]:setViewport(viewport);
end

return MOAILayerPrototype;