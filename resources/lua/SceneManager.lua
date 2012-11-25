local SceneManager = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");

function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
end


function SceneManager:update(dt)
	
end

function SceneManager.onClickedPlayButton(payload)
	print("Clicked play button");
	local titleLayer = LayerManager:getLayerByName("mainMenu.lua");
	local starfieldLayer = LayerManager:getLayerByName("starfield.lua");
	titleLayer:replaceAllScripts(Factory:createFromFile("Script", "titleLayerTransitionOut.lua"));
	starfieldLayer:replaceAllScripts(Factory:createFromFile("Script", "starfieldLayerTransitionOut.lua"));
end

function SceneManager.onGameInitialized(payload)
	-- song
	require("SoundManager"):play("mono16.wav", false);

	-- some variables
	require("GameVariables"):set("Timer", 3);

	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function SceneManager.onLayerFinishedTransition(layerName)
	LayerManager:removeLayerByName(layerName);
	print(layerName, "removed itself");
	if layerName == "mainMenu.lua" then
		require("LayerManager"):createLayerFromFile("gameLayer.lua");		
		require("LayerManager"):createLayerFromFile("gameHud.lua");
	end

	if layerName == "outOfTime.lua" then
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

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", SceneManager.onLayerFinishedTransition);
MessageManager:listen("RAN_OUT_OF_TIME", SceneManager.onRanOutOfTime);

return SceneManager