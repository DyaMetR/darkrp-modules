AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned ammunition'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsAmmo    = true

-- These are variables that should be set in entities that base from this
ENT.model = 'models/Items/BoxSRounds.mdl'
ENT.ammo_type = 'pistol' -- what ammunition type is it going to give
ENT.amount = 20 -- how much ammunition will it give

function ENT:Initialize()

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
    activator:GiveAmmo( self.amount, self.ammo_type )
    self:Remove()
  end

end
