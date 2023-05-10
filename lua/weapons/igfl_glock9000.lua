DEFINE_BASECLASS( 'igfl_base' )

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'GLOCK 9000'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 3
SWEP.AdminOnly            = true

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_glock18.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_glock18.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Automatic    = true
SWEP.Primary.Damage       = 12
SWEP.Primary.Delay        = 0.07
SWEP.Primary.ClipSize     = 100
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Glock.Single' )

SWEP.ClipReady            = 1.5
SWEP.BaseCone             = 0.07
SWEP.MinCone              = 0.03
SWEP.MaxCone              = 0.1
SWEP.MoveInaccuracy       = 0.04
SWEP.AimMoveInaccuracy    = 0.1
SWEP.CrouchAccuracy       = 0.4
SWEP.CrouchRecoilReduction= 0.4
SWEP.AimAccuracy          = 0.1
SWEP.AimRecoilReduction   = 0.4
SWEP.RecoilInaccuracy     = 0.5
SWEP.BaseRecoil           = 0.2
SWEP.MaxRecoil            = 0.4
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0
SWEP.AimFOV               = 70

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
  SWEP.RecoilAng          = Vector( 0.2, 0, 0 )

end
