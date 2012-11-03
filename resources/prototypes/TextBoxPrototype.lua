local TextBox = require("PropPrototype"):new {
	font = nil;
};

function TextBox:setFont(font)
	self:baseSetFont(font);
end

function TextBox:baseSetFont(font)
	self.font = font;
end

function TextBox:free()
	self:baseFree();
	self.font = nil;
end

return TextBox;