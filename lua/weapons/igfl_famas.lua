DEFINE_BASECLASS('igfl_base')

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'FAMAS F1'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 1

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_famas.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_famas.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 20
SWEP.Primary.Delay        = 0.08
SWEP.Primary.ClipSize     = 25
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_Famas.Single' )

SWEP.ShowCrosshairOnAim   = true
SWEP.ClipReady            = 1.6
SWEP.BaseCone             = 0.17
SWEP.MinCone              = 0.012
SWEP.MaxCone              = 0.26
SWEP.MoveInaccuracy       = 0.7
SWEP.AimMoveInaccuracy    = 0.37
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 1
SWEP.AimAccuracy          = 0.08
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 3.66
SWEP.BaseRecoil           = 0.28
SWEP.MaxRecoil            = 1.7
SWEP.RecoilRecovery       = 0.15
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 68

SWEP.FIREMODES            = { AUTO = 0, BURST = 1 }
SWEP.BurstDelay           = 0.5
SWEP.BurstShotDelay       = 0.06

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 't'

  SWEP.BasePos            = Vector( -2, -2, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.2, 0, 1.12 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 1.5, -4, 2 )
  SWEP.SafeAng            = Vector( -18, 30, 0 )

end

-- set burst bullets to shoot
function SWEP:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Int', 9, 'Burst')
  self:NetworkVar('Float', 10, 'NextBurstShot')
end

-- block ironsights when switching modes
function SWEP:CanIronSights()
  return BaseClass.CanIronSights(self) and not self:GetOwner():KeyDown(IN_USE)
end

-- switch firemode
function SWEP:SecondaryAttack()
  if self:GetOwner():KeyDown( IN_USE ) and self:GetNextPrimaryFire() < CurTime() then
    if self:GetMode() == self.FIREMODES.AUTO then
      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_burst.wav") end
      self:SetMode( self.FIREMODES.BURST )
      if SERVER then self:GetOwner():PrintMessage(HUD_PRINTCENTER, 'Switched to burst mode') end
    else
      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_single.wav") end
      self:SetMode( self.FIREMODES.AUTO )
      if SERVER then self:GetOwner():PrintMessage(HUD_PRINTCENTER, 'Switched to automatic') end
    end
  end
  BaseClass.SecondaryAttack(self)
end

-- fire in 3-shot bursts
function SWEP:DoShootBullet()
  if self:GetMode() == self.FIREMODES.AUTO then BaseClass.DoShootBullet(self) return end
  self:SetNextPrimaryFire(CurTime() + self.BurstDelay)
  if self:GetBurst() <= 0 then
    self:SetBurst(3)
  end
end

-- cancel burst on holster
function SWEP:Holster()
  self:SetBurst(0)
  return BaseClass.Holster(self)
end

-- cancel burst on reload
function SWEP:Reload()
  if self.ReloadingTime and self.ReloadingTime > CurTime() or (self:GetNextPrimaryFire() > CurTime() and self:Clip1() > 0) then return end
	if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0 then
    self:SetBurst(0)
  end
  BaseClass.Reload(self)
end

-- shoot burst
function SWEP:Think()
  if self:GetBurst() > 0 and self:Clip1() > 0 and self:GetNextBurstShot() < CurTime() then
    BaseClass.DoShootBullet(self)
    self:SetBurst(self:GetBurst() - 1)
    self:SetNextBurstShot(CurTime() + self.BurstShotDelay)
  end
  BaseClass.Think(self)
end
