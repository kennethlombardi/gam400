local windowManager = require "WindowManager";
local ConfigurationManager = require "ConfigurationManager";

-- window must exist before main thread can run
windowManager.openWindow("W.A.T.");

-- create and run the game loop thread
mainThread = MOAIThread.new();
mainThread:run(require(ConfigurationManager:getValue("mainThread")));
