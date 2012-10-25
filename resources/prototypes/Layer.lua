local Layer = {
    ["type"] = "Layer",
    ["name"] = "DefaultLayerName",
    ["hidden"] = false,
    ["underlyingType"] = nil;
    ["props"] = {};
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

function Layer:setUnderlyingType(newObjectReference)
    self["underlyingType"] = newObjectReference;
end

return Layer;