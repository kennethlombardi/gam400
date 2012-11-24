local SceneManager = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");

function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
end

local spawnTimer = 0;
function SceneManager:update(dt)

	if LayerManager:getLayerByName("gameLayer.lua") ~= nil then
		spawnTimer = spawnTimer + dt;
		if spawnTimer > 1 then    
			spawnTimer = 0;
			local newprop = require("Generator"):spawnObject(0,0);  
			LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);		
			LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
		end
	end
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
<<<<<<< HEAD
	require("GameVariables"):SetGameTimer(1);
=======
	require("GameVariables"):set("Timer",30);
>>>>>>> 63c8c782bb847e49abff8b54abcfe9dadf1a178e

	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function SceneManager.onLayerFinishedTransition(layerName)
	LayerManager:removeLayerByName(layerName);
	if layerName == "mainMenu.lua" then
		local layer0 = require("LayerManager"):createLayerFromFile("gameLayer.lua");		
		require("LayerManager"):createLayerFromFile("gameHud.lua");
		--require("LayerManager"):createLayerFromFile("skyBox.lua");
	end
end

function SceneManager:onRanOutOfTime(payload)
	print("RAN_OUT_OF_TIME");
	local layers = LayerManager:getAllLayerIndices();
	for k,v in pairs(layers) do
		--LayerManager:removeLayerByIndex(v)
	end
end

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", SceneManager.onLayerFinishedTransition);
MessageManager:listen("RAN_OUT_OF_TIME", SceneManager.onRanOutOfTime);

return SceneManager