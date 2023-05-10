AddCSLuaFile()

DEFINE_BASECLASS('printer_base')
ENT.Base            = 'printer_base'
ENT.PrintName       = 'Modern Money Printer'
ENT.Author          = 'DarkRP developers and DyaMetR'
ENT.Model           = 'models/props_lab/reciever01b.mdl'
ENT.Sound           = 'ambient/levels/canals/manhack_machine_loop1.wav'
ENT.SoundLevel      = 60
ENT.SeizeReward     = 2450
ENT.Damage          = 200
ENT.PrintAmount     = 500
ENT.OverheatChance  = 20
ENT.MinPrintTime    = 120
ENT.MaxPrintTime    = 330

function ENT:CreateMoneybag()
  self:EmitSound('buttons/button4.wav')
  BaseClass.CreateMoneybag(self)
end
