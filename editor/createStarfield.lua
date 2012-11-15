dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "starfield",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"starfield.lua"}
};

width = 1280;
height = 720;
objectCount = 3;
for i = 1, objectCount do
	position = {x = math.random(-300, 300), y = math.random(-300, 300), z = -1000};
	scale = {x = 10, y = 10, z = 10};

	prop = {
		type = "PropCube",
		name = "Prop"..i,
		position = position,
		scale = scale,
		scripts = {"PropMovement.lua"},
		shaderName = "shader",
		textureName = "rock.png",
		rotation = {x = 0, y = 0, z = 0},
	}
	table.insert(layer1.propContainer, prop);
end

layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\starfield"..".lua", "wt");
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
