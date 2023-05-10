AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'base_gmodentity'
ENT.PrintName = 'Drug base'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsDrug    = true

ENT.Model     = 'models/props_lab/jar01a.mdl'

function ENT:SetupDataTables()
  self:NetworkVar('Entity', 0, 'owning_ent')
end

function ENT:Initialize()

  self:SetModel(self.Model)

  if SERVER then
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    if IsValid(self:GetPhysicsObject()) then
      self:GetPhysicsObject():Wake()
    end
  end

end

if SERVER then

  function ENT:UseEffect(activator, caller, use_type)
    -- override this function for drug effects
    return true
  end

  function ENT:Use(activator, caller, use_type)
    if not activator:IsPlayer() then return end
    if not self:UseEffect(activator, caller, use_type) then return end
    self:Remove()
  end

end

function ENT:Draw()
  self:DrawModel()

  local Pos = self:GetPos()
  local Ang = self:GetAngles()

  surface.SetFont("HUDNumber5")
  local text = self.PrintName
  local TextWidth = surface.GetTextSize(text)

  Ang:RotateAroundAxis(Ang:Forward(), 90)
  local TextAng = Ang

  TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

  cam.Start3D2D(Pos + Ang:Right() * -10, TextAng, 0.1)
      draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
  cam.End3D2D()
end
