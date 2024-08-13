dieState = {}

function dieState.enterWith(args)
  if not args.die then return nil end

  return {
    timer = 0.5
  }
end

function dieState.enteringState(stateData)
  world.spawnProjectile("gs_srs_boss_1_deadbody_start", mcontroller.position())
end

function dieState.update(dt, stateData)
  if stateData.timer <= 0.0 then
    self.dead = true
  end

  stateData.timer = stateData.timer - dt
  return false
end
