dofile("Pickle.lua")

layer1 = {
	type = "Layer",
	name = "Layer1",
	visible = "true",
	propContainer = {},
	position = {x = 24, y = 42, z = 0};
};

width = 1280;
height = 720;
objectCount = 1;
for i = 1, objectCount do
	prop = {
		type = "MOAIPropCube",
		["name"] = "Prop"..i,
		position = {
			x = math.cos(i) * i * width / objectCount,
			y = math.sin(i) * i * width / objectCount,
			z = math.random(-5000, 1500),
		}
	}
	table.insert(layer1.propContainer, prop);
end

local function pickleThis()
	file = io.open("pickleFile.lua", "wt");
	s = "deserialize (\"Layer\",\n";
	file:write(s);
	s = pickle(layer1);
	file:write(s);
	s = ")\n\n";
	file:write(s);
	file:close();
end

----------------------------------------------
-- unpickle
----------------------------------------------

function unpickleMe(s)
  local tables = s;
  
  for tnum = 1, table.getn(tables) do
    local t = tables[tnum]
    local tcopy = {}; for i, v in pairs(t) do tcopy[i] = v end
    for i, v in pairs(tcopy) do
      local ni, nv
      if type(i) == "table" then ni = tables[i[1]] else ni = i end
      if type(v) == "table" then nv = tables[v[1]] else nv = v end
      t[i] = nil
      t[ni] = nv
    end
  end
  return tables[1]
end

local function unpickleThis()
	function deserialize(arg1, pickle)
		print(arg1);
		up = unpickleMe( pickle );
		print(up.name);
		for k,prop in pairs(up.propContainer) do
			print(prop.name);
		end
	end
	dofile("pickleFile.lua");
end

pickleThis();
unpickleThis();