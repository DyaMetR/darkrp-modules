SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'H&K USP MATCH'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 5

SWEP.ViewModel            = 'models/weapons/c_pistol.mdl'
SWEP.WorldModel           = 'models/weapons/w_pistol.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 16
SWEP.Primary.Delay        = 0.125
SWEP.Primary.ClipSize     = 15
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Pistol.Single' )
SWEP.Primary.ReloadSound  = Sound( 'Weapon_Pistol.Reload' )

SWEP.ClipReady            = 0.8
SWEP.BaseCone             = 0.1
SWEP.MinCone              = 0.02
SWEP.MaxCone              = 0.33
SWEP.MoveInaccuracy       = 0.3
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.4
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.2
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 0.8
SWEP.BaseRecoil           = 0.45
SWEP.MaxRecoil            = 0.8
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 75

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'd'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6, 0, 3 )
  SWEP.IronSightsAng      = Vector( 0.25, -1.25, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 3 )
  SWEP.SafeAng            = Vector( -18, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.3 )
  SWEP.RecoilAng          = Vector( 0.8, 0, 0 )

end
