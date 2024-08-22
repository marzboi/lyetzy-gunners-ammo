require "/scripts/util.lua"
require "/scripts/interp.lua"

-- Base gun fire ability
GunFire = WeaponAbility:new()

function GunFire:init()
  self.weapon:setStance(self.stances.idle)

  self.cooldownTimer = 0

  self.maxAmmo = config.getParameter("totalAmmo")

  self.weapon.onLeaveAbility = function()
    self.weapon:setStance(self.stances.idle)
  end
end

function GunFire:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  self.cooldownTimer = math.max(0, self.cooldownTimer - self.dt)

  if self.fireMode == (self.activatingFireMode or self.abilitySlot)
    and not self.weapon.currentAbility
    and self.cooldownTimer == 0
    and not world.lineTileCollision(mcontroller.position(), self:firePosition()) then

    if self.fireType == "auto" then
      self:reload()
      self:setState(self.auto)
    end
  end
end

function GunFire:auto()
  self.weapon:setStance(self.stances.fire)
  animator.setParticleEmitterActive("smoke", true)
  animator.setParticleEmitterActive("smoke2", true)
  animator.setParticleEmitterActive("smoke3", true)
  
  self:fireProjectile()
    animator.playSound("altFire")

  local progress = 0
  util.wait(self.stances.fire.duration, function()
    local from = self.stances.fire.weaponOffset or {0,0}
    local to = self.stances.motion1.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.fire.weaponRotation, self.stances.motion1.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.fire.armRotation, self.stances.motion1.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.fire.duration))
  end)

  self:setState(self.motion1)
end

function GunFire:motion1()
  self.weapon:setStance(self.stances.motion1)

  local progress = 0
  util.wait(self.stances.motion1.duration, function()
    local from = self.stances.motion1.weaponOffset or {0,0}
    local to = self.stances.motion2.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion1.weaponRotation, self.stances.motion2.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion1.armRotation, self.stances.motion2.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion1.duration))
  end)

  self:setState(self.motion2)
end

function GunFire:motion2()
  self.weapon:setStance(self.stances.motion2)

  local progress = 0
  util.wait(self.stances.motion2.duration, function()
    local from = self.stances.motion2.weaponOffset or {0,0}
    local to = self.stances.motion3.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion2.weaponRotation, self.stances.motion3.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion2.armRotation, self.stances.motion3.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion2.duration))
  end)

  self:setState(self.motion3)
end

function GunFire:motion3()
  self.weapon:setStance(self.stances.motion3)
  animator.setParticleEmitterActive("smoke", false)
  animator.setParticleEmitterActive("smoke2", false)

  local progress = 0
  util.wait(self.stances.motion3.duration, function()
    local from = self.stances.motion3.weaponOffset or {0,0}
    local to = self.stances.motion4.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion3.weaponRotation, self.stances.motion4.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion3.armRotation, self.stances.motion4.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion3.duration))
  end)

  self:setState(self.motion4)
end

function GunFire:motion4()
  self.weapon:setStance(self.stances.motion4)

  local progress = 0
  util.wait(self.stances.motion4.duration, function()
    local from = self.stances.motion4.weaponOffset or {0,0}
    local to = self.stances.motion5.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion4.weaponRotation, self.stances.motion5.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion4.armRotation, self.stances.motion5.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion4.duration))
  end)

  self:setState(self.motion5)
end

function GunFire:motion5()
  self.weapon:setStance(self.stances.motion5)

  local progress = 0
  util.wait(self.stances.motion5.duration, function()
    local from = self.stances.motion5.weaponOffset or {0,0}
    local to = self.stances.motion6.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion5.weaponRotation, self.stances.motion6.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion5.armRotation, self.stances.motion6.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion5.duration))
  end)

  self:setState(self.motion6)
end

function GunFire:motion6()
  self.weapon:setStance(self.stances.motion6)

  local progress = 0
  util.wait(self.stances.motion6.duration, function()
    local from = self.stances.motion6.weaponOffset or {0,0}
    local to = self.stances.motion7.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion6.weaponRotation, self.stances.motion7.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion6.armRotation, self.stances.motion7.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion6.duration))
  end)

  self:setState(self.motion7)
end

function GunFire:motion7()
  self.weapon:setStance(self.stances.motion7)

  local progress = 0
  util.wait(self.stances.motion7.duration, function()
    local from = self.stances.motion7.weaponOffset or {0,0}
    local to = self.stances.motion8.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion7.weaponRotation, self.stances.motion8.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion7.armRotation, self.stances.motion8.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion7.duration))
  end)

  self:setState(self.motion8)
end

