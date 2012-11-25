local Script = {
	name = "outOfTimeLayerUpdate.lua",
};

local timeElapsed = 0;
function Script.update(layer, dt)
	timeElapsed = timeElapsed + dt;
    print(timeElapsed)
    if timeElapsed > 2 then
        layer:replaceAllScripts(require("Factory"):createFromFile("Script", "outOfTimeLayerTransitionOut.lua"));
        return;
    end
end

return Script;