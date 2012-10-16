local test = {};
test.metaballCreationCount = 3;
test.metaballs = {};
test.time = 0;
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
  --self:moveRot(math.random(0, 360), math.random(0, 360) , math.random(0, 360), math.random(0, 10), MOAIEaseType.LINEAR);
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
    test.metaballs[i]:moveRot(math.random(0, 360), math.random(0, 360) , math.random(0, 360), math.random(5, 10), MOAIEaseType.LINEAR);
    
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
    test.time = MOAISim.getElapsedFrames;
end

local function shaderTest()
  local file = assert ( io.open ( 'shader.vsh', mode ))
  vsh = file:read ( '*all' )
  file:close ()

  local file = assert ( io.open ( 'shader.fsh', mode ))
  fsh = file:read ( '*all' )
  file:close ()

  local gfxQuad = MOAIGfxQuad2D.new ()
  gfxQuad:setTexture ( "moai.png" )
  gfxQuad:setRect ( -64, -64, 64, 64 )
  gfxQuad:setUVRect ( 0, 1, 1, 0 )

  -- create metaball to hook shader to
  local metaball = MOAIMetaBall.new();
  metaball:setDeck(gfxQuad);
  metaball:moveRot(0, 0, 360, 5, MOAIEaseType.LINEAR);
  layer:insertProp(metaball);
  
  local color = MOAIColor.new ()
  color:setColor ( 0, 0, 1, 0 )
  color:seekColor(1, 1, 1, 1, 5, MOAIEaseType.LINEAR);
  --color:moveColor(1, 1, 1, 0, 1 );

  local shader = MOAIShader.new ()
  shader:reserveUniforms ( 1 )
  shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

  shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )

  shader:setVertexAttribute ( 1, 'position' )
  shader:setVertexAttribute ( 2, 'uv' )
  shader:setVertexAttribute ( 3, 'color' )
  shader:load ( vsh, fsh )

  gfxQuad:setShader ( shader )
end

local function kenShaderTest()
  -- load the shaders
  local file = nil;
  file = assert( io.open("ken.vsh", "r") );
  vertexShaderString = file:read("*all");
  file:close();
  
  file = assert( io.open("ken.fsh", "r") );
  fragmentShaderString = file:read("*all");
  file:close();
  
  local shader = MOAIShader.new();
  
  -- create a timer node to link shader attribute
  function createTimer (span)
    local timer = MOAITimer.new ()
    timer:setSpan ( span )
    timer:setMode ( MOAITimer.LOOP )
    timer:setListener ( MOAITimer.EVENT_TIMER_LOOP,
      function ()
        print ( "Loop Callback" )
      end
    )
    timer:start ()
    print ( "Timer started." )
    return timer;
  end
  
    -- initialize the shader attribute bindings
  shader:reserveUniforms(1);
  shader:declareUniform(1, "timeUniform", MOAIShader.UNIFORM_FLOAT );
  shader:setAttrLink(1, createTimer(20), MOAITimer.ATTR_TIME);
  shader:setVertexAttribute(1, 'position');
  shader:setVertexAttribute(2, 'uv');
  shader:setVertexAttribute(3, 'color');
  
  shader:load( vertexShaderString, fragmentShaderString );
  
  -- create the texture
  local texture = MOAITexture.new();
  texture:load("moai.png");
  texture:setWrap(true);
  texture:setFilter(MOAITexture.GL_LINEAR_MIPMAP_LINEAR);
  
  -- create the geometry
  local quad = MOAIGfxQuad2D.new();
  quad:setTexture(texture);
  quad:setRect(-64, -64, 64, 64);
  quad:setUVRect(0, 1, 1, 0); -- Window style coordinates
  
  -- attach shader to geometry
  quad:setShader(shader);
  
  -- create the prop and attach geometry
  local prop = MOAIMetaBall.new();
  prop:setDeck( quad );
  
  -- set the prop into scene
  layer:insertProp(prop);
  prop:setLoc(300, 300);
  
  
end

local function runTests()
  moaiFooTest();
  moaiMetaBallTest();
  --printAllMoaiExports();
  --printAllFunctionsOf( MOAIMetaBall.new() );
  --shaderTest();
  kenShaderTest();
end

local done = false;
function testGameLoop ()
  init();
  runTests();
	while not done do
    update();
    coroutine.yield()
	end
end

return testGameLoop;