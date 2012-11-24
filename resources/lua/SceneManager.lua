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
			require("Generator"):SpawnObject(0,0);    
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
	require("GameVariables"):SetGameTimer(30);

	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function SceneManager.onLayerFinishedTransition(layerName)
	LayerManager:removeLayerByName(layerName);
	if layerName == "mainMenu.lua" then
		local layer0 = require("LayerManager"):createLayerFromFile("gameLayer.lua");
		require("GameVariables"):SetLayer(layer0);
		require("LayerManager"):createLayerFromFile("gameHud.lua");
		--require("LayerManager"):createLayerFromFile("skyBox.lua");
	end
end

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", SceneManager.onLayerFinishedTransition);

return SceneManager