ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Stove'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsStove   = true

function ENT:SetupDataTables()

    self:NetworkVar('Entity', 0, 'owning_ent')

end

function ENT:Initialize()

  self:SetModel( 'models/props_c17/furnitureStove001a.mdl' )

  if SERVER then

    self:Getowning_ent().stoveEntity = self
    self.sparking = false
    self.damage = 200

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():Wake()
      self:GetPhysicsObject():SetMass( 200 )
    end

  end

end
