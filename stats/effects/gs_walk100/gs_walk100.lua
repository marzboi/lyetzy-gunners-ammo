function init()
  effect.addStatModifierGroup({
    {stat = "jumpModifier", amount = -0.3}
  })
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = 1.0,
      speedModifier = 1.0,
      airJumpModifier = 1.0,
	  runningSuppressed = true
    })
end

function uninit()

end
