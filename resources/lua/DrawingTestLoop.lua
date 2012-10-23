objects = {}

function drawCircle ( x, y, radius )
        local function circle()
                MOAIGfxDevice.setPenColor ( 0.4, 1, 0, 1 )
                MOAIDraw.fillCircle ( x, y, radius )

        end
        scriptDeck = MOAIScriptDeck.new ()
        scriptDeck:setRect ( -radius, -radius, radius, radius )
        scriptDeck:setDrawCallback ( circle )
     
        prop = MOAIProp2D.new ()
        prop:setDeck ( scriptDeck )
        layer:insertProp ( prop )

end


local function draw()
  for k, v in pairs(objects) do

  end
	
end

local function update()
  draw();
end

local function init()
  objects[1] = MOAIFoo.new();
  objects[1].draw = draw;
	drawCircle(33, 33, 50)
	drawCircle(33, -33, 5)
	drawCircle(-33, -33, 5)
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