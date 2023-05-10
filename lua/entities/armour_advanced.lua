AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'spawned_armour'
ENT.PrintName   = 'Spawned advanced armour'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false

function ENT:initVars()
  self.model = 'models/props_c17/SuitCase_Passenger_Physics.mdl'
  self.kevlarType = KEVLAR_ADVANCED
end
