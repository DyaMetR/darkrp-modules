AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned crate food'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsFruit   = true

-- These are variables that should be set in entities that base from this
ENT.model = ''
ENT.energy = 0 -- how much energy restores

function ENT:initVars()
    -- Implement this to set the above variables
end

function ENT:Initialize()

  self:initVars()
  self:SetModel(self.model)

  if SERVER then
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    if IsValid(self:GetPhysicsObject()) then
      self:GetPhysicsObject():Wake()
    end
  end

end

if SERVER then

  function ENT:Use(activator, caller, use_type)
    if not activator:IsPlayer() then return end

    activator:eat(self.energy)
    self:Remove()
  end

end
