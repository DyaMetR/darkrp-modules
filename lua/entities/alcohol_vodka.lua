AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Vodka'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model = 'models/props_junk/GlassBottle01a.mdl'
  self.alcohol = 48
  self.hangover = 50
  self.energy = 5

end
