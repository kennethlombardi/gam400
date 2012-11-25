-- window must exist before main thread can run
require("WindowManager"):openWindow("Fall 2012");

-- create and run the game wloop thread
mainThread = MOAIThread.new();
mainThread:run(require(require("ConfigurationManager"):getValue("mainThread")));