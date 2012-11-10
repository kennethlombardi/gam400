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
	print("Created layer at index", nextIndex);
	return nextIndex;
end

function LayerManager:removeLayerByIndex(layerIndex)
	print("Freeing layer at index", layerIndex);
	self.layers[layerIndex]:free();
	self.layers[layerIndex] = nil;
end

function LayerManager:getLayerByIndex(layerIndex)
	if self.layers[layerIndex] == nil then
		print("getLayerByIndex["..layerIndex.."] is nil");
	end
	return self.layers[layerIndex];
end

function LayerManager:getLayerIndexByName(layerName)
	return self.layerIndicesByName[layerName];
end

function LayerManager:getLayerByName(layerName)
	return self:getLayerByIndex(self.layerIndicesByName[layerName]);
end

function LayerManager:serializeLayerToFile(layerIndex, fileName)
	if self.layers[layerIndex] == nil then
		print("serializeToFile["..layerIndex.."] is nil");
		return;
	end
	self.layers[layerIndex]:serializeToFile(fileName);
end

function LayerManager:shutdown()
	for i,v in ipairs(self.layers) do
		self:removeLayerByIndex(i);
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