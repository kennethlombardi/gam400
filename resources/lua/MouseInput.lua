local Mouse = {};
Mouse.windowX = 0;
Mouse.windowY = 0;
Mouse.worldX = 0;
Mouse.worldY = 0;
Mouse.velX = 0;
Mouse.velY = 0;
Mouse.key = {};
Mouse.key[0] = {false,false,false}
Mouse.key[1] = {false, false, false}

local function PushBack(key, pressed)
	Mouse.key[key][1] = true;
	Mouse.key[key][3] = Mouse.key[key][2];
	Mouse.key[key][2] = pressed;	
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

function Mouse:IsKeyPressed(key)	
	if self.key[key][2] == true and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Mouse:IsKeyReleased(key)	
	if self.key[key][2] == false and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Mouse:IsKeyTriggered(key)
	if self.key[key][2] == true and self.key[key][3] == false then
		return true;
	end
	return false;
end

function Mouse:Update(dt)
	for i = 0, 1, 1 do
		if Mouse.key[i][1] == false then
			PushBack(i, Mouse.key[i][2]);
		end
		Mouse.key[i][1] = false;	
	end	
end


MOAIInputMgr.device.pointer:setCallback(
	function()		
		local lastX = Mouse.windowX;
		local lastY = Mouse.windowY;	
		Mouse.windowX, Mouse.windowY = MOAIInputMgr.device.pointer:getLoc();
		Mouse.velX = Mouse.windowX - lastX;
		Mouse.velY = Mouse.windowY - lastY;
	end
)	

MOAIInputMgr.device.mouseLeft:setCallback(
	function(isMouseDown)		
		if(isMouseDown) then
			PressKey(0);		
		else
			RaiseKey(0);
		end
	end
)
MOAIInputMgr.device.mouseRight:setCallback(

	function(isMouseDown)		
		if(isMouseDown) then
			PressKey(1);
		else
			RaiseKey(1);
		end		
		
	end
)

--local function Update(layer)
	
	--Mouse.worldX, Mouse.worldY = layer:wndToWorld(Mouse.windowX, Mouse.windowY);	
	--camera:setLoc(500,5,1280);
	--camera:setRot((Mouse.windowY-360)/50, (Mouse.windowX-640)/50, 0);
--end


return Mouse;
