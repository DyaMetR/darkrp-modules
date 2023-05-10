SWEP.Base                 = 'igfl_silenced_base'
SWEP.PrintName            = 'H&K USP TACTICAL'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 5

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_usp.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_usp.mdl'
SWEP.CSMuzzleFlashes      = true

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 18
SWEP.Primary.Delay        = 0.125
SWEP.Primary.ClipSize     = 8
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_USP.Single' )
SWEP.Primary.SilencedSound= Sound( 'Weapon_USP.SilencedShot' )

SWEP.ClipReady            = 1.66
SWEP.BaseCone             = 0.13
SWEP.MinCone              = 0.015
SWEP.MaxCone              = 0.37
SWEP.MoveInaccuracy       = 0.33
SWEP.AimMoveInaccuracy    = 0.36
SWEP.CrouchAccuracy       = 0.3
SWEP.CrouchRecoilReduction= 0.85
SWEP.AimAccuracy          = 0.17
SWEP.AimRecoilReduction   = 0.7
SWEP.RecoilInaccuracy     = 1.66
SWEP.BaseRecoil           = 0.5
SWEP.MaxRecoil            = 1.4
SWEP.RecoilRecovery       = 0.16
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 73

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'a'
  SWEP.IconFont           = 'igfl_icon_css'
  SWEP.IconBlurFont       = 'igfl_icon_css_blur'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.91, 0, 2.68 )
  SWEP.IronSightsAng      = Vector( -0.24, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 3, -4, 4 )
  SWEP.SafeAng            = Vector( -20, 12, 0 )
  SWEP.RecoilAng          = Vector( 0.1, 0, 0 )

end
