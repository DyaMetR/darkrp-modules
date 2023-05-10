
DEFINE_BASECLASS( 'igfl_base' )

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'IGF Lite Shotgun Base'
SWEP.Author               = 'DyaMetR'
SWEP.Category             = 'IGF Lite'
SWEP.IsPumpShotgun        = false
SWEP.UsesClips            = false

SWEP.Primary.Spread       = Vector(1, 1, 1) -- buckshot cone
SWEP.Primary.PumpAnimation= ACT_SHOTGUN_PUMP
SWEP.Primary.PumpSound    = nil -- next shell chambering sound
SWEP.Primary.Pellets      = 8 -- how many pellets come out of a shell
SWEP.Primary.PostFireTime = 1 -- time before the pumping animation
SWEP.Primary.ReloadRate   = nil -- how often does a shell get inserted; leave at nil to let animation decide

if SERVER then
  SWEP.CancelReload = false
end

function SWEP:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Bool', 9, 'ToPumpAnim')
  self:NetworkVar('Float', 10, 'NextPump')
  self:NetworkVar('Bool', 11, 'Reloading')
  self:NetworkVar('Float', 12, 'NextShell')
end

-- stop reloading
function SWEP:Holster()
  self:SetReloading(false)
  return BaseClass.Holster(self)
end

-- cancel reload
function SWEP:PrimaryAttack()
  if self:GetReloading() and not self:GetHolster() then
    if SERVER then self.CancelReload = true end
  else
    BaseClass.PrimaryAttack(self)
  end
end

-- animates when not aiming down the sights; also pumps the weapon
function SWEP:ShootEffects()
  if not IsValid( self ) or not IsValid( self:GetOwner() ) then return end

  -- do primary attack animation
  local animation_time = 0

  if (not self:GetIronSights() or self.DoAnimationOnAim) then
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    animation_time = self:GetOwner():GetViewModel():SequenceDuration()
  end

  -- pump shotgun
  if self.IsPumpShotgun then
    self:SetNextPump(CurTime() + self.Primary.PostFireTime)
    self:SetToPumpAnim(true)
  else
    self:ResetAnimation(animation_time)
  end

  self:GetOwner():MuzzleFlash()
  self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end

-- moves the entire cone center when shooting and triggers the cocking animation
function SWEP:DoShootBullet()
  -- simulate direction
  if SERVER then self:SetRecoilDirection(math.random(-1, 1)) end

  -- get direction
  local aimVector = self:GetOwner():GetAimVector()
  aimVector.x = aimVector.x + (self:GetRecoilDirection() * self:GetCone() * .3)
  aimVector.y = aimVector.y + (math.random(0, 100) * .01) * self:GetCone()

  -- shoot pellets
  local bullet = {
    Attacker = self:GetOwner(),
    Damage = self.Primary.Damage / self.Primary.Pellets,
    Num = self.Primary.Pellets,
    AmmoType = self.Primary.Ammo,
    Dir = aimVector,
    Spread = self.Primary.Spread,
    Src = self:GetOwner():GetShootPos(),
    IgnoreEntity = self:GetOwner()
  }
  self:FireBullets(bullet)

  -- take primary ammunition
  self:TakePrimaryAmmo( 1 )

  -- do recoil
  if IsFirstTimePredicted() then
    -- make sound
    if SERVER then self:GetOwner():EmitSound(self.Primary.Sound, CHAN_WEAPON) end
    -- recoil
    self:DoRecoil(self:GetRecoilDirection())
  end

  -- do effects
  self:ShootEffects()
end

-- do pump and reload animations
function SWEP:Think()
  BaseClass.Think(self)
  -- pump animation
  if SERVER and self:GetToPumpAnim() and self:GetNextPump() < CurTime() then
    self:SetToPumpAnim(false)
    self:GetOwner():EmitSound(self.Primary.PumpSound, CHAN_WEAPON)
    self:SendWeaponAnim(self.Primary.PumpAnimation)
    local animation_time = self:GetOwner():GetViewModel():SequenceDuration()
    self:ResetAnimation(animation_time)
  end
  -- reload
  if self:GetReloading() then
    if self:GetNextShell() < CurTime() then
      if self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 or self.CancelReload then
        if SERVER then
          self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
          self.CancelReload = false
        end
        local animation_time = self:GetOwner():GetViewModel():SequenceDuration()
        self:ResetAnimation(animation_time)
        self:SetReloading(false)
      else
        if SERVER then
          self:SendWeaponAnim(ACT_VM_RELOAD)
          -- take ammo from reserve
          self:SetClip1(self:Clip1() + 1)
          self:GetOwner():SetAmmo(self:GetOwner():GetAmmoCount(self.Primary.Ammo) - 1, self.Primary.Ammo)
        end
        local animation_time = self.Primary.ReloadRate or self:GetOwner():GetViewModel():SequenceDuration()
        if CLIENT and self.Primary.ReloadSound then self:GetOwner():EmitSound(self.Primary.ReloadSound, CHAN_WEAPON) end
        self:SetNextShell(CurTime() + animation_time)
      end
    end
  end
end

-- if reloading, disable iron sights
function SWEP:CanIronSights()
  return BaseClass.CanIronSights(self) and not self:GetReloading()
end

-- reloads the shotgun
function SWEP:Reload()
  if self.UsesClips then
    BaseClass.Reload(self)
  else
    if (self:GetNextPrimaryFire() > CurTime() and self:Clip1() > 0) or self:GetReloading() or self:Clip1() >= self.Primary.ClipSize or self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then return end
    self:IronSights(false)
    self:SetToIdleAnim(false)
    self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    local animation_time = self:GetOwner():GetViewModel():SequenceDuration()
    self:SetNextShell(CurTime() + animation_time)
    self:SetReloading(true)
  end
end
