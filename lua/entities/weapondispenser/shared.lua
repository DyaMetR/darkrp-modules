ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Zombie apocalypse weapon dispenser'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:SetupDataTables()
  self:NetworkVar('Int', 0, 'Price')
  self:NetworkVar('Bool', 1, 'Available')
end

function ENT:Initialize()
  self:SetModel( 'models/props_c17/TrapPropeller_Engine.mdl' )
  if SERVER then
    -- check for gun dealers
    local available = true
    for _, _player in pairs(player.GetAll()) do
      if _player:Team() == TEAM_GUN then
        available = false
        break;
      end
    end
    -- initialize
    self:SetAvailable(available)
    self:SetPrice(300)
    self.sparking = false
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():EnableMotion(false)
    end
  end
end
