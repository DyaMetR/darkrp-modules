AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'spawned_armour'
ENT.PrintName   = 'Spawned civilian armour'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false

function ENT:initVars()
  self.model = 'models/props_c17/BriefCase001a.mdl'
  self.kevlarType = KEVLAR_CIVILIAN
end
