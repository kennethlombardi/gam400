local WindowManager = {}

if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end
assert (not (screenWidth == nil))

WindowManager.screenWidth = screenWidth;
WindowManager.screenHeight = screenHeight;

return WindowManager;