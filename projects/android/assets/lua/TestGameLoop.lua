local test = {};
test.metaballCreationCount = 100;
test.metaballs = {};
font = MOAIFont.new();
font:loadFromTTF ( "arial-rounded.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!", 12, 163 )


local function moaiFooTest() 
  local foo = MOAIFoo.new();
  foo:instanceHello();
  MOAIFooMgr.singletonHello();
  MOAIFoo.classHello();
end

local function metaBallUpdate (self)
  --self:setLoc( math.random(-1080 / 2, 1080 / 2), math.random(-720 / 2, 720 / 2) );
end

local function moaiMetaBallTest()
  local metaBall = MOAIMetaBall.new();
  metaBall:instanceHello();
  MOAIMetaBall.classHello();
  --MOAIMetaBallMgr.singletonHello();
  
  -- create a bunch of metaballs
  local metaballCount = test.metaballCreationCount;
  local successfulMetaballCreation = false;
  local gfxQuad = MOAIGfxQuad2D.new ()
  gfxQuad:setTexture ( "moai.png" )
  gfxQuad:setRect ( -128, -128, 128, 128 )
  gfxQuad:setUVRect ( 0, 0, 1, 1 )
  for i = 1, metaballCount do
    test.metaballs[i] = MOAIMetaBall.new();
    test.metaballs[i].update = metaBallUpdate;
    test.metaballs[i].index = i;
    
    -- hook ball up to graphic    
    test.metaballs[i]:setDeck( gfxQuad );
    test.metaballs[i]:setLoc( math.random(-1080 / 2, 1080 / 2), math.random(-720 / 2, 720 / 2) );
    layer:insertProp ( test.metaballs[i] );
    test.metaballs[i]:moveRot ( 60, 1.5 )
    
    if i == metaballCount then
      successfulMetaballCreation = true;
    end
  end
  if successfulMetaballCreation then
    print("Created " .. metaballCount .. " metaballs");
  else
    print("Metaball creation failed creating " .. metaballCount .. " metaballs");
  end
end

-- see http://moaisnippets.com/discover-all-moai-classes-which-export-new
function GetStaticStatus(T)
        local static = false;

        if type(T) == "table" then
                for n in pairs(T) do
                        if n == 'new' then
                                return "new()"
                        end                        
                end
                static = true;
        end
        mt = getmetatable(T)

        if mt and type(mt.__index)=="table" then
                for n,m in pairs (mt.__index) do
                        if n == 'new' then return "new()" end
                end
                static = true
        elseif mt and type(mt.__index)=="function" then
                return "?? - __index is a function."
        end

        if static then
                return "static"
        else
                return "# Not a class."
        end
end

local function printAllMoaiExports()
  acc= {}
  for k,v in pairs(_G) do
      if k:find"MOAI" then table.insert(acc,k) end
  end

  table.sort(acc)

  for _,k in ipairs(acc) do
          print (k, GetStaticStatus(_G[k]))
  end
end
 
local function printAllFunctionsOf(o)
  for key,value in pairs(getmetatable(o)) do
    print(key, value);
  end
end

local function init()
  moaiFooTest();
  moaiMetaBallTest();
  --printAllMoaiExports();
  --printAllFunctionsOf( MOAIMetaBall.new() );
  
  ---[[ fps counter
  fpscounter = MOAITextBox.new()
  fpscounter:setFont(font)
  fpscounter:setTextSize(24)
  fpscounter:setRect(-50, -50, 50, 50)
  fpscounter:setLoc(-550, 300)
  fpscounter:setAlignment(MOAITextBox.LEFT_JUSTIFY)
  fpscounter:setYFlip(true)
  layer:insertProp(fpscounter)
  --]]
end

local function update(dt)
    fpscounter:setString("FPS: " .. MOAISim.getPerformance())
    for i = 1, test.metaballCreationCount do
      test.metaballs[i].update(test.metaballs[i]);
    end
end

local done = false;
function testGameLoop ()
  init();

	while not done do
    update();
    coroutine.yield()
	end
end

return testGameLoop;