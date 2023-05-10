SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'AI L96A1'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 4
SWEP.SlotPos              = 3

SWEP.ViewModel            = 'models/weapons/cstrike/c_snip_awp.mdl'
SWEP.WorldModel           = 'models/weapons/w_snip_awp.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 100
SWEP.Primary.Delay        = 1.33
SWEP.Primary.ClipSize     = 10
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'SniperRound'
SWEP.Primary.Sound        = Sound( 'Weapon_AWP.Single' )

SWEP.ScopeInSpeed         = 0.46
SWEP.IronSightsDelay      = 2.3
SWEP.IsBoltAction         = true
SWEP.DoAnimationOnAim     = true
SWEP.ClipReady            = 1.67
SWEP.BaseCone             = 0.36
SWEP.MinCone              = 0.001
SWEP.MaxCone              = 0.6
SWEP.MoveInaccuracy       = 1
SWEP.AimMoveInaccuracy    = 0.8
SWEP.CrouchAccuracy       = 0.7
SWEP.CrouchRecoilReduction= 1
SWEP.AimAccuracy          = 0.005
SWEP.AimRecoilReduction   = 0.2
SWEP.RecoilInaccuracy     = 0.25
SWEP.BaseRecoil           = 3
SWEP.MaxRecoil            = 3
SWEP.RecoilRecovery       = 0.1
SWEP.RecoilRecoveryDelay  = 0.3
SWEP.AimFOV               = 15

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'r'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -7.44, 0, 2.32 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 3.6, -5.5, 3 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
