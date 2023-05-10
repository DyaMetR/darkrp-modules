SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'AVTOMAT KALASHNIKOVA 1947'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 4

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_ak47.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_ak47.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 25
SWEP.Primary.Delay        = 0.1
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_AK47.Single' )

SWEP.ClipReady            = 1.67
SWEP.BaseCone             = 0.25
SWEP.MinCone              = 0.005
SWEP.MaxCone              = 0.35
SWEP.MoveInaccuracy       = 1
SWEP.AimMoveInaccuracy    = 0.33
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.036
SWEP.AimRecoilReduction   = 0.77
SWEP.RecoilInaccuracy     = 6
SWEP.BaseRecoil           = 0.4
SWEP.MaxRecoil            = 3
SWEP.RecoilRecovery       = 0.15
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 65

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'b'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.54, 0, 2.13 )
  SWEP.IronSightsAng      = Vector( 2.414, 0.109, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
