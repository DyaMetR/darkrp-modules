SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'H&K MP7A1'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 5

SWEP.ViewModel            = 'models/weapons/c_smg1.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg1.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'smg'
SWEP.ReloadHoldType       = 'smg'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 18
SWEP.Primary.Delay        = 0.07
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_SMG1.Single' )
SWEP.Primary.ReloadSound  = Sound( 'Weapon_SMG1.Reload' )

SWEP.ClipReady            = 1
SWEP.BaseCone             = 0.13
SWEP.MinCone              = 0.014
SWEP.MaxCone              = 0.35
SWEP.MoveInaccuracy       = 0.3
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.7
SWEP.AimAccuracy          = 0.1
SWEP.AimRecoilReduction   = 0.85
SWEP.RecoilInaccuracy     = 1.2
SWEP.BaseRecoil           = 0.38
SWEP.MaxRecoil            = 1
SWEP.RecoilRecovery       = 0.25
SWEP.RecoilRecoveryDelay  = 0.15
SWEP.AimFOV               = 70

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'a'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -4, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.39, 0, 1.05 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 0.8 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )

end
