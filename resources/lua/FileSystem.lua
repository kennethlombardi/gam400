-- FileSystem
local FileSystem = {
	handlers = {};
	core = nil;
}

function FileSystem:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function FileSystem:load(type, fullPath, options) 
	self.handlers[type]:load(fullPath, options);
end

function FileSystem:registerCore(core)
	self.core = core;
end

function FileSystem:registerHandler(type, fileSystemHandler)
	self.handlers[type] = fileSystemHandler;
end

function FileSystem:checkFileExists(fullPath)
	return self.core:checkFileExists(fullPath);
end

--

-- FileSystemCore
local FileSystemCore = {};

function FileSystemCore:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end
--

-- FileSystemHandler
local FileSystemHandler = {};

function FileSystemHandler:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function FileSystemCore:checkFileExists(fullPath) 
	print("FileSystemCore:exists is UNIMPLEMENTED");
end
--

-- MOAIFileSystemCore
local MOAIFileSystemCore = FileSystemCore:new();

function MOAIFileSystemCore:checkFileExists(fullPath)
	return MOAIFileSystem.checkFileExists(fullPath);
end
--

-- MOAIFileSystemFileStreamHandler
local function fileOpenModesDefault(table, key)
	table[key] = MOAIFileStream.READ;
	return MOAFileStream.READ;
end

local fileOpenModesMap = { 
	["rb"] = MOAIFileStream.READ,
	["wb"] = MOAIFileStream.WRITE,
	["ab"] = MOAIFileStream.APPEND,
	["rb+"] = MOAIFileStream.READ_WRITE,
	["rb+"] = MOAIFileStream.READ_WRITE_AFFIRM,
	["wb+"] = MOAIFileStream.READ_WRITE_NEW,
	__index = fileOpenModesDefault,
};

local MOAIFileSystemFileStreamHandler = FileSystemHandler:new{
	fileOpenModes = fileOpenModesMap;
};

function MOAIFileSystemFileStreamHandler:init()
	setmetatable(self.fileOpenModes, self.fileOpenModes);
end

function MOAIFileSystemFileStreamHandler:load(fullPath, mode)
	return MOAIFileStream.new():load(fullPath, self.fileOpenModes[mode]);
end
--

function init()
	-- MOAIFileSystemFileStreamHandler
	MOAIFileSystemFileStreamHandler:init();

	-- FileSystem registration
	FileSystem:registerCore(MOAIFileSystemCore:new());
	FileSystem:registerHandler("Stream", MOAIFileSystemFileStreamHandler:new());
end

init();

return FileSystem;