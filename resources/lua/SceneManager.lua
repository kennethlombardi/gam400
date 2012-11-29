local SceneManager = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");
local UserDataManager = require("UserDataManager");

function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
end

function SceneManager:update(dt)
	
end

function SceneManager.onClickedPlayButton(payload)
	print("Clicked play button");
	LayerManager:getLayerByName("mainMenu.lua"):replaceAllScripts(Factory:createFromFile("Script", "titleLayerTransitionOut.lua"));
	LayerManager:getLayerByName("starfield.lua"):replaceAllScripts(Factory:createFromFile("Script", "starfieldLayerTransitionOut.lua"));
end

function SceneManager.onClickedRetryButton(payload)
	print("Clicked retry button");
    LayerManager:getLayerByName("results.lua"):replaceAllScripts(require("Factory"):createFromFile("Script", "resultsLayerTransitionOut.lua"));
end

function SceneManager.onGameInitialized(payload)
	-- song
	require("SoundManager"):play("mono16.wav", false);

	-- some variables
	require("GameVariables"):set("Timer", 20);
  LayerManager:createLayerFromFile("skyBox.lua");
	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function SceneManager.onAddTimer(pos)
	-- properties = {};
  -- properties.scale = {x = 1000, y = 1000, z = 1000};
  -- properties.position = {};
  -- properties.position.x = pos.x;
  -- properties.position.y = pos.y;
  -- properties.position.z = pos.z;
  -- properties.scripts = "timeToLive.lua";
  -- properties.type = "TextBox";
  -- properties.name = "TextBox";    
  -- properties.string = "+1";
  -- properties.textSize = 24;
  -- properties.shaderName = "none";
  -- properties.rectangle = {x2 = 300, y2 = 100, x1 = 0, y1 = 0};
  -- local newprop = require("Factory"):create("TextBox", properties); 
  -- LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
  -- LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function SceneManager.onSubTimer(pos)
	-- properties = {};
  -- properties.scale = {x = 1000, y = 1000, z = 1000};
  -- properties.position = {};
  -- properties.position.x = pos.x;
  -- properties.position.y = pos.y;
  -- properties.position.z = pos.z;
  -- properties.scripts = "timeToLive.lua";
  -- properties.type = "TextBox";
  -- properties.name = "TextBox";    
  -- properties.string = "-1";
  -- properties.textSize = 24;
  -- properties.shaderName = "none";
  -- properties.rectangle = {x2 = 300, y2 = 100, x1 = 0, y1 = 0};
  -- local newprop = require("Factory"):create("TextBox", properties); 
  -- LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
  -- LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function SceneManager.onLayerFinishedTransition(layerName)
	LayerManager:removeLayerByName(layerName);
	print(layerName, "removed itself");
	if layerName == "mainMenu.lua" then
		LayerManager:removeAllLayers();

		LayerManager:createLayerFromFile("skyBox.lua");
		LayerManager:createLayerFromFile("gameLayer.lua");	
		LayerManager:createLayerFromFile("gameHud.lua");	
	end

	if layerName == "outOfTime.lua" then
		LayerManager:removeAllLayers();
		LayerManager:createLayerFromFile("results.lua");
		local currentScore = require("GameVariables"):get("Distance");
		local highScore = UserDataManager:get("highScore");
		if currentScore > highScore then
			UserDataManager:set("highScore", currentScore);
		end
	end

	if layerName == "results.lua" then
		LayerManager:removeAllLayers();
		require("MessageManager"):send("GAME_INITIALIZED");
	end
end

function SceneManager:onRanOutOfTime(payload)
	local layers = LayerManager:getAllLayers();
	for k,v in pairs(layers) do
		if v:getName() == "gameLayer.lua" then
			v:replaceAllScripts(Factory:createFromFile("Script", "gameLayerTransitionOut.lua"));
		elseif v:getName() == "gameHud.lua" then
			v:replaceAllScripts(Factory:createFromFile("Script", "gameHudTransitionOut.lua"));
		end
	end
	print("creating outoftimelayer")
	LayerManager:createLayerFromFile("outOfTime.lua");
end

function SceneManager.test(payload)
end

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);
MessageManager:listen("CLICKED_RETRY_BUTTON", SceneManager.onClickedRetryButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", SceneManager.onLayerFinishedTransition);
MessageManager:listen("RAN_OUT_OF_TIME", SceneManager.onRanOutOfTime);
MessageManager:listen("ADD_TIMER", SceneManager.onAddTimer);
MessageManager:listen("SUB_TIMER", SceneManager.onSubTimer);
MessageManager:listen("SHAKE_SCREEN", SceneManager.onShakeScreen);
MessageManager:listen("TEST", SceneManager.test);

return SceneManager