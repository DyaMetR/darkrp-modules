AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned alcohol'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsAlcohol = true

-- These are variables that should be set in entities that base from this
ENT.model = 'models/props_junk/garbage_glassbottle003a.mdl'
ENT.alcohol = 0 -- how much alcohol it has
ENT.hangover = 0 -- how much it dehydrates the brain
ENT.energy = 0 -- how much energy is replenishes

function ENT:initVars()
    -- Implement this to set the above variables
end

function ENT:SetupDataTables()

    self:NetworkVar('Entity', 0, 'owning_ent')

end

function ENT:Initialize()
  self:initVars()
  self:SetModel( self.model )

  if SERVER then
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():Wake()
    end
  end
end

if SERVER then

  function ENT:Use( activator, caller, use_type )
    if not activator:IsPlayer() then return end
    activator:drink( self.alcohol, self.hangover, self.energy )
    self:Remove()
  end

end
