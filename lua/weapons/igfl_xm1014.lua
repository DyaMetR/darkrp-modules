SWEP.Base                 = 'igfl_shotgun_base'
SWEP.PrintName            = 'BENELLI M1014'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 9

SWEP.ViewModel            = 'models/weapons/cstrike/c_shot_xm1014.mdl'
SWEP.WorldModel           = 'models/weapons/w_shot_xm1014.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'shotgun'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 71
SWEP.Primary.Delay        = 0.3
SWEP.Primary.ClipSize     = 7
SWEP.Primary.Ammo         = 'Buckshot'
SWEP.Primary.Sound        = Sound( 'Weapon_XM1014.Single' )
SWEP.Primary.Spread       = Vector(0.08, 0.08, 0.08)
SWEP.Primary.ReloadRate   = 0.53

SWEP.BaseCone             = 0.16
SWEP.MinCone              = 0.04
SWEP.MaxCone              = 0.24
SWEP.MoveInaccuracy       = 0.6
SWEP.AimMoveInaccuracy    = 0.4
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.4
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 2.6
SWEP.BaseRecoil           = 1.54
SWEP.MaxRecoil            = 2.1
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 80

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'B'

  SWEP.BasePos            = Vector( -4, -4, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -7.015, 0, 2.7 )
  SWEP.IronSightsAng      = Vector( -0.18, -0.79, 0 )
  SWEP.SprintPos          = Vector( 0, 0, 3 )
  SWEP.SprintAng          = Vector( -16, 20, 0 )
  SWEP.SafePos            = Vector( 1, -4, 3 )
  SWEP.SafeAng            = Vector( -18, 26, 0 )
  SWEP.RecoilAng          = Vector( 0.1, 0, 0 )

end
