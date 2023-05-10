
ENT.Type                = 'anim'
ENT.Base                = 'sc_base'
ENT.PrintName           = 'Terminal'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false
ENT.IsScientistEntity   = true

function ENT:initVars()
  self.damage = 300
  self.model = 'models/props_lab/workspace002.mdl'
  self.SeizeReward = 250
  self.sound = 'k_lab.tech1'
  self.soundVolume = .75
  self.soundPitch = 80
end
