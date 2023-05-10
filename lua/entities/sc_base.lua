AddCSLuaFile()

ENT.Type                = 'anim'
ENT.Base                = 'base_gmodentity'
ENT.PrintName           = 'Scientist Entity Base'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false
ENT.IsScientistEntity   = true

ENT.RotatingLabel       = true
ENT.LabelPos            = Vector(0, -30, 0)
ENT.LabelAng            = Angle(0, 0, 0)

ENT.soundInstance       = nil
ENT.sound               = ''
ENT.soundLevel          = 75
ENT.soundPitch          = 100
ENT.soundVolume         = 1
ENT.model               = ''
ENT.damage              = 0

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
end

function ENT:StartSound()
    self.soundInstance = CreateSound(self, self.sound)
    self.soundInstance:SetSoundLevel(self.soundLevel)
    self.soundInstance:PlayEx(self.soundVolume, self.soundPitch)
end

function ENT:initVars()
  -- override this to initalize variables
end

function ENT:Initialize()
  self:initVars()
  self:SetModel( self.model )

  if SERVER then
    self:StartSound()
    
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

  -- TODO: add USE function to extract ingredients

  function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    self.damage = self.damage - dmg:GetDamage()
    if self.damage <= 0 and not self.Destructed then
      self.Destructed = true
      self:Destruct()
      self:Remove()
    end
  end

  function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
    if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 4, DarkRP.getPhrase("scientist_destroyed", self.PrintName)) end
  end

  function ENT:OnRemove()
    if not self.soundInstance then return end
    self.soundInstance:Stop()
  end

end

if CLIENT then

  function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    surface.SetFont("HUDNumber5")
    local text = self.PrintName
    local TextWidth = surface.GetTextSize(text)

    if self.RotatingLabel then
      Ang:RotateAroundAxis(Ang:Forward(), 90)

      Ang:RotateAroundAxis(Ang:Right(), CurTime() * -180)

      Pos = Pos + Ang:Right() * self.LabelPos.y
    else
      Pos = Pos + Ang:Forward() * self.LabelPos.x
      Pos = Pos + Ang:Right() * self.LabelPos.y
      Pos = Pos + Ang:Up() * self.LabelPos.z
      Ang = self.LabelAng
    end

    cam.Start3D2D(Pos, Ang, 0.1)
      draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
  end

end
