
local Keyboard = {};
Keyboard.key = {};
for i = 0, 255, 1 do
	Keyboard.key[i] = {false,false,false};
end

--3 = prev state, 2 = curr state, 1 = changed

local function PushBack(key, pressed)
	Keyboard.key[key][1] = true;
	Keyboard.key[key][2] = pressed;
	Keyboard.key[key][3] = Keyboard.key[key][2];
end

local function SetKey(key, pressed)
	PushBack(key, pressed);
end


local function PressKey(key)
	SetKey(key, true);
end

local function RaiseKey(key)
	SetKey(key, false);
end


local function IsKeyPressed(key)
	if Keyboard.key[key][2] == true and Keyboard.key[key][3] == true then
		return true;
	end
	return false;
end

local function IsKeyReleased(key)
	if Keyboard.key[key][2] == false and Keyboard.key[key][3] == true then
		return true;
	end
	return false;
end

local function IsKeyTriggered(key)
	if Keyboard.key[key][2] == true and Keyboard.key[key][3] == false then
		return true;
	end
	return false;
end

Keyboard.IsKeyPressed = IsKeyPressed;
Keyboard.IsKeyReleased = IsKeyReleased;
Keyboard.IsKeyTriggered = IsKeyTriggered;

if MOAIInputMgr.device.keyboard then
	local keyCallback = function ( key, down )
		for i = 0, 255, 1 do
			if Keyboard.key[i][1] == false then
				PushBack(i, Keyboard.key[i][2]);
			end
			Keyboard.key[key][1] = false;
		end
		if down then 
			PressKey(key);
		else
			RaiseKey(key);
		end
	end
	MOAIInputMgr.device.keyboard:setCallback ( keyCallback )
end

return Keyboard;