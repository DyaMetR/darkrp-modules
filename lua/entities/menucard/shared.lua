ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.Printname = 'Menu card'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
end

function ENT:Initialize()
  self:SetModel('models/props_c17/frame002a.mdl')

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
