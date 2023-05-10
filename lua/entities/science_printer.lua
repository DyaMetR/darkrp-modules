AddCSLuaFile()

ENT.Base            = 'printer_base'
ENT.PrintName       = 'Experimental Money Printer'
ENT.Author          = 'DarkRP developers and DyaMetR'
ENT.Model           = 'models/props_c17/TrapPropeller_Engine.mdl'
ENT.Sound           = 'ambience/labgear.wav'
ENT.SoundLevel      = 70
ENT.SeizeReward     = 1950
ENT.Damage          = 150
ENT.PrintAmount     = 300
ENT.OverheatChance  = 17
ENT.MinPrintTime    = 100
ENT.MaxPrintTime    = 250

if SERVER then ENT.MoneyHeightOffset = 16 end
if CLIENT then ENT.LabelOffset = 5 end
