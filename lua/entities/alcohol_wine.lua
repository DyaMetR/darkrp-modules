AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Wine'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model = 'models/props_junk/glassbottle01a.mdl'
  self.alcohol = 40
  self.hangover = 30
  self.energy = 15

end
