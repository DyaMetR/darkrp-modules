AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_cratefood'
ENT.PrintName = 'Milk'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model   = 'models/props_junk/garbage_milkcarton002a.mdl'
  self.energy  = 35

end
