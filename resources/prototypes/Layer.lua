local Layer = {
    ["type"] = "Layer",
    ["name"] = "DefaultLayerName",
    ["visible"] = "false",  -- This should start at false to allow a push to the render pass
    ["underlyingType"] = "nil",
    ["propContainer"] = nil,
    ["position"] = {x = 0, y = 0, z = 0},
}

function Layer:getName()
    return self["name"];
end

function Layer:hide()
    self.visible = "true";
    print("Hiding layer");
end

function Layer:new(object)
    object = object or {};
    setmetatable(object, self);
    self.__index = self;
    return object;
end

function Layer:getUnderlyingType()
    return self["underlyingType"];
end

function Layer:serialize(properties)
   properties = properties or {};
   return self:serializeBase(properties);
end

function Layer:serializeBase(properties)
    properties = properties or {}
    properties["type"] = self.type;
    properties["name"] = self.name;
    properties["visible"] = self.visible;
    properties["propContainer"] = self["propContainer"]:serialize();
    properties["position"] = self.position;
    return properties;   
end

function Layer:serializeToFile(filename)
    require "Pickle";
    p = pickle( self:serialize() );
    file = assert( io.open("../layers/"..filename, "wt") );
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    file:write(p);
    s = ")\n\n";
    file:write(s);
    file:close();
end

function Layer:setName(name)
    self.name = name;
end

function Layer:setLoc(x, y, z)
    self.position.x = x;
    self.position.y = y;
    self.position.z = z;
end

function Layer:setPropContainer(propContainer)
    self.propContainer = propContainer;
end

function Layer:setType(type)
    self.type = type;
end

function Layer:setUnderlyingType(newObjectReference)
    self["underlyingType"] = newObjectReference;
end

return Layer;