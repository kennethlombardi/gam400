local LayerManager = {
	layers = {},
	indicesByName = {},
	currentLayerIndex = 1,
}

local Factory = require "Factory";

function LayerManager:createFromFile(layerFileName)
	self.layers[self.currentLayerIndex] = Factory:createFromFile("Layer", layerFileName);
	local layerIndex = self.currentLayerIndex;
	self.currentLayerIndex = self.currentLayerIndex + 1;

	-- Save the layer name as a hash for the index to allow quick retrieval of layers by name
	self.indicesByName[layerFileName] = layerIndex;
	return layerIndex;
end

function LayerManager:getAtIndex(layerIndex)
	if self.layers[layerIndex] == nil then
		print("getLayerAtIndex["..layerIndex.."] is nil");
	end
	return self.layers[layerIndex];
end

function LayerManager:getIndexByName(layerName)
	return self.indicesByName[layerName];
end

function LayerManager:getLayerByName(layerName)
	return self:getAtIndex(self.indicesByName[layerName]);
end

function LayerManager:serializeToFile(layerIndex, fileName)
	if self.layers[layerIndex] == nil then
		print("serializeToFile["..layerIndex.."] is nil");
		return;
	end
	self.layers[layerIndex]:serializeToFile(fileName);
end

function LayerManager:shutdown()
	for k,v in pairs(self.layers) do
		v:free();
		self.layers[k] = nil;
	end
	self.layers = nil;
	Factory = nil;
	self.indicesByName = nil;
end

function LayerManager:update(dt)
	for k,v in pairs(self.layers) do
		v:update(dt);
	end
end

return LayerManager;