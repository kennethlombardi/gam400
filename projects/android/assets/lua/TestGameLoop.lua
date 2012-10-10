local done = false;

local foo = MOAIFoo.new();
foo:instanceHello();
MOAIFooMgr.singletonHello();
MOAIFoo.classHello();

local metaBall = MOAIMetaBall.new();
metaBall:instanceHello();
MOAIMetaBall.classHello();
MOAIMetaBallMgr.singletonHello();

function testGameLoop ()
	while not done do
		coroutine.yield()

	end
end
