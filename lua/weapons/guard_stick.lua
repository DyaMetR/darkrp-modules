DEFINE_BASECLASS('stick_base')

SWEP.Base = 'stick_base'
SWEP.Instructions = 'Left click to push away player'
SWEP.IsDarkRPStunstick = true

SWEP.PrintName = 'Guard Nightstick'
SWEP.Spawnable = true
SWEP.Category = 'DarkRP (Utility)'

SWEP.StickColor = Color(30, 50, 100)

function SWEP:Initialize()
  BaseClass.Initialize(self)
  self.Hit = {
    Sound("weapons/stunstick/stunstick_impact1.wav"),
    Sound("weapons/stunstick/stunstick_impact2.wav")
  }
  self.FleshHit = {
    Sound("weapons/stunstick/stunstick_fleshhit1.wav"),
    Sound("weapons/stunstick/stunstick_fleshhit2.wav")
  }
end

function SWEP:DoFlash(ply)
  if not IsValid(ply) or not ply:IsPlayer() then return end
  ply:ScreenFade(SCREENFADE.IN, color_white, 1.2, 0)
end

function SWEP:DoAttack()
  if CLIENT then return end

  local Owner = self:GetOwner()

  if not IsValid(Owner) then return end

  Owner:LagCompensation(true)
  local trace = util.QuickTrace(Owner:EyePos(), Owner:GetAimVector() * 90, {Owner})
  Owner:LagCompensation(false)

  local ent = trace.Entity
  if ent:IsPlayer() then
    -- cap height
    local vel = (ent:GetPos() - Owner:GetPos()) * 12
    vel.z = 0
    -- apply velocity
    ent:SetVelocity(vel)
    self:DoFlash(ent)
    Owner:EmitSound(self.FleshHit[math.random(#self.FleshHit)])
  end
end

function SWEP:PrimaryAttack()
  BaseClass.PrimaryAttack(self)
  self:SetNextSecondaryFire(self:GetNextPrimaryFire())
  self:DoAttack()
end

function SWEP:SecondaryAttack()
  BaseClass.PrimaryAttack(self)
  self:SetNextSecondaryFire(self:GetNextPrimaryFire())
  self:DoAttack()
end
