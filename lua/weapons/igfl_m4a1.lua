SWEP.Base                 = 'igfl_silenced_base'
SWEP.PrintName            = 'COLT M4A1 CARABINE'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 3

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_m4a1.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_m4a1.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 23
SWEP.Primary.Delay        = 0.095
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_M4A1.Single' )
SWEP.Primary.SilencedSound= Sound( 'Weapon_M4A1.Silenced' )

SWEP.ClipReady            = 1.8
SWEP.BaseCone             = 0.2
SWEP.MinCone              = 0.005
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.8
SWEP.AimMoveInaccuracy    = 0.4
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.065
SWEP.AimRecoilReduction   = 0.9
SWEP.RecoilInaccuracy     = 4
SWEP.BaseRecoil           = 0.3
SWEP.MaxRecoil            = 2
SWEP.RecoilRecovery       = 0.09
SWEP.RecoilRecoveryDelay  = 0.43
SWEP.AimFOV               = 67

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'w'

  SWEP.BasePos            = Vector( -2, -2, -2 )
  SWEP.BaseAng            = Vector( 0, 2, 0 )
  SWEP.IronSightsPos      = Vector( -7.941, 0, 0.2 )
  SWEP.IronSightsAng      = Vector( 2.76, -1.407, -4.222 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 1.5, -4, 2 )
  SWEP.SafeAng            = Vector( -18, 30, 0 )
  SWEP.RecoilPos          = Vector( 0.02, -1, 0.04 )
  SWEP.RecoilAng          = Vector( -0.1, 0, 0 )

end
