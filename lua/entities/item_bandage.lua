AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'itemdrug_base'
ENT.PrintName = 'Bandage'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsDrug    = true

ENT.Model     = 'models/props/cs_office/paper_towels.mdl'

if SERVER then

  function ENT:UseEffect(activator, caller, use_type)
    activator:addStatusEffect('regeneration', string.format('bandange_%i', activator:EntIndex()), nil, 10, 1.2, true)
    activator:EmitSound('items/medshot4.wav')
    return true
  end

end
