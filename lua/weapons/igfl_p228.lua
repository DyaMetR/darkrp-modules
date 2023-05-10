SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'SIG-SAUER P228'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 3

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_p228.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_p228.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 13
SWEP.Primary.Delay        = 0.135
SWEP.Primary.ClipSize     = 13
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_P228.Single' )

SWEP.ClipReady            = 1.8
SWEP.BaseCone             = 0.08
SWEP.MinCone              = 0.024
SWEP.MaxCone              = 0.4
SWEP.MoveInaccuracy       = 0.26
SWEP.AimMoveInaccuracy    = 0.28
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.4
SWEP.AimRecoilReduction   = 0.86
SWEP.RecoilInaccuracy     = 0.66
SWEP.BaseRecoil           = 0.38
SWEP.MaxRecoil            = 1
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 79

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'y'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.95, 0, 2.95 )
  SWEP.IronSightsAng      = Vector( -0.62, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 5 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.1 )
  SWEP.RecoilAng          = Vector( 0.4, 0, 0 )

end
