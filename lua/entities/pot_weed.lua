AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'pot_base'
ENT.PrintName = 'Weed pot'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.SeizeReward = 300

function ENT:initVars()

  self.productEntity = 'spawned_weed'
  self.seedCost = 40
  self.growTime = 180
  self.damage = 35

end
