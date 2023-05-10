SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'STEYR AUG A1'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 6

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_aug.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_aug.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'smg'
SWEP.ReloadHoldType       = 'smg'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 26
SWEP.Primary.Delay        = 0.11
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_AUG.Single' )

SWEP.ScopeInSpeed         = 0.2
SWEP.ClipReady            = 2.54
SWEP.BaseCone             = 0.26
SWEP.MinCone              = 0.003
SWEP.MaxCone              = 0.34
SWEP.MoveInaccuracy       = 0.9
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.4
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.02
SWEP.AimRecoilReduction   = 0.55
SWEP.RecoilInaccuracy     = 1.66
SWEP.BaseRecoil           = 0.4
SWEP.MaxRecoil            = 2.67
SWEP.RecoilRecovery       = 0.13
SWEP.RecoilRecoveryDelay  = 0.36
SWEP.AimFOV               = 37

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'e'

  SWEP.BasePos            = Vector( -2, -2, -2 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -8.36, -4, 2.21 )
  SWEP.IronSightsAng      = Vector( 0, -2.81, -9.15 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 1.5, -4, 2 )
  SWEP.SafeAng            = Vector( -18, 30, 0 )
  SWEP.RecoilPos          = Vector( 0.02, -1, 0 )

end
