AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned soda'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsSoda    = true

ENT.energy    = 20
--[[ENT.buff      = 5
ENT.maxBuff   = 15
ENT.buffRate  = 10]]

function ENT:Initialize()

  self:SetModel( 'models/props_junk/PopCan01a.mdl' )

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

    activator:EmitSound( string.format( 'npc/barnacle/barnacle_gulp%i.wav', math.random( 1, 2 ) ) )
    activator:setDarkRPVar( 'Energy', math.min( activator:getDarkRPVar( 'Energy' ) + self.energy, 100 ) )
    activator:addStatus( 'sugar1', 'soda' )
    self:Remove()
  end

end
