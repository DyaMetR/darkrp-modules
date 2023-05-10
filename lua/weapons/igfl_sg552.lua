SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'SIG SG 552'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 5

SWEP.ViewModel            = 'models/weapons/cstrike/c_rif_sg552.mdl'
SWEP.WorldModel           = 'models/weapons/w_rif_sg552.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 28
SWEP.Primary.Delay        = 0.1
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_SG552.Single' )

SWEP.ScopeInSpeed         = 0.2
SWEP.ClipReady            = 1.4
SWEP.BaseCone             = 0.22
SWEP.MinCone              = 0.004
SWEP.MaxCone              = 0.38
SWEP.MoveInaccuracy       = 1
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.4
SWEP.CrouchRecoilReduction= 0.7
SWEP.AimAccuracy          = 0.02
SWEP.AimRecoilReduction   = 0.6
SWEP.RecoilInaccuracy     = 1.5
SWEP.BaseRecoil           = 0.4
SWEP.MaxRecoil            = 3
SWEP.RecoilRecovery       = 0.1
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 40

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'A'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -8, -4, 2.56 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
