GameVariables = {};

GameVariables.gameTimer = 0;
GameVariables.playerPosition = {x = 0, y = 0, z = 0};
GameVariables.lastPosition = {x = 0, y = 0, z = 0};
GameVariables.speed = 0;
GameVariables.score = 0;
GameVariables.distance = 0;
GameVariables.highscore = 0;
GameVariables.gameLayer = 0;


--DISTANCE
function GameVariables:GetDistance()
  return GameVariables.distance;
end

function GameVariables:AddDistance(dt)
  GameVariables.distance = GameVariables.distance + dt;
end

function GameVariables:SetDistance(newdist)
  GameVariables.distance = newdist;
end


--LAYER
function GameVariables:GetLayer()
  return GameVariables.gameLayer;
end

function GameVariables:SetLayer(l)
  GameVariables.gameLayer = l;
end


--POSITION
function GameVariables:GetPlayerPos()
  return GameVariables.playerPosition;
end

function GameVariables:SetPlayerPos(newpos)
  if newpos then
    GameVariables.lastPosition = {x = GameVariables.playerPosition.x, y = GameVariables.playerPosition.y, z = GameVariables.playerPosition.z};
    GameVariables.playerPosition = {x = newpos.x, y = newpos.y, z = newpos.z};
    GameVariables.speed = GameVariables.lastPosition.z - GameVariables.playerPosition.z;
  end
end


--SCORE
function GameVariables:GetScore()
  return GameVariables.score;
end

function GameVariables:AddScore(dt)
  GameVariables.score = GameVariables.score + dt;
end

function GameVariables:GetHighScore()
  return GameVariables.highscore;
end

function GameVariables:SetHighScore(newhigh)
  GameVariables.highscore = newhigh;
end


--SPEED
function GameVariables:GetSpeed()
  return GameVariables.speed;
end

--TIMER
function GameVariables:GetGameTimer()
  return GameVariables.gameTimer;
end

function GameVariables:SetGameTimer(dt)
  GameVariables.gameTimer = dt;
end

function GameVariables:AddGameTimer(dt)
  GameVariables.gameTimer = GameVariables.gameTimer + dt;
end

function GameVariables:shutdown()
  GameVariables.gameTimer = 0;
  GameVariables.playerPosition = {};
  GameVariables.lastPosition = {};
  GameVariables.speed = 0;
  GameVariables.score = 0;
  GameVariables.distance = 0;
  GameVariables.highscore = 0;
  GameVariables.gameLayer = 0;
end

return GameVariables;
