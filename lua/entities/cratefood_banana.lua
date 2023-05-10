AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_cratefood'
ENT.PrintName = 'Banana'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model   = 'models/props/cs_italy/bananna.mdl'
  self.energy  = 20

end
