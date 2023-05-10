
DEFINE_BASECLASS( 'igfl_base' )

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'IGF Lite Silenced Weapon Base'
SWEP.Author               = 'DyaMetR'
SWEP.Instructions         = 'ATTACK for primary fire\nATTACK2 to aim down sights\nUSE + ATTACK to toggle safety\nUSE + ATTACK2 to attach/dettach silencer'
SWEP.Category             = 'IGF Lite'

SWEP.SilencedSound        = nil

local animations = {
  ['draw'] = ACT_VM_DRAW_SILENCED,
  ['idle'] = ACT_VM_IDLE_SILENCED,
  ['attack'] = ACT_VM_PRIMARYATTACK_SILENCED,
  ['attack2'] = ACT_VM_PRIMARYATTACK_SILENCED,
  ['reload'] = ACT_VM_RELOAD_SILENCED
}

function SWEP:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Bool', 9, 'Silenced')
  self:NetworkVar('Float', 10, 'NextSilenced')
end

-- select silenced animations
function SWEP:SelectAnimation(animation)
  if not self:GetSilenced() then return BaseClass.SelectAnimation(self, animation) end
  return animations[animation]
end

-- whether the weapon is successfully silenced
function SWEP:IsSilenced()
  return self:GetSilenced() and self:GetNextSilenced() < CurTime()
end

-- cancel silencer process
function SWEP:Holster()
  if self:GetNextSilenced() > CurTime() then
    self:SetSilenced(not self:GetSilenced())
  end
  return true
end

-- return the silenced weapon (if silencer is on)
function SWEP:GetPrimarySound()
  if not self:GetSilenced() or not self.Primary.SilencedSound then return BaseClass.GetPrimarySound(self) end
  return self.Primary.SilencedSound
end

-- disable ironsights when toggling silencer
function SWEP:CanIronSights()
  return BaseClass.CanIronSights(self) and not self:GetOwner():KeyDown(IN_USE)
end

-- switch silencer
function SWEP:SecondaryAttack()
  if self:GetNextPrimaryFire() > CurTime() or self:GetNextSilenced() > CurTime() then return end
  if self:GetOwner():KeyDown(IN_USE) then
    if SERVER then
      if self:GetSilenced() then
        self:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
      else
        self:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
      end
      self:SetSilenced(not self:GetSilenced())
    end
    local animation_time = self:GetOwner():GetViewModel():SequenceDuration()
    self:SetNextSilenced(CurTime() + animation_time)
    self:SetNextPrimaryFire(CurTime() + animation_time)
    self.ReloadingTime = CurTime() + animation_time
    self:SetToIdleAnim(true)
    self:SetNextIdle(CurTime() + animation_time)
  else
    BaseClass.SecondaryAttack(self)
  end
end
