DEFINE_BASECLASS( 'igfl_base' )

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'GLOCK 18'
SWEP.Category             = 'IGF Lite'
SWEP.Instructions         = 'ATTACK for primary fire\nATTACK2 to aim down sights\nUSE + ATTACK to toggle safety\nUSE + ATTACK2 switch firemodes'
SWEP.Spawnable            = true
SWEP.Slot                 = 1
SWEP.SlotPos              = 3

SWEP.ViewModel            = 'models/weapons/cstrike/c_pist_glock18.mdl'
SWEP.WorldModel           = 'models/weapons/w_pist_glock18.mdl'

SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

SWEP.Primary.Damage       = 14
SWEP.Primary.Delay        = 0.09
SWEP.Primary.ClipSize     = 33
SWEP.Primary.Ammo         = 'pistol'
SWEP.Primary.Sound        = Sound( 'Weapon_Glock.Single' )

SWEP.ClipReady            = 1.5
SWEP.BaseCone             = 0.1
SWEP.MinCone              = 0.021
SWEP.MaxCone              = 0.36
SWEP.MoveInaccuracy       = 0.33
SWEP.AimMoveInaccuracy    = 0.39
SWEP.CrouchAccuracy       = 0.76
SWEP.CrouchRecoilReduction= 0.83
SWEP.AimAccuracy          = 0.22
SWEP.AimRecoilReduction   = 0.85
SWEP.RecoilInaccuracy     = 1.5
SWEP.BaseRecoil           = 0.45
SWEP.MaxRecoil            = 1
SWEP.RecoilRecovery       = 0.11
SWEP.RecoilRecoveryDelay  = 0.37
SWEP.AimFOV               = 78
SWEP.FIREMODES = { SEMI = 0, AUTO = 1 }

function SWEP:CanIronSights()

  return not self:GetOwner():KeyDown( IN_USE )

end

function SWEP:SecondaryAttack()

  if self:GetOwner():KeyDown( IN_USE ) then

    if self:GetMode() == self.FIREMODES.SEMI then

      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_burst.wav") end
      self:SetMode( self.FIREMODES.AUTO )
      self.Primary.Automatic = true
      if SERVER then self:GetOwner():PrintMessage( HUD_PRINTCENTER, 'Switched to automatic' ) end

      -- change stats
      self.MaxRecoil = 1.4
      self.MaxCone = 0.4
      self.RecoilInaccuracy = 2

    else

      if CLIENT then self:GetOwner():EmitSound("weapons/smg1/switch_single.wav") end
      self:SetMode( self.FIREMODES.SEMI )
      self.Primary.Automatic = false
      if SERVER then self:GetOwner():PrintMessage( HUD_PRINTCENTER, 'Switched to semi-automatic' ) end

      -- change stats
      self.MaxRecoil = 1
      self.MaxCone = 0.36
      self.RecoilInaccuracy = 1.5

    end

  end

  BaseClass.SecondaryAttack( self )

end

if CLIENT then

  SWEP.UseFontIcon        = true
  SWEP.Icon               = 'c'

  SWEP.BasePos            = Vector( -3, 0, -1 )
  SWEP.BaseAng            = Vector( 0, 0, 0 )
  SWEP.IronSightsPos      = Vector( -5.781, 0, 2.64 )
  SWEP.IronSightsAng      = Vector( 0.64, -0.02, 0 )
  SWEP.SprintPos          = Vector( 0, -8, -6 )
  SWEP.SprintAng          = Vector( 30, 0, 0 )
  SWEP.SafePos            = Vector( 0, 0, 5 )
  SWEP.SafeAng            = Vector( -24, 0, 0 )
  SWEP.RecoilPos          = Vector( 0, -1, -0.1 )
  SWEP.RecoilAng          = Vector( 0.4, 0, 0 )

end
