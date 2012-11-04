local LayerManager = {
	layers = {},
	currentLayerIndex = 1,
}

local Factory = require "Factory";

function LayerManager:shutdown()
	for k,v in pairs(self.layers) do
		v:free();
		self.layers[k] = nil;
	end
	self.layers = nil;
end

-- Creates a layer at new index
function LayerManager:createFromFile(layerFileName)
	self.layers[self.currentLayerIndex] = Factory:createFromFile("Layer", layerFileName);
	local layerIndex = self.currentLayerIndex;
	self.currentLayerIndex = self.currentLayerIndex + 1;
	return layerIndex;
end

-- Returns the layer at index
function LayerManager:getAtIndex(layerIndex)
	if self.layers[layerIndex] == nil then
		print("getLayerAtIndex["..layerIndex.."] is nil");
	end
	return self.layers[layerIndex];
end

function LayerManager:update(dt)
	for k,v in pairs(self.layers) do
		v:update(dt);
	end
end

return LayerManager;