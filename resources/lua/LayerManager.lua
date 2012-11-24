local LayerManager = {
	layers = {},
	layerIndicesByName = {},
	currentLayerIndex = 0,
}

local Factory = require "Factory";

function LayerManager:nextIndex()
	self.currentLayerIndex = self.currentLayerIndex + 1;
	return self.currentLayerIndex;
end

function LayerManager:createLayerFromFile(layerFileName)
	local nextIndex = self:nextIndex();
	table.insert(self.layers, nextIndex, Factory:createFromFile("Layer", layerFileName));

	-- Save the layer name as a hash for the index to allow quick retrieval of layers by name
	self.layerIndicesByName[layerFileName] = nextIndex;

	return nextIndex;
end

function LayerManager:getAllLayers()
	local allLayers = {};
	for k,v in pairs(self.layers) do
		table.insert(allLayers, v)
	end
	return allLayers;
end

function LayerManager:getAllLayerIndices()
	local layerIndices = {};
	for k,v in pairs(self.layerIndicesByName) do
		if self:getLayerByIndex(v) == nil then
			print("Layer at index", v, "is nil with name", k);
		end
		table.insert(layerIndices, v);
	end
	return layerIndices;
end

function LayerManager:getLayerByIndex(layerIndex)
	return self.layers[layerIndex];
end

function LayerManager:getLayerIndexByName(layerName)
	return self.layerIndicesByName[layerName];
end

function LayerManager:removeLayerByName(layerName)
	self:removeLayerByIndex(self:getLayerIndexByName(layerName));
	self.layerIndicesByName[layerName] = nil;
end

function LayerManager:getLayerByName(layerName)
	return self:getLayerByIndex(self.layerIndicesByName[layerName]);
end

function LayerManager:removeLayerByIndex(layerIndex)
	self.layers[layerIndex]:free();
	self.layers[layerIndex] = nil;
end

function LayerManager:serializeLayerToFile(layerIndex, fileName)
	if self.layers[layerIndex] == nil then
		print("serializeToFile["..layerIndex.."] is nil");
		return;
	end
	self.layers[layerIndex]:serializeToFile(fileName);
end

function LayerManager:shutdown()
	local layerIndices = LayerManager:getAllLayerIndices();
	for k,v in pairs(layerIndices) do
		self:removeLayerByIndex(v);
	end
	self.layers = nil;
	Factory = nil;
	self.layerIndicesByName = nil;
end

function LayerManager:update(dt)
	for k,v in pairs(self.layers) do
		v:update(dt);
	end
end

return LayerManager;