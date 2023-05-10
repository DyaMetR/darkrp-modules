AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_cratefood'
ENT.PrintName = 'Watermelon'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.model   = 'models/props_junk/watermelon01.mdl'
  self.energy  = 50

end
