local done = false;

local Factory = require("Factory");
function gameLoop ()
	layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
	layer1:insertProp(Factory:create("Prop", {position = {x = 0, y = 0, z = 300}, name = "Prop", type = "Prop"}));
	while not done do
		coroutine.yield()

	end
end

return gameLoop;