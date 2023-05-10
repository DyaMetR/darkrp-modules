AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'base_gmodentity'
ENT.PrintName   = 'Spawned armour'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false
ENT.IsArmour    = true

-- These are variables that should be set in entities that base from this
ENT.model = ""
ENT.kevlarType = KEVLAR_NONE

function ENT:initVars()
    -- Implement this to set the above variables
end

function ENT:Initialize()
  self:initVars()

  -- set model
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

  function ENT:Use(activator, caller, use_type)
    if not activator:IsPlayer() then return end
    if activator:getDarkRPVar('kevlar') >= 100 and activator:getDarkRPVar('kevlar_type') == self.kevlarType then
      DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('kevlar_cannot_replace'))
    else
      if activator:getDarkRPVar( 'kevlar' ) > 0 then
        DarkRP.notify(activator, NOTIFY_UNDO, 4, DarkRP.getPhrase('kevlar_replace'))
      end
      activator:setKevlar(self.kevlarType)
      self:Remove()
    end
  end

end
