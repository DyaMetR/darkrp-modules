SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = '.357 S&W MAGNUM'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 6

SWEP.ViewModel            = 'models/weapons/c_357.mdl'
SWEP.WorldModel           = 'models/weapons/w_357.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'revolver'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 24
SWEP.Primary.Delay        = 0.4
SWEP.Primary.ClipSize     = 6
SWEP.Primary.Ammo         = '357'
SWEP.Primary.Sound        = Sound( 'Weapon_357.Single' )

SWEP.ClipReady            = 2.3
SWEP.BaseCone             = 0.13
SWEP.MinCone              = 0.0135
SWEP.MaxCone              = 0.36
SWEP.MoveInaccuracy       = 0.46
SWEP.AimMoveInaccuracy    = 0.37
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.14
SWEP.AimRecoilReduction   = 0.83
SWEP.RecoilInaccuracy     = 2
SWEP.BaseRecoil           = 0.8
SWEP.MaxRecoil            = 1.33
SWEP.RecoilRecovery       = 0.25
SWEP.RecoilRecoveryDelay  = 0.4
SWEP.AimFOV               = 72

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'e'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -2.66, 0, -2.33 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -4.7, 0, 0.55 )
  SWEP.IronSightsAng      = Vector( 0.19, -0.181, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 3 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.2 )
  SWEP.RecoilAng          = Vector( 0.7, 0, 0 )

end
