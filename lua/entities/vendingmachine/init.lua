include('shared.lua')
include('cooldown.lua')
include('settings.lua')
include('spawns.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('cooldown.lua')
AddCSLuaFile('settings.lua')

local ROTATE_AXIS = Vector(0, 0, 1)

ENT.Cooldowns = {}

function ENT:Use(activator, caller, use_type)
  -- are vending machines available?
  if not DarkRP.vendingMachinesEnabled() then
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('vm_cook'))
    return
  end
  -- can activator afford this?
  if not activator:canAfford(GAMEMODE.Config.vendingPrice) then
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('vm_afford'))
    return
  end
  -- is activator on cooldown?
  if self.Cooldowns[activator:EntIndex()] and self.Cooldowns[activator:EntIndex()] > CurTime() then
    local time = math.ceil(self.Cooldowns[activator:EntIndex()] - CurTime())
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('have_to_wait', time, DarkRP.getPhrase('vm_wait')))
    return
  end
  -- emit sound
  self:EmitSound('ambient/levels/labs/coinslot1.wav')
  DarkRP.notify(activator, NOTIFY_GENERIC, 4, DarkRP.getPhrase('you_bought', DarkRP.getPhrase('vm_drink'), DarkRP.formatMoney(GAMEMODE.Config.vendingPrice)))
  activator:addMoney(-GAMEMODE.Config.vendingPrice)
  -- spawn drink
  timer.Simple(1, function()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    -- change position
    pos = pos + (ang:Forward() * 20)
    pos = pos - (ang:Up() * 27)
    pos = pos + (ang:Right() * 4.5)
    -- rotate
    ang.p = 90
    ang:RotateAroundAxis(ROTATE_AXIS, 90)
    -- spawn entity
    local drink = ents.Create('spawned_drink')
    drink:SetPos(pos)
    drink:SetAngles(ang)
    drink:Spawn()
  end)
  DarkRP.playerUsedVendingMachine(activator, self)
end
