SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'FN M249 PARA'
SWEP.Category             = 'IGF Lite'
SWEP.Instructions         = 'CROUCH to increase accuracy\nATTACK for primary fire\nATTACK2 to aim down sights\nUSE + ATTACK to toggle safety'
SWEP.Spawnable            = true
SWEP.Slot                 = 4
SWEP.SlotPos              = 1

SWEP.ViewModel            = 'models/weapons/cstrike/c_mach_m249para.mdl'
SWEP.WorldModel           = 'models/weapons/w_mach_m249para.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 22
SWEP.Primary.Delay        = 0.08
SWEP.Primary.ClipSize     = 100
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_M249.Single' )

SWEP.ClipReady            = 3.8
SWEP.BaseCone             = 0.31
SWEP.MinCone              = 0.02
SWEP.MaxCone              = 0.5
SWEP.MoveInaccuracy       = 0.4
SWEP.AimMoveInaccuracy    = 0.3
SWEP.CrouchAccuracy       = 0.25
SWEP.CrouchRecoilReduction= 0.5
SWEP.AimAccuracy          = 0.18
SWEP.AimRecoilReduction   = 0.84
SWEP.RecoilInaccuracy     = 0.66
SWEP.BaseRecoil           = 0.38
SWEP.MaxRecoil            = 1
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.5
SWEP.AimFOV               = 70

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'z'

  SWEP.BasePos            = Vector( -4, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.95, 0, 2.35 )
  SWEP.IronSightsAng      = Vector( -0.05, 0, 0 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 0.8 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )

end
