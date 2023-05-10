--[[---------------------------------------------------------------------------
  Interesting Gun Fights Lite Weapon Base
]]-----------------------------------------------------------------------------

local DEFAULT_MOVESPEED   = GAMEMODE.Config.walkspeed

DEFINE_BASECLASS( 'weapon_base' )

SWEP.Base                 = 'weapon_base'
SWEP.PrintName            = 'IGF Lite Weapon Base'
SWEP.Author               = 'DyaMetR'
--SWEP.Purpose              = 'Have weapons hard to use in order to create more interesting gun fights'
SWEP.Instructions         = 'ATTACK for primary fire\nATTACK2 to aim down sights\nUSE + ATTACK to toggle safety'
SWEP.Category             = 'IGF Lite'
SWEP.Spawnable            = false
SWEP.m_WeaponDeploySpeed  = 1
SWEP.DrawCrosshair        = false
SWEP.UseHands             = true
SWEP.IsIGFLite            = true

SWEP.Primary.DefaultClip  = 0
SWEP.Secondary.Ammo       = 'none'

-- sounds
SWEP.Primary.Sound        = nil
SWEP.Primary.ReloadSound  = nil

-- holdtypes
SWEP.HoldType             = 'pistol'
SWEP.AimHoldType          = 'revolver'
SWEP.ReloadHoldType       = 'pistol'
SWEP.SafeHoldType         = 'normal'

-- weapon statistics
SWEP.ShowCrosshairOnAim   = false -- whether the default crosshair should be shown when aiming down the sights
SWEP.DoAnimationOnAim     = false -- whether the fire animation should play when aiming
SWEP.ClipReady            = 1 -- time before another clip is inserted when reloading
SWEP.BaseCone             = 0.25 -- cone size while standing still
SWEP.MinCone              = 0 -- minimum size the cone can get
SWEP.MaxCone              = 0.5 -- maximum size the cone can get
SWEP.MoveInaccuracy       = 1 -- cone multiplier when moving
SWEP.CrouchAccuracy       = 0.25 -- cone multiplier when crouching
SWEP.AimAccuracy          = 0.05 -- cone multiplier when aiming down the sights
SWEP.AimRecoilReduction   = 0.5 -- how much is recoil reduced when aiming down the sights
SWEP.CrouchRecoilReduction= 1 -- how much is recoil reduced while crouching
SWEP.RecoilInaccuracy     = 2 -- cone multiplier for recoil
SWEP.BaseRecoil           = 0.1 -- recoil unit per shot
SWEP.MaxRecoil            = 5 -- maximum recoil accumulated
SWEP.RecoilRecovery       = 0.1 -- how much accuracy is recovered after shooting
SWEP.RecoilRecoveryDelay  = 0.5 -- how much time is needed for accuracy to start recovering from recoil
SWEP.PrimaryFireSprint    = 0.25 -- how much time does the sprint animation get canceled when shooting
SWEP.AimFOV               = 75 -- FOV when the player is aiming down the sights
SWEP.HolsterDelay         = 0.25 -- how much time do you need to wait after toggling holster before toggling it back again
SWEP.ViewModelFOV         = 55 -- view model FOV
SWEP.IronSightsDelay      = 1 -- how fast does a weapon go on ironsights

-- VM animations
local animations = {
  ['draw'] = ACT_VM_DRAW,
  ['idle'] = ACT_VM_IDLE,
  ['attack'] = ACT_VM_PRIMARYATTACK,
  ['attack2'] = ACT_VM_SECONDARYATTACK,
  ['reload'] = ACT_VM_RELOAD
}

-- constants
local RELOAD_TIMER = 'igfl_reload_%i'
local DEFAULT_VIEWPUNCH = 1.32
local DEFAULT_EYEANGLE_PUNCH = 1.2
local HORIZONTAL_EYEANGLE_PUNCH = 0.6
local VERTICAL_RECOIL = 0.8

-- variables
SWEP.LastSprint           = false
SWEP.NextRecoilCooldown   = 0

