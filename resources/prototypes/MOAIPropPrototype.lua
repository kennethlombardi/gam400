local PropPrototype = require "PropPrototype";

local MOAIPropPrototype = PropPrototype:allocate();

function MOAIPropPrototype:allocate()
	object = MOAIPropPrototype:new{
		position = {x = 0, y = 0, z = 0},
		scale = {x = 1, y = 1, z = 1},
		rotation = {x = 0, y = 0, z = 0},
		scripts = {},
		shaderName = "ken",
	}
	return object;
end

function MOAIPropPrototype:contains(x, y, z)
	return self.underlyingType:inside(x, y, z);
end

function MOAIPropPrototype:getRot()
	return self.rotation;
end

function MOAIPropPrototype:moveLoc(newX, newY, newZ, length, ease)
	if not ease then
		ease = MOAIEaseType.SMOOTH;
	end	
	self.underlyingType:moveLoc(newX, newY, newZ, length, ease);
end

function MOAIPropPrototype:registerScript(script)
	table.insert(self.scripts, script);
end

function MOAIPropPrototype:serialize(properties)
	properties = properties or {};
	self:baseSerialize(properties);
	properties.scripts = {};
	for k,script in pairs(self.scripts) do
		table.insert(properties.scripts, script.name)
	end
	return properties;
end

function MOAIPropPrototype:setName(name)
	self.name = name;
end

function MOAIPropPrototype:setLoc(newX, newY, newZ)
	self:baseSetLoc(newX, newY, newZ);
	self.underlyingType:setLoc(newX, newY, newZ);
end

function MOAIPropPrototype:setRot(x, y, z)
	self:baseSetRot(x, y, z);
	self.underlyingType:setRot(x, y, z);
end

function MOAIPropPrototype:setScl(x, y, z)
	self:baseSetScl(x, y, z);
	self.underlyingType:setScl(x, y, z);
end

function MOAIPropPrototype:setShader(shader, shaderName)
	self:baseSetShader(shader, 	shaderName);
	self.underlyingType:setShader(shader);
end

function MOAIPropPrototype:update(dt)
	self:baseUpdate(dt);
	for k,script in pairs(self.scripts) do
		script.update(self, dt);
	end
end

return MOAIPropPrototype;