local ResourceManager = {
	cache = {};
};

local creators = {};

function ResourceManager:load(type, fileName)
end

function ResourceManager:register(type, handler)
end

local Creator = {};

function Creator:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

-- Creators
local MOAITextureCreator = Creator:new(); 
--

-- MOAITextureCreator
function MOAITextureCreator:load(fileName) 
	local path = "../textures/"..fileName;
	local textureBuffer = ResourceManager.cache[path];
	if textureBuffer == nil then 
		textureBuffer = MOAIDataBuffer.new();
		local success = textureBuffer:load(path);
		if not success then 
			local defaultPath = "../textures/pinkSquare.png";
			MOAILogMgr.log("Loading failed for: "..fileName.. "at path: "..path);
			MOAILogMgr.log("Attempting reasonable default of "..defaultPath);
			success = textureBuffer:load(defaultPath);
			if not success then 
				MOAILogMgr.log("Loading of default path failed at path: "..defaultPath);
			end
		else
			ResourceManager.cache[path] = textureBuffer;
		end
	end
	local texture = MOAITexture.new();
	texture:load(textureBuffer);
	return texture;
end
--

-- ResourceManager
function ResourceManager:load(typeName, fileName) 
	return creators[typeName]:load(fileName);
end

function ResourceManager:register(typeName, creator) 
	creators[typeName] = creator;
end
--

local function init()
	ResourceManager:register("Texture", MOAITextureCreator:new());
end

init();

return ResourceManager;

