AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_cratefood'
ENT.PrintName = 'Orange'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model   = 'models/props/cs_italy/orange.mdl'
  self.energy  = 10

end
