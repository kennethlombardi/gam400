GameVariables = {};

GameVariables.gameTimer = 0;
GameVariables.playerPosition = {x = 0, y = 0, z = 0};
GameVariables.lastPosition = {x = 0, y = 0, z = 0};
GameVariables.speed = 0;
GameVariables.score = 0;

function GameVariables:GetPlayerPos()
  return GameVariables.playerPosition;
end

return GameVariables;
