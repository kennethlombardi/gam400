local windowManager = require "WindowManager";

-- window must exist before main thread can run
windowManager.openWindow("W.A.T.");

-- create and run the game loop thread
gameLoop = require "GameLoop"
drawingGameLoop = require "DrawingTestLoop"
managerGameLoop = require "ManagerGameLoop"
local test = true;
mainThread = MOAIThread.new();
if not test then
  mainThread:run(gameLoop);
else
  mainThread:run(gamesLoop);
end
