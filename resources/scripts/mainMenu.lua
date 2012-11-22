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
					v.underlyingType:setTexture(require("ResourceManager"):load("Texture", "rock.png"):getUnderlyingType());
					v.underlyingType:moveRot( 0, 0, 1, 0.125, MOAIEaseType.EASE_IN )
				end
			end
		else
			-- pick prop with name "playButton"
			object:getPropByName("playButton"):getUnderlyingType():moveRot( 0, 0, 1, 0.125, MOAIEaseType.EASE_IN )
		end
	end
end

return Script;