local Mouse = {};
Mouse.windowX = 0;
Mouse.windowY = 0;
Mouse.worldX = 0;
Mouse.worldY = 0;
Mouse.velX = 0;
Mouse.velY = 0;
local function Update(layer)
	local lastX = Mouse.windowX;
	local lastY = Mouse.windowY;	
	Mouse.windowX, Mouse.windowY = MOAIInputMgr.device.pointer:getLoc();
	Mouse.velX = Mouse.windowX - lastX;
	Mouse.velY = Mouse.windowY - lastY;
	--Mouse.worldX, Mouse.worldY = layer:wndToWorld(Mouse.windowX, Mouse.windowY);	
	--camera:setLoc(500,5,1280);
	--camera:setRot((Mouse.windowY-360)/50, (Mouse.windowX-640)/50, 0);
end

Mouse.Update = Update;

return Mouse;
