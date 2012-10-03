screenWidth = MOAIEnvironment.horizontalResolution screenHeight = MOAIEnvironment.verticalResolutionprint("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. MOAIEnvironment.osVersion)
 
--require
factory = require "ObjectFactory"
require "Persistence"
require "Test"

--test
testAll();


-- debug lines--MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS) -- screen stuff initializingif screenWidth == nil then screenWidth = 1280 endif screenHeight == nil then screenHeight = 720 endassert (not (screenWidth == nil))
MOAISim.openWindow("WAT",screenWidth,screenHeight)
viewport = MOAIViewport.new()viewport:setSize(screenWidth,screenHeight)viewport:setScale(screenWidth,screenHeight)layer = MOAILayer2D.new()layer:setViewport(viewport)MOAIRenderMgr.pushRenderPass(layer)--font junklocal font = MOAIFont.new()font:loadFromTTF ( "arial-rounded.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!", 12, 163 )local textbox = MOAITextBox.new()textbox:setFont(font)textbox:setTextSize(24)textbox:setRect(-200, -200, 200, 200)textbox:setLoc(0,100)textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY)textbox:setYFlip(true)layer:insertProp(textbox)fpscounter = MOAITextBox.new()fpscounter:setFont(font)fpscounter:setTextSize(24)fpscounter:setRect(-50, -50, 50, 50)fpscounter:setLoc(-550, 300)fpscounter:setAlignment(MOAITextBox.LEFT_JUSTIFY)fpscounter:setYFlip(true)layer:insertProp(fpscounter)ballcounter = MOAITextBox.new()ballcounter:setFont(font)ballcounter:setTextSize(24)ballcounter:setRect(-50, -50, 50, 50)ballcounter:setLoc(550, 300)ballcounter:setAlignment(MOAITextBox.LEFT_JUSTIFY)ballcounter:setYFlip(true)layer:insertProp(ballcounter)world = MOAIBox2DWorld.new()world:setGravity(0,-10)world:setUnitsToMeters(1/100)world:setDebugDrawFlags(MOAIBox2DWorld.DebugDrawShapes)world:start()layer:setBox2DWorld(world)ballc = 0--circlefunction MakeCircle(x, y)	dynbody = world:addBody (MOAIBox2DBody.DYNAMIC)	fixture = dynbody:addCircle(0, 0, 5)	dynbody:setTransform(x,y)	fixture:setFriction(0)	fixture:setRestitution(.01)	dynbody:resetMassData()	ballc = ballc + 1--dynbody:applyAngularImpulse(2)	return bodyend--edgesscreen = {	--bottom	-600, -300,	 600, -300,	--right	 600, -300,	 600,  300,	--top	 600,  300,	-600,  300,	--left	-600,  300,	-600, -300,		--goal	-400, 30,	-400, 80,	-400, 80,	-350, 80,	-400, 30,	-350, 30,		300, 300,	300, 250,		300, 30,	350, 30,	}staticbody= world:addBody(MOAIBox2DBody.STATIC)fixture2 = staticbody:addEdges(screen)--image junkslideNum = 1slides = {	"EngineProofWho.png",	"EngineProofWho1.png",	"EngineProofWho2.png",	"EngineProofWho3.png",	"EngineProofWho4.png",	"EngineProofWho5.png",
  "EngineProofWho6.png",
	"EngineProofWho7.png",
	"EngineProofWho8.png",
	"EngineProofWho9.png",
	"EngineProofWho10.png",
	"EngineProofWho11.png",
  "EngineProofWho12.png"}	image = MOAIGfxQuad2D.new()image:setTexture("EngineProofWho.png")image:setRect(-640,-360,640,360)function ChangeSlide()	image:setTexture(slides[slideNum])endprop = MOAIProp2D.new()prop:setDeck(image)layer:insertProp(prop)slideOver = falsegameOver = falselastX = 0lastY = -10function angle ( x2, y2 )	return math.atan2 ( y2, x2) * ( 180 / math.pi )endfunction RotateArrow(ang)		prop:setRot(ang)endfunction normalize(x, y)	mag = math.sqrt(x*x+y*y)	return x/mag, y/magendmainThread = MOAIThread.new()mainThread:run(	function()						while not slideshowOver do			coroutine.yield()							if MOAIInputMgr.device.pointer then							if MOAIInputMgr.device.mouseLeft:down() then					wx,wy = layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc())					if wx < 0 then						if slideNum > 1 then							slideNum = slideNum - 1						end					else						if slideNum < table.getn(slides) then							slideNum = slideNum + 1						else							slideshowOver = true						end					end					ChangeSlide()				end							else --touch and gyro				MOAIInputMgr.device.touch:setCallback (										function ( eventType, idx, x, y, tapCount )												if eventType == MOAITouchSensor.TOUCH_DOWN then							wx,wy = (layer:wndToWorld(x,y))							if wx < 0 then								if slideNum > 1 then									slideNum = slideNum - 1								end							else								if slideNum < table.getn(slides) then									slideNum = slideNum + 1								else									slideshowOver = true								end							end							ChangeSlide()						end					end				)						end		end		layer:removeProp(prop)				while not gameOver do			coroutine.yield()
      if (ballc < 50) then      
        MakeCircle(0, 0)
      end
      
      if MOAIInputMgr.device.pointer then	
        if MOAIInputMgr.device.mouseLeft:down() then
					--MakeCircle(layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
					lastX, lastY = layer:wndToWorld( MOAIInputMgr.device.pointer:getLoc())				
        end
      else	
        MOAIInputMgr.device.level:setCallback(  --gyro
            function(x, y, z)
              lastX = x
              lastY = y
            end
        )
          
        MOAIInputMgr.device.touch:setCallback (				--touch	
          function ( eventType, idx, x, y, tapCount )						
            if MOAIInputMgr.device.touch.isDown() then --eventType == MOAITouchSensor.TOUCH_DOWN then
              --MakeCircle(layer:wndToWorld(x,y))
              lastX, lastY = layer:wndToWorld(x,y)
            end
          end
        )
      end						lastX, lastY = normalize(lastX, lastY)			gravScale = 100						
      
      if not MOAIInputMgr.device.pointer then	        world:setGravity (lastY * gravScale, -lastX*gravScale)				
      else
        world:setGravity(lastX * gravScale, lastY*gravScale)
      end			--dynbody:setAwake(true)						--RotateArrow(currAngle)									textbox:setString("Gravity\n" .. "X " .. lastY*10 .. "\nY " .. lastX*10 )			fpscounter:setString("FPS: " .. MOAISim.getPerformance())			ballcounter:setString("NumBalls: " .. ballc)					end					end)