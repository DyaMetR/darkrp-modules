SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'IMI GALIL'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 2

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_galil.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_galil.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 22
SWEP.Primary.Delay        = 0.1
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_Galil.Single' )

SWEP.ClipReady            = 1.4
SWEP.BaseCone             = 0.22
SWEP.MinCone              = 0.01
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.9
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.06
SWEP.AimRecoilReduction   = 0.7
SWEP.RecoilInaccuracy     = 3.33
SWEP.BaseRecoil           = 0.34
SWEP.MaxRecoil            = 2.5
SWEP.RecoilRecovery       = 0.15
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 67

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'v'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.361, 0, 2.48 )
  SWEP.IronSightsAng      = Vector( -0.03, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
