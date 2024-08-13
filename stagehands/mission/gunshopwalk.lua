require "/scripts/util.lua"
require "/scripts/rect.lua"

function init()
end

function playerScan()
  local players = world.players()
  local newPlayers = util.filter(players, function(entityId)
    return contains(self.players, entityId)
  end)
  self.players = players
end

function update(dt)  
  for _,playerId in pairs(self.players) do
  mcontroller.controlModifiers({
	  runningSuppressed = true
    })
  end
  playerScan()
end

