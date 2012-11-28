local Script = {
	name = "resultsLayerUpdate.lua",
};

Input = require("InputManager");

function Script.update(layer, dt)
  local pos = Input:getWindowPos();  
  if Input:isPressed() then
    local objects = layer:pickForPoint(pos.x, pos.y);
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

return Script;