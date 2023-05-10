AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'itemdrug_base'
ENT.PrintName = 'Painkillers'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsDrug    = true

ENT.Model     = 'models/props_lab/jar01b.mdl'

if SERVER then

  function ENT:UseEffect(activator, caller, use_type)
    activator:addStatus('painkiller', 'painkiller')
    activator:EmitSound(string.format('npc/barnacle/barnacle_gulp%i.wav', math.random(1, 2)))
    return true
  end

end
