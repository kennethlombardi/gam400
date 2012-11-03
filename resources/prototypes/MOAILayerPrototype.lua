local Layer = require "Layer";

MOAILayerPrototype = Layer:new{
	camera = nil;
};

local windowManager = require "WindowManager";

function MOAILayerPrototype:free()
	self:setVisible(false);
	self:baseFree();
	self.camera = nil;
end

function MOAILayerPrototype:getLoc()
	return self.position;
end

function MOAILayerPrototype:insertProp(prop)
	if self["underlyingType"] == nil then 
		print("Trying to insert prop into MOAILayerPrototype without underlying type"); 
		return; 
	end;
	self.underlyingType:insertProp(prop:getUnderlyingType());
end

function MOAILayerPrototype:insertPropPersistent(prop)
	self:insertProp(prop);
	self.propContainer:insertProp(prop);
end

function MOAILayerPrototype:setCamera(camera)
	if self["underlyingType"] == nil then 
		print("Trying to insert camera into MOAILayerPrototype without underlying type"); 
		return; 
	end;
	self.camera = camera;
	self.underlyingType:setCamera(camera);
end

function MOAILayerPrototype:setLoc(newX, newY, newZ)
	self.position = {x = newX, y = newY, z = newZ}
	if self.camera ~= nil then
		self.camera:setLoc(newX, newY, newZ);
	else
	end
end

function MOAILayerPrototype:setPropContainer(propContainer)
	self.propContainer = propContainer;
	for i,prop in pairs(propContainer.props) do
		self:insertProp(prop);
	end
end

function MOAILayerPrototype:serialize(properties)
	properties = properties or {}
	self:serializeBase(properties);	--Serialize the parent data
	return properties;
end

function MOAILayerPrototype:setViewport(viewport)
	if self["underlyingType"] == nil then
		print("Trying to insert viewport into MOAILayerPrototype without underlying type"); 
		return;
	end;
	self["underlyingType"]:setViewport(viewport);
end

function MOAILayerPrototype:setVisible(visible)
	if visible == true then
		if self.visible == "false" then
			MOAIRenderMgr.pushRenderPass(self:getUnderlyingType());
			self.visible = "true";
		end
	else
		if self.visible == "true" then
			MOAIRenderMgr.removeRenderPass(self:getUnderlyingType());
			self.visible = "false";
		end
	end
end

return MOAILayerPrototype;