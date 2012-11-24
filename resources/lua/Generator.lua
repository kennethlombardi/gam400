gen = {};
gen.spawned = 1;

function gen:spawnObject(x, y)
  local obj = math.random(0, 10);
  obj = obj - 5;
  if obj >= 0 then
    return gen:spawnTorus(x, y);
  else
    return gen:spawnSphere(x, y);
  end
end

function gen:spawnTorus(x, y)
  local properties = {};
  properties.type = "Torus";
  properties.name = "Torus"..(gen.spawned);  
  local layerPosition = require("LayerManager"):getLayerByName("gameLayer.lua"):getLoc();
  local position = {};
  properties.scale = {x = 15, y = 3, z = 15};		
  position.x = x or math.random(- 200, 200);
  position.y = y or math.random(- 200, 200);
  position.z = layerPosition.z - 1500;
  properties.position = position;		
  properties.rotation = {x = 90, y = 0, z = 0};
  properties.shaderName = "shader";
  properties.scripts = {"ring.lua"};
  properties.textureName = "pinkSquare.png";
  newprop = require("Factory"):create("Torus", properties); 
  gen.spawned = gen.spawned + 1;
  return newprop;
end

function gen:spawnSphere(x, y)
  local properties = {};
  properties.type = "Sphere";
  properties.name = "Sphere"..(gen.spawned);
  local layerPosition = require("LayerManager"):getLayerByName("gameLayer.lua"):getLoc();
  local position = {};
  properties.scale = {x = 15, y = 15, z = 15};		
  position.x = x or math.random(- 200, 200);
  position.y = y or math.random(- 200, 200);
  position.z = layerPosition.z - 1500;
  properties.position = position;		
  properties.rotation = {x = 0, y = 0, z = 0};
  properties.shaderName = "shader";
  properties.scripts = {"obstacle.lua"};
  properties.textureName = "rock.png";
  newprop = require("Factory"):create("Sphere", properties);  
  gen.spawned = gen.spawned + 1;
  return newprop;
end

function NormalRnd(minVal, maxVal, count)
    local base = 0;
    for _ = 1, count do
        base = base + math.random(maxVal - minVal + 1) - 1;
    end;
    return math.ceil(base / 10); --+ minVal;
end;

function phi(x)
    a1 =  0.254829592;
    a2 = -0.284496736;
    a3 =  1.421413741;
    a4 = -1.453152027;
    a5 =  1.061405429;
    p  =  0.3275911;
    
    sign = 1;
    if x < 0 then
        sign = -1;
    end
    x = abs(x)/sqrt(2.0);
    
    t = 1.0/(1.0 + p*x);
    y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*exp(-x*x);

    return 0.5*(1.0 + sign*y);
end

return gen;