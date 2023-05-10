SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'INGRAM MAC-10'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 1

SWEP.ViewModel            = 'models/weapons/cstrike/c_smg_mac10.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg_mac10.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'smg'
SWEP.ReloadHoldType       = 'smg'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 14
SWEP.Primary.Delay        = 0.09
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_Mac10.Single' )

SWEP.ClipReady            = 1.9
SWEP.BaseCone             = 0.125
SWEP.MinCone              = 0.02
SWEP.MaxCone              = 0.23
SWEP.MoveInaccuracy       = 0.3
SWEP.AimMoveInaccuracy    = 0.44
SWEP.CrouchAccuracy       = 0.4
SWEP.CrouchRecoilReduction= 0.7
SWEP.AimAccuracy          = 0.2
SWEP.AimRecoilReduction   = 0.7
SWEP.RecoilInaccuracy     = 1.1
SWEP.BaseRecoil           = 0.33
SWEP.MaxRecoil            = 1.7
SWEP.RecoilRecovery       = 0.15
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 78

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'l'

  SWEP.BasePos            = Vector( -4, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -9.271, -5.75, 2.86 )
  SWEP.IronSightsAng      = Vector( 0.83, -5.301, -7.994 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 0.8 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )
  SWEP.RecoilPos          = Vector( 0.1, -1, 0 )

end
