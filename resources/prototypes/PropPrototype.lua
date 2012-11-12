local PropPrototype = {
	underlyingType = nil,
	name = "PropPrototypeName",
	type = "PropPrototypeType",
	scale = {x = 1, y = 1, z = 1},
	position = {x = 0, y = 0, z = 0},
	shaderName = "ken",
	textureName = "moai.png",
}

function PropPrototype:allocate()
	local object = PropPrototype:new {
		underlyingType = nil,
		name = "PropPrototypeName",
		type = "PropPrototypeType",
		scale = {x = 1, y = 1, z = 1},
		position = {x = 0, y = 0, z = 0},
		shaderName = "ken",
		textureName = "moai.png",
	}
	return object;
end

function PropPrototype:baseUpdate(dt)

end

function PropPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function PropPrototype:baseFree()
	self.underlyingType = nil;
end

function PropPrototype:baseSerialize(properties)
	properties = properties or {};
	properties.name = self.name;
	properties.position = self.position;
	properties.type = self.type;
	properties.scale = self.scale;
	properties.shaderName = self.shaderName;
	properties.texture = self.textureName
	return properties;
end

function PropPrototype:baseSetLoc(x, y, z)
	self.position.x = x;
	self.position.y = y;
	self.position.z = z;
end

function PropPrototype:baseSetScl(x, y, z)
	self.scale.x = x;
	self.scale.y = y;
	self.scale.z = z;
end

function PropPrototype:baseSetShader(shader, shaderName)
	self.shaderName = shaderName;
end

function PropPrototype:contains(x, y, z)
	print("PropPrototype:contains is UNIMPLEMENTED");
	return 0;
end

function PropPrototype:getLoc()
	return self.position;
end

function PropPrototype:free()
	self:baseFree();
end

function PropPrototype:getUnderlyingType()
	return self.underlyingType;
end

function PropPrototype:setLoc(x, y, z)
	self:baseSetLoc(x, y, z);
end

function PropPrototype:setName(name)
	self.name = name;
end

function PropPrototype:serialize(properties)
	return self:baseSerialize(properties);
end

function PropPrototype:setScl(x, y, z)
	self:baseSetScl(x, y, z);
end

function PropPrototype:setShader(shader, shaderName)
	self:baseSetShader(shader, shaderName);
end

function PropPrototype:setType(type)
	self.type = type;
end

function PropPrototype:setTextureName(textureName)
	self.textureName = textureName;
end

function PropPrototype:setUnderlyingType(newObjectReference)
	self.underlyingType = newObjectReference;
end

function PropPrototype:update(dt)
	self:baseUpdate(dt);
end

return PropPrototype;