function GunFire:motion8()
  self.weapon:setStance(self.stances.motion8)

  local progress = 0
  util.wait(self.stances.motion8.duration, function()
    local from = self.stances.motion8.weaponOffset or {0,0}
    local to = self.stances.motion9.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion8.weaponRotation, self.stances.motion9.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion8.armRotation, self.stances.motion9.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion8.duration))
  end)

  self:setState(self.motion9)
end

function GunFire:motion9()
  self.weapon:setStance(self.stances.motion9)

  local progress = 0
  util.wait(self.stances.motion9.duration, function()
    local from = self.stances.motion9.weaponOffset or {0,0}
    local to = self.stances.motion10.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion9.weaponRotation, self.stances.motion10.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion9.armRotation, self.stances.motion10.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion9.duration))
  end)

  self:setState(self.motion10)
end

function GunFire:motion10()
  self.weapon:setStance(self.stances.motion10)

  local progress = 0
  util.wait(self.stances.motion10.duration, function()
    local from = self.stances.motion10.weaponOffset or {0,0}
    local to = self.stances.motion11.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion10.weaponRotation, self.stances.motion11.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion10.armRotation, self.stances.motion11.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion10.duration))
  end)

  self:setState(self.motion11)
end

function GunFire:motion11()
  self.weapon:setStance(self.stances.motion11)

  local progress = 0
  util.wait(self.stances.motion11.duration, function()
    local from = self.stances.motion11.weaponOffset or {0,0}
    local to = self.stances.motion12.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion11.weaponRotation, self.stances.motion12.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion11.armRotation, self.stances.motion12.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion11.duration))
  end)

  self:setState(self.motion12)
end

function GunFire:motion12()
  self.weapon:setStance(self.stances.motion12)

  local progress = 0
  util.wait(self.stances.motion12.duration, function()
    local from = self.stances.motion12.weaponOffset or {0,0}
    local to = self.stances.cooldown.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.motion12.weaponRotation, self.stances.cooldown.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.motion12.armRotation, self.stances.cooldown.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.motion12.duration))
  end)

  self:setState(self.cooldown)
end

function GunFire:cooldown()
  self.weapon:setStance(self.stances.cooldown)
  self.weapon:updateAim()

  local progress = 0
  util.wait(self.stances.cooldown.duration, function()
    local from = self.stances.cooldown.weaponOffset or {0,0}
    local to = self.stances.idle.weaponOffset or {0,0}
    self.weapon.weaponOffset = {interp.linear(progress, from[1], to[1]), interp.linear(progress, from[2], to[2])}

    self.weapon.relativeWeaponRotation = util.toRadians(interp.linear(progress, self.stances.cooldown.weaponRotation, self.stances.idle.weaponRotation))
    self.weapon.relativeArmRotation = util.toRadians(interp.linear(progress, self.stances.cooldown.armRotation, self.stances.idle.armRotation))

    progress = math.min(1.0, progress + (self.dt / self.stances.cooldown.duration))
  end)
  animator.setParticleEmitterActive("smoke3", false)
end

function GunFire:fireProjectile(projectileType, projectileParams, inaccuracy, firePosition, projectileCount)
  local params = sb.jsonMerge(self.projectileParameters, projectileParams or {})
  params.power = self:damagePerShot()
  params.powerMultiplier = activeItem.ownerPowerMultiplier()
  params.speed = util.randomInRange(params.speed)

  if not projectileType then
    projectileType = self.projectileType
  end
  if type(projectileType) == "table" then
    projectileType = projectileType[math.random(#projectileType)]
  end

  local projectileId = 0
  for i = 1, (projectileCount or self.projectileCount) do
    if params.timeToLive then
      params.timeToLive = util.randomInRange(params.timeToLive)
    end

    projectileId = world.spawnProjectile(
        projectileType,
        firePosition or self:firePosition(),
        activeItem.ownerEntityId(),
        self:aimVector(inaccuracy or self.inaccuracy),
        false,
        params
      )
  end
  return projectileId
end

function GunFire:firePosition()
  return vec2.add(mcontroller.position(), activeItem.handPosition(self.weapon.muzzleOffset))
end

function GunFire:aimVector(inaccuracy)
  local aimVector = vec2.rotate({1, 0}, self.weapon.aimAngle + sb.nrand(inaccuracy, 0))
  aimVector[1] = aimVector[1] * mcontroller.facingDirection()
  return aimVector
end

function GunFire:energyPerShot()
  storage.totalAmmo = self.maxAmmo
  self.totalAmmo = storage.totalAmmo
end

function GunFire:damagePerShot()
  return (self.baseDamage or self.baseDps ) * (self.baseDamageMultiplier or 1.0) * config.getParameter("damageLevelMultiplier") / self.projectileCount
end

function GunFire:uninit()
end
