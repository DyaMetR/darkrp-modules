AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'pot_base'
ENT.PrintName = 'Mushroom pot'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.SeizeReward = 200

function ENT:initVars()

  self.productEntity = 'drug_shroom'
  self.seedCost = 20
  self.growTime = 120
  self.damage = 50

end
