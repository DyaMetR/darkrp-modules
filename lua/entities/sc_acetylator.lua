AddCSLuaFile()

ENT.Type                = 'anim'
ENT.Base                = 'sc_lab_base'
ENT.PrintName           = 'Acetylator'
ENT.Purpose             = 'Synthetize drugs via acetylation.'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false
ENT.spawnPos            = Vector(0, 0, 30)

function ENT:initVars()
  self.damage = 150
  self.model = 'models/props_lab/miniteleport.mdl'
  self.SeizeReward = 250
  self.sound = 'k_lab.flubbertube_on'
end
