SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'H&K UMP-45'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 4

SWEP.ViewModel            = 'models/weapons/cstrike/c_smg_ump45.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg_ump45.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'smg'
SWEP.ReloadHoldType       = 'smg'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 17
SWEP.Primary.Delay        = 0.11
SWEP.Primary.ClipSize     = 25
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_UMP45.Single' )

SWEP.ClipReady            = 1.8
SWEP.BaseCone             = 0.15
SWEP.MinCone              = 0.014
SWEP.MaxCone              = 0.34
SWEP.MoveInaccuracy       = 0.57
SWEP.AimMoveInaccuracy    = 0.4
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.15
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 1.6
SWEP.BaseRecoil           = 0.37
SWEP.MaxRecoil            = 1.33
SWEP.RecoilRecovery       = 0.14
SWEP.RecoilRecoveryDelay  = 0.2
SWEP.AimFOV               = 70

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'q'

  SWEP.BasePos            = Vector( -2, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -8.78, -7.06, 4.179 )
  SWEP.IronSightsAng      = Vector( -1.4, -0.34, -2.247 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 0.8 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.03 )

end
