AddCSLuaFile()

DEFINE_BASECLASS('base_gmodentity')
ENT.Type              = 'anim'
ENT.Base              = 'base_gmodentity'
ENT.PrintName         = 'Drug ingredient base'
ENT.Author            = 'DyaMetR'
ENT.Spawnable         = false
ENT.IsDrugIngredient  = true

ENT.class       = ''
ENT.damage      = 20
ENT.itemPhrase  = 'Drug ingredient'
ENT.model       = ''

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
  self:NetworkVar('String', 1, 'itemPhrase')
end

function ENT:Initialize()

  self:SetModel( self.model )

  if SERVER then
    self:SetitemPhrase(self.itemPhrase)

    -- initalize physics
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

  function ENT:OnTakeDamage(dmg)
    self.damage = self.damage - dmg:GetDamage()
    if self.damage <= 0 then
      self:Remove()
    end
  end

  function ENT:OnRemove()
    BaseClass.OnRemove()
    if IsValid(self:Getowning_ent()) then -- deduct ingredient count
      self:Getowning_ent().drugIngredientCount = self:Getowning_ent().drugIngredientCount - 1
      if self:Getowning_ent().drugIngredientCount <= 0 then
        self:Getowning_ent().drugIngredientCount = nil
      end
    end
  end

end

function ENT:Draw()
  self:DrawModel()

  local Pos = self:GetPos()
  local Ang = self:GetAngles()

  surface.SetFont("HUDNumber5")
  local text = self:GetitemPhrase()
  local TextWidth = surface.GetTextSize(text)

  Ang:RotateAroundAxis(Ang:Forward(), 90)
  local TextAng = Ang

  TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

  cam.Start3D2D(Pos + Ang:Right() * -12, TextAng, 0.1)
      draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
  cam.End3D2D()
end
