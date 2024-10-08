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
    animator.playSound("on")
    object.setLightColor(config.getParameter("lightColor", {255, 255, 255}))
  elseif #players == 0 and animator.animationState("portal") == "on" then
    animator.setAnimationState("portal", "close")
    animator.playSound("off")
    object.setLightColor({0, 0, 0, 0})
  end
end

function onInteraction(args)
  if config.getParameter("returnDoor") then
    return { "OpenTeleportDialog", {
        canBookmark = false,
        includePlayerBookmarks = false,
        destinations = { {
          name = "Airlock door",
          planetName = "Main Lobby",
          icon = "gs_srs",
          warpAction = "Return"
        } }
      }
    }
  else
    return { "OpenTeleportDialog", {
        canBookmark = false,
        includePlayerBookmarks = false,
        destinations = { {
          name = "Airlock door",
          planetName = "Gunners Tactical Operation Center",
          icon = "gs_srs",
          warpAction = string.format("InstanceWorld:operation_gunnerscarrier_toc:%s:%s", storage.uuid, world.threatLevel())
        } }
      }
    }
  end
end