-- setup data tables
function SWEP:SetupDataTables()
  self:NetworkVar('Bool', 0, 'IronSights')
  self:NetworkVar('Bool', 1, 'Holster')
  self:NetworkVar('Int', 2, 'Mode')
  self:NetworkVar('Float', 3, 'Recoil')
  self:NetworkVar('Float', 4, 'NextPrimaryFireSprint')
  self:NetworkVar('Float', 5, 'NextHolsterDelay')
  self:NetworkVar('Int', 6, 'RecoilDirection' )
  self:NetworkVar('Bool', 7, 'ToIdleAnim')
  self:NetworkVar('Float', 8, 'NextIdle')
end

-- returns an ACT_VM_ animation
function SWEP:SelectAnimation(animation)
  return animations[animation]
end

-- updates the current holdtype
function SWEP:UpdateHoldType()
  if self:GetHolster() then
    self:SetHoldType( self.SafeHoldType )
    return
  end
  if self:GetIronSights() then
    self:SetHoldType( self.AimHoldType )
    return
  end
  self:SetHoldType( self.HoldType )
end

-- reset recoil
function SWEP:Deploy()
  self:SendWeaponAnim(self:SelectAnimation('draw'))
  self:SetRecoil( 0 )
  self:SetRecoilDirection( 0 )
  self:UpdateHoldType()
  self:ResetAnimation(self:GetOwner():GetViewModel():SequenceDuration())
  --self:GetOwner():GetViewModel():SelectWeightedSequence(ACT_VM_RELOAD)
  return true
end

-- remove reload timer
function SWEP:Holster()
  -- remove timers
  if SERVER then
    timer.Remove( string.format( RELOAD_TIMER, self:GetOwner():EntIndex() ) )
  end
  -- stop sound
  if CLIENT and self.Primary.ReloadSound then
    self:StopSound(self.Primary.ReloadSound)
  end
  -- reset reload time
  self.ReloadingTime = 0
  return true
end

-- resets the animation back to idle
function SWEP:ResetAnimation(time)
  self:SetNextIdle(CurTime() + time)
  self:SetToIdleAnim(true)
end

-- reset recoil
function SWEP:Reload()
  if self.ReloadingTime and self.ReloadingTime > CurTime() then return end
	if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount( self.Primary.Ammo ) > 0 then
    local animation_time = self:GetOwner():GetViewModel():SequenceDuration(self:GetOwner():GetViewModel():SelectWeightedSequence(ACT_VM_RELOAD))

    -- reset variables
    self:IronSights( false )
    self:SetRecoil( 0 )
    self:SetRecoilDirection( 0 )

    -- add a delay
    self.ReloadingTime = CurTime() + animation_time
    self:SetNextPrimaryFire( CurTime() + animation_time )
    self:SetNextSecondaryFire( CurTime() + animation_time )
    self:SetNextHolsterDelay( CurTime() + animation_time )

    -- 3rd person animation
    self:SetHoldType( self.ReloadHoldType )

    -- give time to process holdtype change
    timer.Simple( 0.1, function()
      if not IsValid(self) or not IsValid(self:GetOwner()) then return end
      self:GetOwner():SetAnimation(PLAYER_RELOAD)
    end)

    if SERVER then
      -- send animation
      self:SendWeaponAnim(self:SelectAnimation('reload'))

      -- reload weapon
  		timer.Create( string.format( RELOAD_TIMER, self:GetOwner():EntIndex() ), self.ClipReady, 1, function()
        if not IsValid( self ) or not IsValid( self:GetOwner() ) then return end
        local ammo = math.min( self:Clip1() + self:GetOwner():GetAmmoCount( self.Primary.Ammo ), self.Primary.ClipSize )
        self:GetOwner():SetAmmo( math.max( self:GetOwner():GetAmmoCount( self.Primary.Ammo ) - ( ammo - self:Clip1() ), 0 ), self.Primary.Ammo )
        self:SetClip1( ammo )
      end )
    end

    -- return animation to idle once it ends
    self:ResetAnimation(animation_time)

    -- make sound
    if CLIENT and self.Primary.ReloadSound then
      self:EmitSound( self.Primary.ReloadSound, CHAN_WEAPON )
    end
	end
