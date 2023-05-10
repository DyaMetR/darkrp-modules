AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'itemdrug_base'
ENT.PrintName = 'First aid kit'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsDrug    = true

ENT.Model     = 'models/Items/HealthKit.mdl'

if SERVER then

  function ENT:UseEffect(activator, caller, use_type)
    if not activator:hasStatus('firstaid') then
      activator:addStatus('firstaid', 'firstaid', true)
      activator:EmitSound('items/smallmedkit1.wav')
      return true
    else
      DarkRP.notify(activator, NOTIFY_ERROR, 6, DarkRP.getPhrase('medkit_in_effect'))
      return false
    end
  end

end
