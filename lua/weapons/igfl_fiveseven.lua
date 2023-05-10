SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'FN FIVE-SEVEN'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 6

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_fiveseven.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_fiveseven.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 18
SWEP.Primary.Delay        = 0.125
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Fiveseven.Single' )

SWEP.ClipReady            = 2.1
SWEP.BaseCone             = 0.13
SWEP.MinCone              = 0.015
SWEP.MaxCone              = 0.36
SWEP.MoveInaccuracy       = 0.4
SWEP.AimMoveInaccuracy    = 0.34
SWEP.CrouchAccuracy       = 0.38
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.1
SWEP.AimRecoilReduction   = 0.66
SWEP.RecoilInaccuracy     = 1
SWEP.BaseRecoil           = 0.46
SWEP.MaxRecoil            = 1.33
SWEP.RecoilRecovery       = 0.22
SWEP.RecoilRecoveryDelay  = 0.34
SWEP.AimFOV               = 72

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'u'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.95, 0, 3.01 )
  SWEP.IronSightsAng      = Vector( -0.42, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 5 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.16 )
  SWEP.RecoilAng          = Vector( 0.44, 0, 0 )

end
