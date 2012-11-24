local function preInitialize()
  -- require managers to perform singleton initialization
  require("MessageManager");
  require("SimulationManager");
  require("WindowManager");
  require("ResourceManager");
  require("LayerManager");
  require("SceneManager");
  require("SoundManager");
  require("InputManager");
  print("PreInitialized");
end

local function initialize()
  require("SimulationManager"):setLeakTrackingEnabled(true);
  require("SimulationManager"):setHistogramEnabled(true);

  -- simulation state
  MOAIGfxDevice.setClearDepth(true);


  require("MessageManager"):send("GAME_INITIALIZED");

  print("Initialized");
end

local function preShutdown()
  --require("LayerManager"):getLayerByName("pickleFile0.lua"):serializeToFile("pickleFileDiff0.lua");
  --require("LayerManager"):serializeLayerToFile(require("LayerManager"):getLayerIndexByName("pickleFile1.lua"), "pickleFileDiff1.lua");
end

local function shutdown()
  require("GameVariables"):shutdown();
  require("LayerManager"):shutdown();
  require("ResourceManager"):shutdown();
  require("WindowManager"):shutdown();
  require("SoundManager"):shutdown();
  require("SceneManager"):shutdown();
  require("ShapesLibrary"):shutdown();  
  require("SimulationManager"):forceGarbageCollection();
  require("SimulationManager"):reportLeaks();
  require("SimulationManager"):forceGarbageCollection();
  require("SimulationManager"):reportHistogram();
  
  require("SimulationManager"):shutdown();
end

local function update(dt)
  require("MessageManager"):update(dt);
  require("InputManager"):update(dt);
  require("LayerManager"):update(dt);
  require("SceneManager"):update(dt);
  require("SoundManager"):update(dt);
end


local done = false;
function gamesLoop ()
  preInitialize();
  initialize();
  require("InputManager"):reCal();  
  while not done do
    update(require("SimulationManager"):getStep());
    done = require("InputManager"):isKeyTriggered(require("InputManager").Key["esc"]);      
    coroutine.yield()
  end
  
  preShutdown();
  shutdown();
  os.exit();
end

return gamesLoop;