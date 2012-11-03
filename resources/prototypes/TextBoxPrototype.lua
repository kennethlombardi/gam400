local TextBox = require("PropPrototype"):new {
	font = nil,
	string = "MyText",
};

function TextBox:baseSetFont(font)
	self.font = font;
end

function TextBox:baseSetText(string)
	self.string = string;
end

function TextBox:free()
	self:baseFree();
	self.font = nil;
end

function TextBox:setFont(font)
	self:baseSetFont(font);
end

function TextBox:setTextSize(size)
end

--[[
x1	( number ) The X coordinate of the rect's upper-left point.
y1	( number ) The Y coordinate of the rect's upper-left point.
x2	( number ) The X coordinate of the rect's lower-right point.
y2	( number ) The Y coordinate of the rect's lower-right point. --]]
function TextBox:setRect(x1, y1, x2, y2)
end

function TextBox:setAlignment(alignment)
end

function TextBox:setYFlip(bool)
end

function TextBox:setText(string)
	self:baseSetTest(string);
end

return TextBox;