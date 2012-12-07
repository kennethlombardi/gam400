dofile("Pickle.lua")

layer1 = {
	type = "LayerDD",
	name = "pause.lua",
	visible = "true",
	propContainer = {},
	position = {x = 0, y = 0, z = 0},
	scripts = {"pauseLayerUpdate.lua"}
};

width = 1280;
height = 720;

position = {x = 0, y = 0, z = 0};
scale = {x = 1, y = 1, z = 1};
rotation = {x = 0, y = 0, z = 0};
prop = {
	type = "Prop",
	name = "playButton",
	position = position,
	scale = scale,
	scripts = {"pauseButtonUpdate.lua"},
	shaderName = "basic2d",
	textureName = "startOff.png",
	rotation = rotation,
}
table.insert(layer1.propContainer, prop);


layers = {};
table.insert(layers, layer1);

local function pickleThis()
	layerCount = 0;
	for k,v in pairs(layers) do
		file = io.open(".\\generated\\pause"..".lua", "wt");
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
