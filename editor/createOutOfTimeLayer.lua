dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "outOfTime.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"outOfTimeLayerUpdate.lua"}
};

width = 1280;
height = 720;

position = {x = 0, y = 0, z = 0};
scale = {x = 1, y = 1, z = 1};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "outOfTime",
	position = position,
	scale = scale,
	scripts = {},
	shaderName = "basic2d",
	textureName = "startOn.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);

local function pickleThis()

    file = io.open(".\\generated\\outOfTime"..".lua", "wt");
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    s = pickle(layer1);
    file:write(s);
    s = ")\n\n";
    file:write(s);
    file:close();

end

pickleThis();
