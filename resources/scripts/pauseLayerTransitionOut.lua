local Script = {
	name = "pauseLayerTransitionOut.lua",
};

function Script.update(layer, dt)
    local props = layer:getAllProps();
    for k,v in pairs(props) do
        local position = v:getLoc();
        v:setLoc(position.x + 100 * dt, position.y, position.z);
    end
    
    local playButton = layer:getPropByName("pausedTitle");
    if playButton and playButton:getType() == "Prop" then
        local fudge = 0;
        if playButton:getLoc().x > require("WindowManager").screenWidth / 2 + (playButton:getSize().x * playButton:getScl().x) / 2 + fudge then
            require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
        end
    end
end

return Script;