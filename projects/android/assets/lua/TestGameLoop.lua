local done = false;

local function moaiFooTest() 
  local foo = MOAIFoo.new();
  foo:instanceHello();
  MOAIFooMgr.singletonHello();
  MOAIFoo.classHello();
end

local function moaiMetaBallTest()
  local metaBall = MOAIMetaBall.new();
  metaBall:instanceHello();
  MOAIMetaBall.classHello();
  MOAIMetaBallMgr.singletonHello();
end

local function init()
  moaiFooTest();
  moaiMetaBallTest();
end

function testGameLoop ()
  init();

	while not done do
		coroutine.yield()

	end
end

return testGameLoop;