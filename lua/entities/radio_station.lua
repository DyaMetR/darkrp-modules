AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Radio Station'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

ENT.Model     = 'models/props_lab/servers.mdl'

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
end

function ENT:Initialize()
  self:SetModel(self.Model)
  if SERVER then
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    if IsValid(self:GetPhysicsObject()) then
      self:GetPhysicsObject():Wake()
    end
  end
end
