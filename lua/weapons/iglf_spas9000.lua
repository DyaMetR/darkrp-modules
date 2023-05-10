SWEP.Base                 = 'igfl_shotgun_base'
SWEP.PrintName            = 'FRANCHI SPAS-9000'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.AdminOnly            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 10
SWEP.IsPumpShotgun        = false

SWEP.ViewModel            = 'models/weapons/c_shotgun.mdl'
SWEP.WorldModel           = 'models/weapons/w_shotgun.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'shotgun'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 60
SWEP.Primary.Delay        = 0.2
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Ammo         = 'Buckshot'
SWEP.Primary.Sound        = Sound( 'Weapon_Shotgun.Single' )
SWEP.Primary.ReloadSound  = Sound( 'Weapon_Shotgun.Reload' )
SWEP.Primary.PumpSound    = Sound( 'Weapon_Shotgun.Special1' )
SWEP.Primary.Spread       = Vector(0.05, 0.05, 0.05)

SWEP.BaseCone             = 0.1
SWEP.MinCone              = 0
SWEP.MaxCone              = 0.2
SWEP.MoveInaccuracy       = 1
SWEP.AimMoveInaccuracy    = 1
SWEP.CrouchAccuracy       = 1
SWEP.CrouchRecoilReduction= 1
SWEP.AimAccuracy          = 0
SWEP.AimRecoilReduction   = 1
SWEP.RecoilInaccuracy     = 1
SWEP.BaseRecoil           = 0.33
SWEP.MaxRecoil            = 0.66
SWEP.RecoilRecovery       = 0.3
SWEP.RecoilRecoveryDelay  = 0.1
SWEP.AimFOV               = 67

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'b'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -4, -4, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -8.961, -5, 4.199 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, 0, 3 )
  SWEP.SprintAng          = Vector( -16, 20, 0 )
  SWEP.SafePos            = Vector( 1, -5, 4.2 )
  SWEP.SafeAng            = Vector( -18, 26, 0 )

end
