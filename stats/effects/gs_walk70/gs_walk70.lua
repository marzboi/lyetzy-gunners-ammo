function init()
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = -0.3}
  })
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = 0.7,
      speedModifier = 0.7,
      airJumpModifier = 0.7,
	  runningSuppressed = true
    })
end

function uninit()

end
