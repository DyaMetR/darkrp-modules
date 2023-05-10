SWEP.Base                 = 'igfl_shotgun_base'
SWEP.PrintName            = 'BENELLI M3 SUPER 90'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 8

SWEP.ViewModel            = 'models/weapons/cstrike/c_shot_m3super90.mdl'
SWEP.WorldModel           = 'models/weapons/w_shot_m3super90.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'shotgun'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 79
SWEP.Primary.Delay        = 0.93
SWEP.Primary.ClipSize     = 8
SWEP.Primary.Ammo         = 'Buckshot'
SWEP.Primary.Sound        = Sound( 'Weapon_M3.Single' )
SWEP.Primary.Spread       = Vector(0.05, 0.05, 0.05)
SWEP.Primary.ReloadRate   = 0.56

SWEP.DoAnimationOnAim     = true
SWEP.BaseCone             = 0.12
SWEP.MinCone              = 0.036
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.5
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.75
SWEP.AimAccuracy          = 0.1
SWEP.AimRecoilReduction   = 0.7
SWEP.RecoilInaccuracy     = 1.66
SWEP.BaseRecoil           = 1.75
SWEP.MaxRecoil            = 2.43
SWEP.RecoilRecovery       = 0.1
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 76

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'k'

  SWEP.BasePos            = Vector( -4, -4, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -7.651, 0, 3.519 )
  SWEP.IronSightsAng      = Vector( 0, 0.009, 0 )
  SWEP.SprintPos          = Vector( 0, 0, 3 )
  SWEP.SprintAng          = Vector( -16, 20, 0 )
  SWEP.SafePos            = Vector( 1, -5, 3.7 )
  SWEP.SafeAng            = Vector( -18, 26, 0 )

end
