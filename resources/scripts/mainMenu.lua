local Script = {
	name = "mainMenu.lua",
};

function Script.update(object, dt)
	Input = require("InputManager");

	if Input.Mouse then
		local x = Input.Mouse.windowX;
		local y = Input.Mouse.windowY;
		if Input.Mouse:isKeyPressed(0) then
			local objects = object:pickForPoint(x, y);
			for k,v in pairs(objects) do
				if type(v) ~= "number" then
					if v.name == "playButton" then
						require("MessageManager"):send("CLICKED_PLAY_BUTTON");
					end
				end
			end
		end
	end
end

return Script;