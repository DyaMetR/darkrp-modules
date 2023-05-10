AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Beer'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model = 'models/props_junk/garbage_glassbottle001a.mdl'
  self.alcohol = 35
  self.hangover = 45
  self.energy = 10

end
