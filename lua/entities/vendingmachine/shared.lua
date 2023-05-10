ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Vending Machine'
ENT.Purpose   = 'Provide food to citizens when no cooks are present.'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = true

function ENT:Initialize()
  self:SetModel('models/props_interiors/VendingMachineSoda01a.mdl')

  if SERVER then
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():EnableMotion(false) -- freeze in place
    end
  end

  if CLIENT then
    self.PixVis = util.GetPixelVisibleHandle()
  end
end
