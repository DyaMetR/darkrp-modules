AddCSLuaFile()

ENT.Type      = 'anim'
ENT.Base      = 'itemdrug_base'
ENT.PrintName = 'Status based drug base'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

ENT.Overdose  = true
ENT.Status    = ''

if SERVER then

  function ENT:UseEffect(activator, caller, use_type)
    if not activator:hasStatus(self.Status) then
      activator:addStatus(self.Status, self.Status)
    else
      activator:Kill()
      DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('drug_overdose', self.PrintName))
    end
    return true
  end

end
