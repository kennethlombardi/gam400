local MOAITextBoxPrototype = require("TextBoxPrototype"):new();

function MOAITextBoxPrototype:allocate()
	object = MOAITextBoxPrototype:new{
		position = {x = 0, y = 0, z = 0},
		scale = {x = 1, y = 1, z = 1},
		underlyingType = nil,
		string = "MOAITextBoxPrototype Text",
	}
	return object;
end

function MOAITextBoxPrototype:setFont(font)
	self:baseSetFont(font);
	self.underlyingType:setFont(font);
end

function MOAITextBoxPrototype:setText(string)
	self:baseSetText(string);
	self.underlyingType:setString(string);
end

return MOAITextBoxPrototype;