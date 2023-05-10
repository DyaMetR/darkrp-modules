DEFINE_BASECLASS('igfl_melee_base')

SWEP.Base                   = 'igfl_melee_base'
SWEP.PrintName              = 'KNIFE'
SWEP.Author                 = 'DyaMetR'
SWEP.Category               = 'IGF Lite'
SWEP.Instructions           = 'ATTACK to swing\nUSE + ATTACK to rise/lower\nBACKSTAB for an instant kill'
SWEP.Spawnable              = true
SWEP.SlotPos                = 5

SWEP.ViewModel              = 'models/weapons/cstrike/c_knife_t.mdl'
SWEP.WorldModel             = 'models/weapons/w_knife_ct.mdl'
SWEP.HoldType               = 'knife'

SWEP.Primary.Damage         = 35
SWEP.Primary.Delay          = 0.9
SWEP.Primary.Range          = 75
SWEP.Primary.SwingViewPunch = Angle(3, 2, -1)
SWEP.Primary.HitViewPunch   = Angle(-2, -4, 2)
SWEP.Primary.MissSound      = {'weapons/knife/knife_slash1.wav', 'weapons/knife/knife_slash2.wav'}
SWEP.Primary.HitAnimation   = ACT_VM_PRIMARYATTACK
SWEP.ViewModelFOV           = 55

if CLIENT then
  SWEP.UseFontIcon          = true
  SWEP.Icon                 = 'j'
  SWEP.SafePos              = Vector(0, 0, 0)
  SWEP.SafeAng              = Vector(-18, 0, -10)
end

local TORSO_HITGROUPS = {
  [HITGROUP_GENERIC] = true,
  [HITGROUP_CHEST] = true,
  [HITGROUP_STOMACH] = true
}
local FLESH_SOUND = 'weapons/knife/knife_hit%i.wav'
local WALL_SOUND = 'weapons/knife/knife_hitwall%i.wav'
local STAB_SOUND = 'weapons/knife/knife_stab.wav'
local DEPLOY_SOUND = 'weapons/knife/knife_deploy.wav'

function SWEP:Deploy()
  if SERVER then self:GetOwner():EmitSound(DEPLOY_SOUND) end
  BaseClass.Deploy(self)
end

function SWEP:EntityFacingBack(trace)
  if trace.Hit and trace.Entity:IsNPC() then return false end
  local diff = trace.HitPos - trace.Entity:GetPos()
  local dot = trace.Entity:GetAimVector():Dot(diff) / diff:Length()
  return dot < 0
end

function SWEP:HitLanded(trace)
  if (not trace.Entity:IsPlayer() and not trace.Entity:IsNPC()) or not TORSO_HITGROUPS[trace.HitGroup] or not self:EntityFacingBack(trace) then
    if SERVER then
      if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
        self:GetOwner():EmitSound(string.format(FLESH_SOUND, math.random(1,4)))
      else
        self:GetOwner():EmitSound(string.format(WALL_SOUND, math.random(1,4)))
      end
    end
    BaseClass.HitLanded(self, trace)
  else
    self:ShootBullet(trace.Entity:Health() * 2, 1, 0)
    if SERVER then self:GetOwner():EmitSound(STAB_SOUND) end
    self:GetOwner():ViewPunch(self.Primary.HitViewPunch)
  end
end
