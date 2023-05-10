AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'spawned_alcohol'
ENT.PrintName = 'Spawned beer'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

function ENT:initVars()

  self.alcohol = 20
  self.hangover = 15
  self.energy = 10

end

if SERVER then

  function ENT:OnRemove()

    local owner = self:Getowning_ent()
    owner.maxDrinks = owner.maxDrinks and owner.maxDrinks - 1 or 0

  end

end
