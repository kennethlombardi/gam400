dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "results.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"resultsLayerUpdate.lua"}
};

width = 1280;
height = 720;

prop = {
	type = "Prop",
	name = "retryButton",
	scripts = {},
	shaderName = "basic2d",
	textureName = "retryButtonHighlighted.png",
    position = {x = 0, y = 0, z = 0},
    scale = {x = 1, y = 1, z = 1},
    rotation = {x = 0, y = 0, z = 0},
}
table.insert(layer1.propContainer, prop);

local function pickleThis()

    file = io.open(".\\generated\\results"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
