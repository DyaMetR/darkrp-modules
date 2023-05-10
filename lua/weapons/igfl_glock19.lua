SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'GLOCK 19'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 2

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_glock18.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_glock18.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 12
SWEP.Primary.Delay        = 0.14
SWEP.Primary.ClipSize     = 10
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Glock.Single' )

SWEP.ClipReady            = 1.5
SWEP.BaseCone             = 0.07
SWEP.MinCone              = 0.028
SWEP.MaxCone              = 0.26
SWEP.MoveInaccuracy       = 0.2
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.8
SWEP.CrouchRecoilReduction= 1
SWEP.AimAccuracy          = 0.28
SWEP.AimRecoilReduction   = 0.86
SWEP.RecoilInaccuracy     = 1.3
SWEP.BaseRecoil           = 0.42
SWEP.MaxRecoil            = 0.7
SWEP.RecoilRecovery       = 0.1
SWEP.RecoilRecoveryDelay  = 0.33
SWEP.AimFOV               = 79

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'c'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.781, 0, 2.64 )
  SWEP.IronSightsAng      = Vector( 0.64, -0.02, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 5 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.1 )
  SWEP.RecoilAng          = Vector( 0.4, 0, 0 )

end
