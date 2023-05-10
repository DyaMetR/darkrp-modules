AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Motion sensor'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.Detected  = {}
ENT.Reset     = false -- whether next tick should status reset
ENT.Damage    = 40
ENT.Alert     = 0 -- alert ticks

local RANGE = 200
local TIMER = 'sg_sensor_%i'
local TICK_RATE = 1
local ALERT_DURATION = 5

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
  self:NetworkVar('Bool', 1, 'Detected')
end

function ENT:Initialize()

  self:SetDetected(false)
  self:SetModel('models/props_lab/reciever01d.mdl')

  if SERVER then
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)

    if IsValid(self:GetPhysicsObject()) then
      self:GetPhysicsObject():Wake()
    end

    -- create checker
    timer.Create(string.format(TIMER, self:EntIndex()), TICK_RATE, 0, function()
      self:CheckProximity()
    end)
  end

end

if SERVER then

  function ENT:CheckProximity()
    local to_detect = {}
    self.Reset = true

    -- check new entities
    for _, ent in pairs(ents.FindInSphere(self:GetPos(), RANGE)) do
      -- check if the entity is the owner or the client
      if ent == self or not ent:IsPlayer() or ent == self:Getowning_ent() or ent == self:Getowning_ent():getSecurityContractTarget() then continue end
      to_detect[ent:EntIndex()] = ent -- put in cache
      -- check whether the entity has been in the same spot
      if self.Detected[ent] and self.Detected[ent] == ent:GetPos() then continue end
      -- if it hasn't detect it
      self:SetDetected(true)
      self.Detected[ent] = ent:GetPos()
      self.Reset = false
      self.Alert = 0
    end

    -- set new status if nothing moved for another cycle
    if self.Reset then
      if self.Alert >= ALERT_DURATION then
        self:SetDetected(false)
      else
        self.Alert = self.Alert + 1
      end
    end

    -- flush invalid entities
    for ent, _ in pairs(self.Detected) do
      if not IsValid(ent) or not to_detect[ent:EntIndex()] then self.Detected[ent] = nil end
    end
  end

  function ENT:OnTakeDamage(dmg_info)
    self.Damage = self.Damage - dmg_info:GetDamage()
    if self.Damage <= 0 then
      DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_sensor_destroyed'))
      self:Remove()
    end
  end

  function ENT:OnRemove()
    timer.Remove(string.format(TIMER, self:EntIndex()))
  end

end
