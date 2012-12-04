-- window must exist before main thread can run
require("WindowManager"):openWindow("Spacecapade");
--MOAISim.enterFullscreenMode()
-- create and run the game wloop thread
mainThread = MOAIThread.new();
mainThread:run(require(require("ConfigurationManager"):get("mainThread")));