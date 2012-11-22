local SceneManager = {}

local MessageManager = require("MessageManager");

function SceneManager:shutdown()

end

function SceneManager:update(dt)

end

function SceneManager:onClickedPlayButton(payload)
	print("Clicked play button");
end

function SceneManager:onGameInitialized(payload)
	print("Scene manager adding a couple of layers");
	layer0 = require("LayerManager"):createLayerFromFile("starfield.lua");
	layer1 = require("LayerManager"):createLayerFromFile("mainMenu.lua");
end

MessageManager:listen("GAME_INITIALIZED", SceneManager.onGameInitialized);
MessageManager:listen("CLICKED_PLAY_BUTTON", SceneManager.onClickedPlayButton);

return SceneManager