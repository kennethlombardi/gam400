local function preInitialize()
  -- require managers to perform singleton initialization
  require "SimulationManager";
  require "WindowManager";
  require "ResourceManager";
  require "LayerManager";
  require("SoundManager");
  require("InputManager");
   print("PreInitialized");
end

local function initialize()
  require("SimulationManager"):setLeakTrackingEnabled(true);
  require("SimulationManager"):setHistogramEnabled(true);

  -- the hack world
  bg = require("LayerManager"):createLayerFromFile("skyBox.lua");
  layer0 = require("LayerManager"):createLayerFromFile("gameLayer.lua");
  require("GameVariables"):SetLayer(layer0);
  layer1 = require("LayerManager"):createLayerFromFile("gameHud.lua");

  -- simulation state
  MOAIGfxDevice.setClearDepth(true);
  
  -- song
  require("SoundManager"):play("mono16.wav", false);

  -- some variables
  require("GameVariables"):SetGameTimer(30);

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
  require("ShapesLibrary"):shutdown();  
  require("SimulationManager"):forceGarbageCollection();
  require("SimulationManager"):reportLeaks();
  require("SimulationManager"):forceGarbageCollection();
  require("SimulationManager"):reportHistogram();
  
  require("SimulationManager"):shutdown();
end
local spawnTimer = 0;
local function update(dt)
  require("InputManager"):update(dt);
  require("LayerManager"):update(dt);
  require("SoundManager"):update(dt);
  
  spawnTimer = spawnTimer + dt;
  
  if spawnTimer > 1 then    
    spawnTimer = 0;
    require("Generator"):SpawnObject(0,0);    
  end
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