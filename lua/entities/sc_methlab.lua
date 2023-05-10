AddCSLuaFile()

ENT.Type                = 'anim'
ENT.Base                = 'sc_lab_base'
ENT.PrintName           = 'Meth lab'
ENT.Purpose             = 'Make meth out of ephedra and dangerous chemicals'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false
ENT.spawnPos            = Vector(0, 0, 50)

function ENT:initVars()
  self.damage = 250
  self.model = 'models/props_lab/crematorcase.mdl'
  self.SeizeReward = 450
  self.sound = 'k_lab.ambient_powergenerators'
  self.soundLevel = 70
  self.soundPitch = 125
  self.soundVolume = .75
end
