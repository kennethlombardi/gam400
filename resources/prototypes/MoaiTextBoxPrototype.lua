local MOAITextBoxPrototype = require("TextBoxPrototype"):new();

function MOAITextBoxPrototype:allocate()
	object = MOAITextBoxPrototype:new{
		position = {x = 0, y = 0, z = 0},
		scale = {x = 1, y = 1, z = 1},
		underlyingType = nil,
	}
	return object;
end

function MOAITextBoxPrototype:setFont(font)
	self:baseSetFont(font);
	self.underlyingType:setFont(font);
end

return MOAITextBoxPrototype;