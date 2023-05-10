AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Cider'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model = 'models/props_junk/GlassBottle01a.mdl'
  self.alcohol = 20
  self.hangover = 20
  self.energy = 20

end
