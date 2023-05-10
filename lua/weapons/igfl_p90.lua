SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'FN P90'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 6

SWEP.IsRedDot             = true

SWEP.ViewModel            = 'models/weapons/cstrike/c_smg_p90.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg_p90.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 19
SWEP.Primary.Delay        = 0.07
SWEP.Primary.ClipSize     = 50
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_P90.Single' )

SWEP.ScopeInSpeed         = 0.15
SWEP.ClipReady            = 2.2
SWEP.BaseCone             = 0.11
SWEP.MinCone              = 0.018
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.15
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.26
SWEP.AimRecoilReduction   = 0.9
SWEP.RecoilInaccuracy     = 0.9
SWEP.BaseRecoil           = 0.32
SWEP.MaxRecoil            = 1.9
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 55

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'm'

  SWEP.BasePos            = Vector( -4, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.75, 0, 2.25 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 0.8 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )

end
