SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'H&K MP5A5'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 3

SWEP.ViewModel            = 'models/weapons/cstrike/c_smg_mp5.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg_mp5.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 16
SWEP.Primary.Delay        = 0.08
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_MP5Navy.Single' )

SWEP.ClipReady            = 1.75
SWEP.BaseCone             = 0.11
SWEP.MinCone              = 0.017
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.26
SWEP.AimMoveInaccuracy    = 0.4
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.2
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 1.4
SWEP.BaseRecoil           = 0.31
SWEP.MaxRecoil            = 0.9
SWEP.RecoilRecovery       = 0.17
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 70

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'x'

  SWEP.BasePos            = Vector( -2, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector(-5.321, 0, 1.759)
  SWEP.IronSightsAng      = Vector(1.299, 0.029, 0)
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 1.25 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )

end