end

-- whether ironsights are toggleable
function SWEP:AreIronSightsToggle()
  return false
end

-- whether ironsights accuracy should apply
function SWEP:ShouldIronSightsAccuracyApply()
  return self:GetIronSights()
end

-- returns the sound for the primary fire
function SWEP:GetPrimarySound()
  return self.Primary.Sound
end

-- gets the current accuracy
function SWEP:GetCone()
  local mul = hook.Run('IGFConeCalc', self:GetOwner(), self) or 1

  local crouch, aim = 1, 1
  local speed = self:GetOwner():GetVelocity():Length() / DEFAULT_MOVESPEED
  local _speed = 1 + ( self.MoveInaccuracy * speed )
  local recoil = 1 + ( self.RecoilInaccuracy * self:GetRecoil() )

  if self:GetOwner():OnGround() then -- ignore accuracy benefits if mid-air
    if self:GetOwner():Crouching() then crouch = self.CrouchAccuracy end
    if self:ShouldIronSightsAccuracyApply() then aim = self.AimAccuracy end
  end

  return math.Clamp( self.BaseCone * _speed * ( ( ( 1 - aim ) * speed * self.AimMoveInaccuracy ) + aim ) * crouch * recoil * mul, self.MinCone, self.MaxCone )
end

-- animates when not aiming down the sights
function SWEP:ShootEffects()
  if not IsValid( self ) or not IsValid( self:GetOwner() ) then return end
  local animation_time = 0
  if ( not self:GetIronSights() or self.DoAnimationOnAim ) then
    self:SendWeaponAnim(self:SelectAnimation('attack'))
    animation_time = self:GetOwner():GetViewModel():SequenceDuration()
  end
  self:GetOwner():MuzzleFlash()
  self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
  -- return back to idle
  if animation_time > 0 then
    self:ResetAnimation(animation_time)
  end
end

-- fires the bullet
function SWEP:PrimaryAttack()
  if not IsValid( self ) or not IsValid( self:GetOwner() ) then return false end
  if self:GetNextHolsterDelay() > CurTime() then return false end

  -- toggle holster
  if self:GetOwner():KeyDown( IN_USE ) then
    self:IronSights( false )
    self:SetHolster( not self:GetHolster() )
    self:SetNextHolsterDelay( CurTime() + self.HolsterDelay )
    -- change holdtype
    self:UpdateHoldType()
    return false
  end

  if not self:CanPrimaryAttack() then return false end

  -- if it's holstered, don't shoot
  if self:GetHolster() then return false end

  -- set next attack
  self:SetNextPrimaryFire(CurTime() + (self.Primary.Delay or 1))
  self:SetNextPrimaryFireSprint(CurTime() + (self.PrimaryFireSprint or 1))
  self:DoShootBullet()

  return true
end

-- shoot bullet
function SWEP:DoShootBullet()
  self:ShootBullet( self.Primary.Damage, 1, self:GetCone() )
  self:TakePrimaryAmmo( 1 )
  if not IsFirstTimePredicted() then return end
  -- make sound
  if SERVER and IsValid(self) and IsValid(self:GetOwner()) and self:GetPrimarySound() then self:GetOwner():EmitSound( self:GetPrimarySound(), CHAN_WEAPON ) end
  -- recoil
  self:DoRecoil()
end

-- disable secondary attack
function SWEP:SecondaryAttack()
  if not self:GetHolster() then
    if self:AreIronSightsToggle() then
      self:IronSights(not self:GetIronSights())
    end
  else
    self:SetHolster( false )
    self:UpdateHoldType()
    self:SetNextHolsterDelay( CurTime() + self.HolsterDelay )
  end
end

