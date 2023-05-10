SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'STEYR TMP'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 2
SWEP.SlotPos              = 2

SWEP.ViewModel            = 'models/weapons/cstrike/c_smg_tmp.mdl'
SWEP.WorldModel           = 'models/weapons/w_smg_tmp.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'smg'
SWEP.ReloadHoldType       = 'smg'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 13
SWEP.Primary.Delay        = 0.07
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'smg1'
SWEP.Primary.Sound        = Sound( 'Weapon_TMP.Single' )

SWEP.ShowCrosshairOnAim   = true
SWEP.ClipReady            = 1.36
SWEP.BaseCone             = 0.1
SWEP.MinCone              = 0.03
SWEP.MaxCone              = 0.16
SWEP.MoveInaccuracy       = 0.12
SWEP.AimMoveInaccuracy    = 0.17
SWEP.CrouchAccuracy       = 0.9
SWEP.CrouchRecoilReduction= 1
SWEP.AimAccuracy          = 0.36
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 1.6
SWEP.BaseRecoil           = 0.33
SWEP.MaxRecoil            = 1.66
SWEP.RecoilRecovery       = 0.16
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 75

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'd'

  SWEP.BasePos            = Vector( -4, -4, -1.5 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.87, 0, 2.529 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 1, -2, 0 )
  SWEP.SprintAng          = Vector( -10, 18, 0 )
  SWEP.SafePos            = Vector( 1.4, -3, 2 )
  SWEP.SafeAng            = Vector( -19, 27, -8 )

end
