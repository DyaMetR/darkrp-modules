AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Vodka'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model = 'models/props_junk/glassjug01.mdl'
  self.alcohol = 75
  self.hangover = 90
  self.energy = 0

end