-- simulates weapon kick upon firing
function SWEP:DoRecoil(dir)
  -- set recoil
  local recoil = self:GetRecoil()
  if recoil <= 0 then recoil = .02 * self.BaseRecoil end
  recoil = math.min( recoil * self.BaseRecoil * 5 * (hook.Run('IGFLScaleRecoil', self:GetOwner(), self) or 1), self.MaxRecoil )
  self:SetRecoil( recoil )
  -- restart recoil timer
  self.NextRecoilCooldown = CurTime() + ( self.Primary.Delay or 1 ) + self.RecoilRecoveryDelay
  -- do view punch
  self:DoViewPunch(dir)
  -- do clientside viewmodel punch
  if CLIENT then self.ViewModelKick = true end
end

-- moves the view around
function SWEP:DoViewPunch(dir)
  if not IsValid(self) or not IsValid(self:GetOwner()) then return end
  local recoil = ( 1 + self:GetRecoil() ) * self.BaseRecoil

  -- is aiming down sights, soften punch
  if self:GetIronSights() then
    recoil = recoil * self.AimRecoilReduction
  end

  -- if crouching, soften punch
  if self:GetOwner():Crouching() then
    recoil = recoil * self.CrouchRecoilReduction
  end

  -- decide direction
  if not dir then
    self:SetRecoilDirection(math.random(-1, 1))
    dir = self:GetRecoilDirection()
  end

  -- apply recoil
  self:GetOwner():ViewPunch( Angle( -recoil * DEFAULT_VIEWPUNCH * VERTICAL_RECOIL, recoil * DEFAULT_VIEWPUNCH * dir, 0 ) )

  if (game.SinglePlayer() and SERVER) or (CLIENT and IsFirstTimePredicted()) then
		local ang = self:GetOwner():EyeAngles() - Angle( recoil * DEFAULT_EYEANGLE_PUNCH, recoil * HORIZONTAL_EYEANGLE_PUNCH * dir, 0 )
		self:GetOwner():SetEyeAngles( ang )
	end
end

-- whether the player is sprinting
function SWEP:IsSprinting()
  return self:GetOwner():OnGround() and self:GetOwner():IsSprinting() and math.Round( self:GetOwner():GetVelocity():Length() ) > math.Round( self:GetOwner():GetWalkSpeed() + 10 )
end

-- whether the player can switch to ironsights
function SWEP:CanIronSights()
  return true
end

-- changes the ironsights status
function SWEP:IronSights( ironsights )
  if (not self:CanIronSights() and ironsights) or self:GetHolster() or ironsights == self:GetIronSights() or self:GetNextHolsterDelay() > CurTime() then return end
  self:SetIronSights( ironsights )
  if ironsights then
    if self.ShowCrosshairOnAim then self.DrawCrosshair = true end
    self:GetOwner():SetFOV( self.AimFOV, .5 * self.IronSightsDelay )
    if CLIENT then self.BobScale = 0.3 end
  else
    if self.DrawCrosshair then self.DrawCrosshair = false end
    self:GetOwner():SetFOV( 0, .25 )
    if CLIENT then self.BobScale = 1 end
  end
  self:UpdateHoldType()
end

-- adjust sensitivity based on FOV
function SWEP:AdjustMouseSensitivity()
  if not self:GetIronSights() then return end
	return self:GetOwner():GetFOV() / 80
end

-- ironsight hold and recoil recovery
function SWEP:Think()
  -- to idle animation
  if self:GetToIdleAnim() and self:GetNextIdle() < CurTime() then
    self:SetToIdleAnim(false)
    self:UpdateHoldType()
    self:SendWeaponAnim(self:SelectAnimation('idle'))
  end

  -- recoil recovery
  if self:GetRecoil() > 0 and ( self.NextRecoilCooldown < CurTime() ) then
    self:SetRecoil( math.max( self:GetRecoil() - self.RecoilRecovery, 0 ) )
    self.NextRecoilCooldown = CurTime() + 0.01
  end

  -- ironsights
  if self:AreIronSightsToggle() then return end
  local ironsights = self:GetOwner():KeyDown( IN_ATTACK2 )
  self:IronSights( ironsights and not self:IsSprinting() )
end
