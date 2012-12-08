local Script = {
	name = "pauseLayerUpdate.lua",
};

function Script.update(layer, dt)
    local Input = require("InputManager"); 
    if Input:isReleased() then
        local pos = Input:getWindowPos();  
        local objects = layer:pickForPoint(pos.x, pos.y);
        for k,v in pairs(objects) do
            if type(v) ~= "number" then
                if v:getName() == "resumeButton" then
                    require("MessageManager"):send("CLICKED_RESUME_BUTTON");
                    layer:replaceAllScripts(require("Factory"):createFromFile("Script", "pauseLayerTransitionOut.lua"));
                elseif v:getName() == "quitButton" then
                    require("MessageManager"):send("CLICKED_QUIT_BUTTON");
                    --layer:replaceAllScripts(require("Factory"):createFromFile("Script", "pauseLayerTransitionOut"));
                elseif v:getName() == "creditsButton" then
                    require("MessageManager"):send("CLICKED_CREDITS_BUTTON");
                    --layer:replaceAllScripts(require("Factory"):createFromFile("Script", "pauseLayerTransitionOut"));
                end
            end
        end
    end
end

return Script;