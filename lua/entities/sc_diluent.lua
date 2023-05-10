AddCSLuaFile()

DEFINE_BASECLASS('sc_lab_base')

ENT.Type                = 'anim'
ENT.Base                = 'sc_lab_base'
ENT.PrintName           = 'Chemical diluent'
ENT.Purpose             = 'Extract alkaloids from plants.'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false
ENT.spawnPos            = Vector(0, 0, 30)

function ENT:initVars()
  self.damage = 100
  self.model = 'models/props_c17/FurnitureWashingmachine001a.mdl'
  self.SeizeReward = 150
  self.soundLevel = 70
  self.soundPitch = 175
  self.soundVolume = .7
end

function ENT:Initialize()
  self.BaseClass.Initialize(self)
  if SERVER then
    self:GetPhysicsObject():SetMass(200)
  end
end
