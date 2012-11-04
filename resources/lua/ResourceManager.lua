-- ResourceManager
local ResourceManager = {
	cache = {},
	handlers = {};
};

function ResourceManager:addToCache(key, value) 
	self.cache[key] = value;
end

function ResourceManager:getFromCache(key)
	return self.cache[key];
end

function ResourceManager:load(typeName, fileName) 
	return self.handlers[typeName]:load(fileName);
end

function ResourceManager:register(typeName, handler) 
	self.handlers[typeName] = handler;
end

function ResourceManager:shutdown()
	self.cache = nil;
end
--

-- Creator
local Creator = {};

function Creator:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end
-- 

-- Creators
local MOAITextureCreator = Creator:new(); 
local MOAIFileCreator = Creator:new();
local MOAIFontCreator = Creator:new();
--

-- Handler
local Handler = Creator:new();
--

-- Handlers
local MOAIFileHandler = Handler:new();
local MOAIConfigurationHandler = Handler:new();
local MOAIScriptHandler = Handler:new();
--

-- MOAIConfigurationHandler
function MOAIConfigurationHandler:load(fileName)
	local configuration = {};
	function deserialize(args)
		configuration = args;
	end
	local fullPath = "../configurations/"..fileName;
	if require("FileSystem"):checkFileExists(fullPath) then
		dofile(fullPath);
	end
	return configuration;
end
--

-- MOAIFileHandler
function MOAIFileHandler:load(fullPath) 

end
--

-- MOAIFontCreator
function MOAIFontCreator:createFromFile(fileName)
	properties = {
		name = "arial-rounded.ttf",
		characterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!",
		points = 12,
		dpi = 144,
	}
	local font = MOAIFont.new();
	font:loadFromTTF(properties.name, properties.characterSet, properties.points, properties.dpi);
	return font;
end

function MOAIFontCreator:load(fileName)
	return self:createFromFile("fileName");
end
--

-- MOAITextureCreator
function MOAITextureCreator:load(fileName) 
	local path = "../textures/"..fileName;
	local texture = ResourceManager:getFromCache(path);
	if texture == nil then
		texture = MOAITexture.new();
		texture:load(path);
		ResourceManager:addToCache(path, texture);
		print("Not in cache");
	end
	--TODO: If texture loading failes from file, create new MOAIImage with some garbage
	--		to ensure that at least something is registered correctly.

	return texture;
end
--

-- MOAIScriptHandler
function MOAIScriptHandler:load(fileName)	
	local fullPath = "../scripts/"..fileName;
	local script = ResourceManager:getFromCache(fullPath);
	if script ~= nil then return script end;

	-- If the script didn't exist in the cache
	if require("FileSystem"):checkFileExists(fullPath) then
		script = dofile(fullPath);
		ResourceManager:addToCache(fullPath, script);	
	else
		-- script is a do nothing anonymous function
		script = {update = function() end, name = "AnonymousScript"};
		print("Script is an anonymous do nothing");
	end
	return script;
end
--

local function init()
	ResourceManager:register("Texture", MOAITextureCreator:new());
	ResourceManager:register("Configuration", MOAIConfigurationHandler:new());
	ResourceManager:register("Font", MOAIFontCreator:new());
	ResourceManager:register("Script", MOAIScriptHandler:new());
end

init();

return ResourceManager;