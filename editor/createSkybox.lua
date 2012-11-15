dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "skybox",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"skybox.lua"}
};

width = 1280;
height = 720;
objectCount = 1;
for i = 1, objectCount do
	position = {x = 0, y = 0, z = -1000};
	scale = {x = 100, y = 100, z = 100};

	prop = {
		type = "PropCube",
		name = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {"PropMovement.lua"},
		shaderName = "shader",
		textureName = "earth.png",
		rotation = {x = 0, y = 0, z = 0},
	}
	table.insert(layer1.propContainer, prop);
end

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\skybox"..".lua", "wt");
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
