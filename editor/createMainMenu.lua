dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "mainMenu",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"mainMenu.lua"}
};

width = 1280;
height = 720;
objectCount = 1;
for i = 1, objectCount do
	position = {x = 0, y = 0, z = 0};
	scale = {x = 10, y = 10, z = 1};
	rotation = {x = 0, y = 0, z = 0};
	prop = {
		type = "Prop",
		name = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {},
		shaderName = "basic2d",
		textureName = "startOn.png",
		rotation = rotation,
	}
	table.insert(layer1.propContainer, prop);
end

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\mainMenu"..".lua", "wt");
		s = "deserialize (\"Layer\",\n";
		file:write(s);
		s = pickle(v);
		file:write(s);
		s = ")\n\n";
		file:write(s);
		file:close();
		layerCount = layerCount + 1;
	end
end

pickleThis();
