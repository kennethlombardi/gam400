local Android = {};
Android.key = {};
Android.window = {x = 0, y = 0;};			--place of last tap in window space
Android.world = {x = 0; y = 0;};			--place of last tap in world space
Android.accel = {x = 0; y = 0; z = 0;};		--current state of gyro
Android.baseAccel = {x = 0; y = 0; z = 0;};	--base state of gyro (used for calibration)
Android.key[0] = {false, false, false};

local function PushBack(key, pressed)
	Android.key[key][1] = true;
	Android.key[key][3] = Android.key[key][2];
	Android.key[key][2] = pressed;	
end

local function SetKey(key, pressed)
	PushBack(key, pressed);
end


local function PressKey(key)
	SetKey(key, true);
end

local function RaiseKey(key)
	SetKey(key, false);
end

function Android:IsKeyPressed(key)	
	if self.key[key][2] == true and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Android:IsKeyReleased(key)	
	if self.key[key][2] == false and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Android:IsKeyTriggered(key)
	if self.key[key][2] == true and self.key[key][3] == false then
		return true;
	end
	return false;
end

function Android:Update(dt)
	if Android.key[0][1] == false then
		PushBack(0, Android.key[0][2]);
	end
	Android.key[0][1] = false;
	--need to throw in calibration here
	--if tap is in top-left corner
	--calibrate, simple enough, no?
end

function Android:Calibrate()
	Android.baseAccel = Android.accel;
end

function Android:GetWorldTap(layer)
	self.world.x, self.world.y = (layer:wndToWorld(self.window.x, self.window.y));
end

MOAIInputMgr.device.touch:setCallback (					
	function ( eventType, idx, x, y, tapCount )						
		if eventType == MOAITouchSensor.TOUCH_DOWN then			
			--wx,wy = (layer:wndToWorld(x,y))
			Android.window.x = x;
			Android.window.y = y;			
			PressKey(0);
		else
			RaiseKey(0);
		end
	end
)

 MOAIInputMgr.device.level:setCallback(  --gyro
	function(x, y, z)
	  Android.accel.x = x;
	  Android.accel.y = y;
	  Android.accel.z = z;
	end
)