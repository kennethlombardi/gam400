local LayerManager = {
	layers = {},
	currentLayerIndex = 1,
}

local Factory = require "Factory";

-- Creates a layer at new index
-- Adds a camera to layer
function LayerManager:createLayerFromFile(layerFileName)
	self.layers[self.currentLayerIndex] = Factory:create("Layer", layerFileName);
	local layerIndex = self.currentLayerIndex;
	self.currentLayerIndex = self.currentLayerIndex + 1;
	return layerIndex;
end

-- Returns the layer at index
function LayerManager:getLayerAtIndex(layerIndex)
	if self.layers[layerIndex] == nil then
		print("getLayerAtIndex["..layerIndex.."] is nil");
	end
	return self.layers[layerIndex];
end

return LayerManager;