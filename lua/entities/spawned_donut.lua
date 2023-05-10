AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned donut'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsDonut   = true

ENT.energy    = 30

function ENT:Initialize()

  self:SetModel( 'models/noesis/donut.mdl' )

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

    activator:eat(self.energy)
    activator:addStatus('sugar1', 'donut')
    self:Remove()
  end

end
