AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Spawned pot'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsPot     = true
ENT.STATUS    = { EMPTY = 0, PLANTED = 1, GROWN = 2 }

if CLIENT then

  ENT.Tree = nil
  ENT.Dir = nil

end

-- variables to override with the initVars function
ENT.productEntity = nil -- entity class of what the pot produces
ENT.seedCost = 0 -- how much it costs to plant a seed
ENT.growTime = 0 --how much it takes for the plant to grow
ENT.damage = 0 -- how much damage can the pot endure

function ENT:SetupDataTables()
  self:NetworkVar( 'Entity', 0, 'owning_ent' )
  self:NetworkVar( 'Int', 1, 'Status' )
end

function ENT:initVars()
  -- set your variables' values here
end

function ENT:Initialize()

  self:initVars()
  self:SetModel( 'models/props_junk/terracotta01.mdl' )
  self:SetStatus( self.STATUS.EMPTY )

  if SERVER then
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():Wake()
    end
  end

  if CLIENT then
    self.Tree = ClientsideModel( 'models/props_foliage/tree_springers_01a.mdl' )
		self.Dirt = ClientsideModel( 'models/props_phx/construct/plastic/plastic_angle_360.mdl' )
		self.Dirt:SetMaterial( 'models/props_pipes/GutterMetal01a' )

		self.Tree:SetModelScale( 0.1 )
		self.Dirt:SetModelScale( 0.16 )
  end

end


function ENT:OnRemove()

  if CLIENT then
  	if self.Tree ~= nil then
  		self.Tree:Remove()
    end

    if self.Dirt ~= nil then
  		self.Dirt:Remove()
  	end
  end

  if SERVER then
    if self:Getowning_ent() then
      DarkRP.notify( self:Getowning_ent(), 1, 4, DarkRP.getPhrase( 'pot_destroyed' ) )
    end

    timer.Remove( self:GetClass() .. self:EntIndex() )
  end

end

if CLIENT then

	function ENT:Draw()

		if self.Tree ~= nil and self.Dirt ~= nil then
			self.Tree:SetPos( self:GetPos() )
			self.Dirt:SetPos( self:GetPos() + self:GetAngles():Up() * 10 )
			self.Tree:SetAngles( self:GetAngles() )
			self.Dirt:SetAngles( self:GetAngles() )

			if self:GetStatus() <= self.STATUS.EMPTY then
				self.Tree:SetNoDraw( true )
				self.Dirt:SetNoDraw( true )
			elseif self:GetStatus() == self.STATUS.PLANTED then
				self.Tree:SetNoDraw( true )
				self.Dirt:SetNoDraw( false )
			elseif self:GetStatus() >= self.STATUS.GROWN then
				self.Tree:SetNoDraw( false )
				self.Dirt:SetNoDraw( false )
			end
    end

		self:DrawModel()

    -- code taken from microwave
    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    surface.SetFont("HUDNumber5")
    local text = self.PrintName
    local text2 = DarkRP.getPhrase( 'pot_cost', DarkRP.formatMoney( self.seedCost ) )
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(text2)

    Ang:RotateAroundAxis(Ang:Forward(), 90)
    local TextAng = Ang

    TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

    cam.Start3D2D(Pos + Ang:Right() * -30, TextAng, 0.2)
      draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
      draw.WordBox(2, -TextWidth2 * 0.5 + 5, 18, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()

	end

end

if SERVER then

  function ENT:OnTakeDamage( dmg_info )
    if dmg_info:GetDamage() > self.damage then
      self:Remove()
    else
      self.damage = self.damage - dmg_info:GetDamage()
    end
  end

  function ENT:Use( activator, caller, use_type )
    if not activator:IsPlayer() then return end
    if self:GetStatus() <= self.STATUS.EMPTY then
      -- can the player afford planting the seed?
      if activator:getDarkRPVar('money') < self.seedCost then
        DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', 'seed'))
        return
      end
      self:SetStatus(self.STATUS.PLANTED)
      DarkRP.notify(activator, NOTIFY_GENERIC, 4, DarkRP.getPhrase('pot_wait', self.growTime))
      activator:addMoney(-self.seedCost)
      timer.Create( self:GetClass() .. self:EntIndex(), self.growTime, 1, function()
        self:SetStatus( self.STATUS.GROWN )
      end )
    elseif self:GetStatus() == self.STATUS.PLANTED then
      local time = timer.TimeLeft(self:GetClass() .. self:EntIndex())
      DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('pot_wait', time))
    elseif self:GetStatus() >= self.STATUS.GROWN then
      self:SetStatus(self.STATUS.EMPTY )

      -- spawn harvested entity
      local ent = ents.Create(self.productEntity)
      ent:SetPos(self:GetPos() + (self:GetAngles():Up() * 30))
      ent:Setowning_ent(self:Getowning_ent())
      ent:Spawn()
    end

  end

end
