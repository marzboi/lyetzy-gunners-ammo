require "/scripts/util.lua"

function init()
  self.detectArea = config.getParameter("detectArea")
  self.detectArea[1] = object.toAbsolutePosition(self.detectArea[1])
  self.detectArea[2] = object.toAbsolutePosition(self.detectArea[2])

  animator.setAnimationState("portal", "off")
  object.setLightColor({0, 0, 0, 0})

  storage.uuid = storage.uuid or sb.makeUuid()
  object.setInteractive(true)

  message.setHandler("onTeleport", function(message, isLocal, data)
      if not config.getParameter("returnDoor") then
        if not (animator.animationState("portal") == "open" or animator.animationState("portal") == "on") then
          animator.setAnimationState("portal", "open")
        end
      end
    end)

  if config.getParameter("messagePlayerInterval") then
    self.radioMessage = util.interval(config.getParameter("messagePlayerInterval"), function()
      local nearPlayers = world.entityQuery(object.position(), config.getParameter("messagePlayerRange"), {includedTypes = {"player"}})
      nearPlayers = util.filter(nearPlayers, entity.entityInSight)
      for _,playerId in pairs(nearPlayers) do
        world.sendEntityMessage(playerId, "queueRadioMessage", "challengedoor")
      end
    end)
  end
end

function update(dt)
  
  if self.radioMessage ~= nil then
    self.radioMessage(dt)
  end

  if animator.animationState("portal") == "gone" then
    object.smash()
  end

  local players = world.entityQuery(self.detectArea[1], self.detectArea[2], {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
    })

  if #players > 0 and animator.animationState("portal") == "off" then
    animator.setAnimationState("portal", "open")
    animator.stopAllSounds("off")
    animator.playSound("on", -1)
    object.setLightColor(config.getParameter("lightColor", {255, 255, 255}))
  elseif #players == 0 and animator.animationState("portal") == "on" then
    animator.setAnimationState("portal", "close")
    animator.stopAllSounds("on")
    animator.playSound("off", -1)
    object.setLightColor({0, 0, 0, 0})
  end
end

function onInteraction(args)
  if config.getParameter("returnDoor") then
    return { "OpenTeleportDialog", {
        canBookmark = false,
        includePlayerBookmarks = false,
        destinations = { {
          name = "Episode.0 complete!",
          planetName = "^red;WARNING^yellow;Take teleporter before going back!",
          icon = "return",
          warpAction = "Return"
        } }
      }
    }
  else
    return { "OpenTeleportDialog", {
        canBookmark = false,
        includePlayerBookmarks = false,
        destinations = { {
          name = "^red;Do you really want to skip EP.0?",
          planetName = "^yellow;CHEAT ACTIVATE",
          icon = "gs_srs",
          warpAction = string.format("InstanceWorld:operation_gunnerscarrier_0:%s:%s", storage.uuid, world.threatLevel())
        } }
      }
    }
  end
end
