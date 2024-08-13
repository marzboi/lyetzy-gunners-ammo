Gunshoplight = WeaponAbility:new()

function Gunshoplight:init()
  self:reset()
end

function Gunshoplight:update(dt, fireMode, shiftHeld)
  WeaponAbility.update(self, dt, fireMode, shiftHeld)

  if self.fireMode == "alt" and self.lastFireMode ~= "alt" then
    self.active = true
    animator.setLightActive("gunshoplight", self.active)
    animator.setLightActive("gunshoplightSpread", self.active)
  end
  self.lastFireMode = fireMode
end

function Gunshoplight:reset()
  animator.setLightActive("gunshoplight", true)
  animator.setLightActive("gunshoplightSpread", true)
  self.active = true
end

function Gunshoplight:uninit()
  self:reset()
end
