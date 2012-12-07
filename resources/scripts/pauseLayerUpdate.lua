local Script = {
	name = "pauseLayerUpdate.lua",
};

function Script.update(layer, dt)
    local Input = require("InputManager");  
    if Input:isPressed() then
        local position = Input:getWindowPos();
        layer:replaceAllScripts(require("Factory"):createFromFile("Script", "pauseLayerTransitionOut.lua"));
    end
end

return Script;