local TextBox = require("PropPrototype"):new {
	font = nil;
};

function TextBox:setFont(font)
	self:baseSetFont(font);
end

function TextBox:baseSetFont(font)
	self.font = font;
end

return TextBox;