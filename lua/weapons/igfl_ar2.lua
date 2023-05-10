SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'OVERWATCH STANDARD ISSUE\n(PULSE-RIFLE)\t\t\t'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 3
SWEP.SlotPos              = 7

SWEP.IsRedDot             = true

SWEP.ViewModel            = 'models/weapons/c_irifle.mdl'
SWEP.WorldModel           = 'models/weapons/w_irifle.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 24
SWEP.Primary.Delay        = 0.1
SWEP.Primary.ClipSize     = 30
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_AR2.Single' )
SWEP.Primary.ReloadSound  = Sound( 'Weapon_AR2.Reload' )

SWEP.ScopeInSpeed         = 0.15
SWEP.ClipReady            = 0.66
SWEP.BaseCone             = 0.2
SWEP.MinCone              = 0.013
SWEP.MaxCone              = 0.3
SWEP.MoveInaccuracy       = 0.66
SWEP.AimMoveInaccuracy    = 0.2
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.05
SWEP.AimRecoilReduction   = 0.86
SWEP.RecoilInaccuracy     = 3
SWEP.BaseRecoil           = 0.34
SWEP.MaxRecoil            = 3
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.1
SWEP.AimFOV               = 55

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'l'
  SWEP.IconFont           = 'igfl_icon_hl2'
  SWEP.IconBlurFont       = 'igfl_icon_hl2_blur'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.8, 0, 0 )
  SWEP.IronSightsAng      = Vector( 2.414, 0.109, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 1 )
  SWEP.SafeAng            = Vector( -15, 25, 0 )

end
