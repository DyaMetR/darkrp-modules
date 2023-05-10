SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'SIG SG 550'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 4
SWEP.SlotPos              = 5

SWEP.ViewModel            = 'models/weapons/cstrike/c_snip_sg550.mdl'
SWEP.WorldModel           = 'models/weapons/w_snip_sg550.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 33
SWEP.Primary.Delay        = 0.2
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_SG550.Single' )

SWEP.ScopeInSpeed         = 0.4
SWEP.IronSightsDelay      = 1.6
SWEP.ClipReady            = 2
SWEP.BaseCone             = 0.34
SWEP.MinCone              = 0.0025
SWEP.MaxCone              = 0.46
SWEP.MoveInaccuracy       = 1
SWEP.AimMoveInaccuracy    = 1
SWEP.CrouchAccuracy       = 0.6
SWEP.CrouchRecoilReduction= 0.8
SWEP.AimAccuracy          = 0.02
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 2.88
SWEP.BaseRecoil           = 0.52
SWEP.MaxRecoil            = 2.88
SWEP.RecoilRecovery       = 0.2
SWEP.RecoilRecoveryDelay  = 0.6
SWEP.AimFOV               = 28

function SWEP:AreIronSightsToggle() return true end

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'o'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -7.48, -4, 1.52 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
