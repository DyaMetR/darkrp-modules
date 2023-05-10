SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'GLOCK 17'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 4

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_glock18.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_glock18.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 15
SWEP.Primary.Delay        = 0.14
SWEP.Primary.ClipSize     = 17
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Glock.Single' )

SWEP.ClipReady            = 1.5
SWEP.BaseCone             = 0.08
SWEP.MinCone              = 0.023
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.25
SWEP.AimMoveInaccuracy    = 0.35
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.24
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 1
SWEP.BaseRecoil           = 0.41
SWEP.MaxRecoil            = 0.73
SWEP.RecoilRecovery       = 0.13
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 77

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
