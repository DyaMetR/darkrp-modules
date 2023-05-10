SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'STEYR SCOUT'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 4
SWEP.SlotPos              = 2

SWEP.ViewModel            = 'models/weapons/cstrike/c_snip_scout.mdl'
SWEP.WorldModel           = 'models/weapons/w_snip_scout.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 75
SWEP.Primary.Delay        = 1.1
SWEP.Primary.ClipSize     = 10
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'SniperRound'
SWEP.Primary.Sound        = Sound( 'Weapon_Scout.Single' )

SWEP.IsBoltAction         = true
SWEP.DoAnimationOnAim     = true
SWEP.ClipReady            = 1.33
SWEP.BaseCone             = 0.26
SWEP.MinCone              = 0.005
SWEP.MaxCone              = 0.4
SWEP.MoveInaccuracy       = 0.7
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.015
SWEP.AimRecoilReduction   = 0.3
SWEP.RecoilInaccuracy     = 0.4
SWEP.BaseRecoil           = 2.66
SWEP.MaxRecoil            = 3
SWEP.RecoilRecovery       = 0.12
SWEP.RecoilRecoveryDelay  = 0.25
SWEP.AimFOV               = 20

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'n'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.68, -4, 3.36 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
