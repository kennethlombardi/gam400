local Layer = {
    ["type"] = "Layer",
    ["name"] = "DefaultLayerName",
    ["hidden"] = "false",
    ["underlyingType"] = "nil",
    ["propContainer"] = nil,
    ["position"] = {x = 0, y = 0},
}

function Layer:getName()
    return self["name"];
end

function Layer:hide()
    self["hidden"] = "true";
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
    properties["type"] = self["type"];
    properties["name"] = self["name"];
    properties["hidden"] = self["hidden"];
    properties["propContainer"] = self["propContainer"]:serialize();
    properties["position"] = {x = self.position.x, y = self.position.y};
    return properties;
end

function Layer:setName(name)
    self.name = name;
end

function Layer:setPosition(x, y)
    self.position.x = x;
    self.position.y = y;
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