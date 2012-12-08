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
                if v.name == "resumeButton" then
                    require("MessageManager"):send("CLICKED_RESUME_BUTTON");
                    layer:replaceAllScripts(require("Factory"):createFromFile("Script", "pauseLayerTransitionOut.lua"));
                end
            end
        end
    end
end

return Script;