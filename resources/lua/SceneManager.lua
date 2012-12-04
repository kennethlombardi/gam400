local SceneManager = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");
GameVariables:set("HighScore", UserDataManager:get("highScore"));
function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
end

function SceneManager:update(dt)

end

function SceneManager.onAddTimer(pos)
	properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	properties.string = "<c:00FF00>+2";
	properties.textSize = 48;
	properties.shaderName = "none";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = 0, y1 = 100};
	local newprop = require("Factory"):create("TextBox", properties); 

	LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function SceneManager.onCheckPoint(pos)
	properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z-3000;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	--checkpoint = "<c:FF0000>C<c:FF00DD>H<c:CC00FF>E<c:5500FF>C<c:00A0FF>K<c:00FFFF>P<c:00FF00>O<c:A0FF00>I<c:FFFF00>N<c:FFA000>T";  
	checkpoint = "CHECKPOINT";
	distance = string.format('<c:FFFFFF>%d miles traveled!', -pos.z);
	properties.string = string.format('%s\n%s',checkpoint, distance);
	properties.textSize = 56;
	properties.shaderName = "none";
	properties.justification = "center_justify";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = -500, y1 = -300};
	local newprop = require("Factory"):create("TextBox", properties); 

	LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
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
    LayerManager:createLayerFromFile("skyBox.lua");
	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function SceneManager.onLayerFinishedTransition(layerName)
    LayerManager:removeLayerByName(layerName);
    print(layerName, "removed itself");
    if layerName == "mainMenu.lua" then
        LayerManager:removeAllLayers();

        MessageManager:send("START_GAME");    
    end

    if layerName == "outOfTime.lua" then
        LayerManager:removeAllLayers();
        LayerManager:createLayerFromFile("results.lua");
        local currentScore = require("GameVariables"):get("Score");
        local highScore = UserDataManager:get("highScore");
        if currentScore > highScore then			
            UserDataManager:set("highScore", currentScore);
			UserDataManager:flush();
        end
    end

    if layerName == "results.lua" then
        LayerManager:removeAllLayers();

        MessageManager:send("START_GAME");    
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


function SceneManager.onSubTimer(pos)
	properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	properties.string = "<c:FF0000>-5";
	properties.textSize = 48;
	properties.shaderName = "none";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = 0, y1 = 100};
	local newprop = require("Factory"):create("TextBox", properties); 

	LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function SceneManager.onStartGame()
    -- song
    require("SoundManager"):play("ambience.wav", true);

    -- some variables
    require("GameVariables"):reset();
	require("InputManager"):reCal();  
    LayerManager:createLayerFromFile("skyBox.lua");
    LayerManager:createLayerFromFile("gameLayer.lua");  
    LayerManager:createLayerFromFile("gameHud.lua");
end

function SceneManager.test(payload)
end

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("START_GAME", SceneManager.onStartGame);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);
MessageManager:listen("CLICKED_RETRY_BUTTON", SceneManager.onClickedRetryButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", SceneManager.onLayerFinishedTransition);
MessageManager:listen("RAN_OUT_OF_TIME", SceneManager.onRanOutOfTime);
MessageManager:listen("ADD_TIMER", SceneManager.onAddTimer);
MessageManager:listen("SUB_TIMER", SceneManager.onSubTimer);
MessageManager:listen("CHECKPOINT", SceneManager.onCheckPoint);
MessageManager:listen("TEST", SceneManager.test);

return SceneManager