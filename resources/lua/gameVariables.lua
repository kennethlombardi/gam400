GameVariables = {};
GameVariables.globals = {};

function GameVariables:get(variableName)
	local temp = GameVariables.globals[variableName];
	return temp;
end

function GameVariables:set(variableName, value)
	GameVariables.globals[variableName] = value;	
end

function GameVariables:add(variableName, value) --only needed for some things
	GameVariables.globals[variableName] = GameVariables.globals[variableName] + value;	
end
  
function GameVariables:shutdown()
	GameVariables.globals = nil;
	GameVariables = nil;
end

function GameVariables:register(variableName, value)
	GameVariables.globals[variableName] = value;
end	

GameVariables:register("Timer", 0);
GameVariables:register("Position", {x=0, y=0, z=0});
GameVariables:register("LastPosition", {x=0, y=0, z=0});
GameVariables:register("Speed", 0);
GameVariables:register("HighScore", 0);
GameVariables:register("Distance", 0);
GameVariables:register("ShakeCamera", false);	

return GameVariables;
