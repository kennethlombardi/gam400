local factory = {}

-- the objects
local objects = {}

local function addObject(object)
  
end

local function createObjectList( list )
  list.addObject = addObject;
end

--decorate factory
factory.addObject = addObject;

return factory