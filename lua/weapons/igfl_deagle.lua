SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'IMI DESERT EAGLE'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 7

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_deagle.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_deagle.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 30
SWEP.Primary.Delay        = 0.3
SWEP.Primary.ClipSize     = 7
SWEP.Primary.Ammo         = '357'
SWEP.Primary.Sound        = Sound( 'Weapon_Deagle.Single' )

SWEP.ClipReady            = 1.5
SWEP.BaseCone             = 0.16
SWEP.MinCone              = 0.013
SWEP.MaxCone              = 0.4
SWEP.MoveInaccuracy       = 0.46
SWEP.AimMoveInaccuracy    = 0.4
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.7
SWEP.AimAccuracy          = 0.1
SWEP.AimRecoilReduction   = 0.9
SWEP.RecoilInaccuracy     = 4
SWEP.BaseRecoil           = 1
SWEP.MaxRecoil            = 1.66
SWEP.RecoilRecovery       = 0.4
SWEP.RecoilRecoveryDelay  = 0.5
SWEP.AimFOV               = 70

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'f'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.361, 0, 1.98 )
  SWEP.IronSightsAng      = Vector( 0.34, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 5 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.3 )
  SWEP.RecoilAng          = Vector( 1, 0, 0 )

end
