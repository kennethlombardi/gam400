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

function SceneManager.onLayerFinishedTransition(layerName)
	LayerManager:removeLayerByName(layerName);
	print(layerName, "removed itself");
	if layerName == "mainMenu.lua" then
		LayerManager:createLayerFromFile("gameLayer.lua");		
		LayerManager:createLayerFromFile("gameHud.lua");
	end

	if layerName == "outOfTime.lua" then
		LayerManager:removeAllLayers();
		LayerManager:createLayerFromFile("results.lua");
		local currentScore = UserDataManager:get("currentScore");
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
MessageManager:listen("TEST", SceneManager.test);

return SceneManager