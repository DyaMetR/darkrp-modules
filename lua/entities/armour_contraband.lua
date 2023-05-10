AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'spawned_armour'
ENT.PrintName   = 'Spawned contraband armour'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false

function ENT:initVars()
  self.model = 'models/props_c17/SuitCase001a.mdl'
  self.kevlarType = KEVLAR_CONTRABAND
end
