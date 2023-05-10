SWEP.Base                 = 'igfl_scope_base'
SWEP.PrintName            = 'H&K G3SG/1'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = true
SWEP.Slot                 = 4
SWEP.SlotPos              = 4

SWEP.ViewModel            = 'models/weapons/cstrike/c_snip_g3sg1.mdl'
SWEP.WorldModel           = 'models/weapons/w_snip_g3sg1.mdl'

SWEP.HoldType             = 'shotgun'
SWEP.AimHoldType          = 'ar2'
SWEP.ReloadHoldType       = 'ar2'
SWEP.SafeHoldType         = 'passive'

SWEP.Primary.Damage       = 28
SWEP.Primary.Delay        = 0.2
SWEP.Primary.ClipSize     = 20
SWEP.Primary.Automatic    = true
SWEP.Primary.Ammo         = 'ar2'
SWEP.Primary.Sound        = Sound( 'Weapon_G3SG1.Single' )

SWEP.ScopeInSpeed         = 0.4
SWEP.IronSightsDelay      = 1.6
SWEP.ClipReady            = 2.9
SWEP.BaseCone             = 0.3
SWEP.MinCone              = 0.0028
SWEP.MaxCone              = 0.4
SWEP.MoveInaccuracy       = 0.7
SWEP.AimMoveInaccuracy    = 0.5
SWEP.CrouchAccuracy       = 0.5
SWEP.CrouchRecoilReduction= 0.9
SWEP.AimAccuracy          = 0.035
SWEP.AimRecoilReduction   = 0.8
SWEP.RecoilInaccuracy     = 2.66
SWEP.BaseRecoil           = 0.5
SWEP.MaxRecoil            = 2.66
SWEP.RecoilRecovery       = 0.14
SWEP.RecoilRecoveryDelay  = 0.7
SWEP.AimFOV               = 32

function SWEP:AreIronSightsToggle() return true end

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'i'

  SWEP.BasePos            = Vector( -3, -4, -3 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -6.2, 0, 1.88 )
  SWEP.IronSightsAng      = Vector( 0, 0, 0 )
  SWEP.SprintPos          = Vector( 0, -4, 0 )
  SWEP.SprintAng          = Vector( -10, 20, 0 )
  SWEP.SafePos            = Vector( 2, -8, 4 )
  SWEP.SafeAng            = Vector( -20, 30, 0 )

end
