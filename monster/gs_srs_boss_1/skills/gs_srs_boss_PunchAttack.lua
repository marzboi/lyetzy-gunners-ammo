gs_srs_boss_PunchAttack = {}

--------------------------------------------------------------------------------
function gs_srs_boss_PunchAttack.enter()
  if not hasTarget() then return nil end

  return {
    distanceRange = config.getParameter("gs_srs_boss_PunchAttack.distanceRange"),
    winddownTimer = config.getParameter("gs_srs_boss_PunchAttack.winddownTime"),
    windupTimer = config.getParameter("gs_srs_boss_PunchAttack.windupTime"),
    punching = false
  }
end

--------------------------------------------------------------------------------
function gs_srs_boss_PunchAttack.enteringState(stateData)
  animator.setAnimationState("movement", "idle")

  monster.setActiveSkillName("gs_srs_boss_PunchAttack")
end

--------------------------------------------------------------------------------
function gs_srs_boss_PunchAttack.update(dt, stateData)
  if not hasTarget() then return true end

  local toTarget = world.distance(self.targetPosition, mcontroller.position())
  local targetDir = util.toDirection(toTarget[1])

  if not stateData.punching then 
    if math.abs(toTarget[1]) > stateData.distanceRange[2] then
      animator.setAnimationState("movement", "move")
      mcontroller.controlMove(util.toDirection(toTarget[1]), true)
    elseif math.abs(toTarget[1]) < stateData.distanceRange[1] then
      mcontroller.controlMove(util.toDirection(-toTarget[1]), true)
      animator.setAnimationState("movement", "move")
      mcontroller.controlFace(targetDir)
    else
      stateData.punching = true
    end
  else
    mcontroller.controlFace(targetDir)
    if stateData.windupTimer > 0 then
      if stateData.windupTimer == config.getParameter("gs_srs_boss_PunchAttack.windupTime") then
      animator.setAnimationState("movement", "punch")
      end
      stateData.windupTimer = stateData.windupTimer - dt
    elseif stateData.winddownTimer > 0 then
      if stateData.winddownTimer == config.getParameter("gs_srs_boss_PunchAttack.winddownTime") then
        gs_srs_boss_PunchAttack.punch(targetDir)
        animator.playSound("punch")
      end
      stateData.winddownTimer = stateData.winddownTimer - dt
    else
      return true
    end
  end


  return false
end

function gs_srs_boss_PunchAttack.punch(direction)
  local projectileType = config.getParameter("gs_srs_boss_PunchAttack.projectile.type")
  local projectileConfig = config.getParameter("gs_srs_boss_PunchAttack.projectile.config")
  local projectileOffset = config.getParameter("gs_srs_boss_PunchAttack.projectile.offset")
  
  if projectileConfig.power then
    projectileConfig.power = projectileConfig.power * root.evalFunction("monsterLevelPowerMultiplier", monster.level())
  end

  world.spawnProjectile(projectileType, monster.toAbsolutePosition(projectileOffset), entity.id(), {direction, 0}, true, projectileConfig)
end

function gs_srs_boss_PunchAttack.leavingState(stateData)
  monster.setActiveSkillName("")
end
