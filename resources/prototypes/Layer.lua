local Layer = {
    ["type"] = "Layer",
    ["name"] = "DefaultLayerName",
    ["hidden"] = "false",
    ["underlyingType"] = "nil",
    ["props"] = nil,
    ["position"] = {x = 0, y = 0},
}


function Layer:getName()
    return self["name"];
end

function Layer:hide()
    self["hidden"] = true;
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
    properties["props"] = self["props"]:serialize();
    --properties["position"] = {x = self.position.x, y = self.position.y};
    return properties;
end

function Layer:setName(name)
    self.name = name;
end

function Layer:setPropContainer(propContainer)
    self.props = propContainer;
end

function Layer:setType(type)
    self.type = type;
end

function Layer:setUnderlyingType(newObjectReference)
    self["underlyingType"] = newObjectReference;
end

return Layer;