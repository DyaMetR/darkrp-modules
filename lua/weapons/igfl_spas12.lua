DEFINE_BASECLASS('igfl_shotgun_base')

SWEP.Base                 = 'igfl_shotgun_base'
SWEP.PrintName            = 'FRANCHI SPAS-12'
SWEP.Instructions         = 'ATTACK for primary fire\nATTACK2 to aim down sights\nUSE + ATTACK to toggle safety\nUSE + ATTACK2 switch firemodes'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 10
SWEP.IsPumpShotgun        = true

SWEP.ViewModel            = 'models/weapons/c_shotgun.mdl'
SWEP.WorldModel           = 'models/weapons/w_shotgun.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'shotgun'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 92
SWEP.Primary.Delay        = 0.88
SWEP.Primary.PostFireTime = 0.3
SWEP.Primary.ClipSize     = 8
SWEP.Primary.Ammo         = 'Buckshot'
SWEP.Primary.Sound        = Sound( 'Weapon_Shotgun.Single' )
SWEP.Primary.ReloadSound  = Sound( 'Weapon_Shotgun.Reload' )
SWEP.Primary.PumpSound    = Sound( 'Weapon_Shotgun.Special1' )
SWEP.Primary.Spread       = Vector(0.064, 0.064, 0.064)

SWEP.BaseCone             = 0.14
SWEP.MinCone              = 0.033
SWEP.MaxCone              = 0.36
SWEP.MoveInaccuracy       = 0.6
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.46
SWEP.CrouchRecoilReduction= 0.6
SWEP.AimAccuracy          = 0.06
SWEP.AimRecoilReduction   = 0.7
SWEP.RecoilInaccuracy     = 1.33
SWEP.BaseRecoil           = 1.66
SWEP.MaxRecoil            = 2.33
SWEP.RecoilRecovery       = 0.3
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 70

SWEP.FIREMODES = { SEMI = 0, AUTO = 1 }

-- block ironsights when switching modes
function SWEP:CanIronSights()
  return BaseClass.CanIronSights(self) and not self:GetOwner():KeyDown(IN_USE)
end

-- switch firemode
function SWEP:SecondaryAttack()
  if self:GetOwner():KeyDown( IN_USE ) then
    if self:GetMode() == self.FIREMODES.SEMI then
      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_burst.wav") end
      self:SetMode( self.FIREMODES.AUTO )
      self.IsPumpShotgun = false
      self.Primary.Delay = 0.4
      self.AimRecoilReduction = 0.9
      self.RecoilInaccuracy = 3
      if SERVER then self:GetOwner():PrintMessage(HUD_PRINTCENTER, 'Switched to automatic') end
    else
      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_single.wav") end
      self:SetMode( self.FIREMODES.SEMI )
      self.IsPumpShotgun = true
      self.Primary.Delay = 0.8
      self.AimRecoilReduction = 0.7
      self.RecoilInaccuracy = 1.33
      if SERVER then self:GetOwner():PrintMessage(HUD_PRINTCENTER, 'Switched to semi-automatic') end
    end
  end
  BaseClass.SecondaryAttack(self)
end

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'b'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -4, -4, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -8.961, -5, 4.19 )
  SWEP.IronSightsAng      = Vector( -0.18, 0.04, 0 )
  SWEP.SprintPos          = Vector( 0, 0, 3 )
  SWEP.SprintAng          = Vector( -16, 20, 0 )
  SWEP.SafePos            = Vector( 1, -5, 4.2 )
  SWEP.SafeAng            = Vector( -18, 26, 0 )

end
