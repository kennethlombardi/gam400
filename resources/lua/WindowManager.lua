local WindowManager = {}

local screenWidth = MOAIEnvironment.horizontalResolution;
local screenHeight = MOAIEnvironment.verticalResolution;
local windowIsOpen = false;

WindowManager.screenWidth = screenWidth;
WindowManager.screenHeight = screenHeight;

if screenWidth == nil then 
  screenWidth = 1280;
  WindowManager.screenWidth = screenWidth;
end

if screenHeight == nil then 
  screenHeight = 720;
  WindowManager.screenHeight = screenHeight;
end

assert (not (WindowManager.screenWidth == nil))

-- opens a new window for the application to run in
-- must only be called once
-- must be called before the main thread can run the game loop
local function openWindow(windowName)
	if windowIsOpen then 
		print("CreateWindow can only be called once");
		return 
	end;
	
	MOAISim.openWindow(windowName, screenWidth, screenHeight)

	-- assume window opened properly
	windowIsOpen = true;
end

WindowManager.openWindow = openWindow;

return WindowManager;