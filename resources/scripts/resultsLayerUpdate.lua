local Script = {
	name = "resultsLayerUpdate.lua",
};

Input = require("InputManager");

function Script.update(layer, dt)
    if Input.Mouse then
        local x = Input.Mouse.windowX;
        local y = Input.Mouse.windowY;
        if Input.Mouse:isKeyPressed(0) then
            local objects = layer:pickForPoint(x, y);
            for k,v in pairs(objects) do
                if type(v) ~= "number" then
                    if v.name == "retryButton" then
                        require("MessageManager"):send("CLICKED_RETRY_BUTTON");
                        layer:replaceAllScripts(require("Factory"):createFromFile("Script", "doNothing.lua"));
                        return;
                    end
                end
            end
        end
    end
end

return Script;