include( 'shared.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'cl_init.lua' )

ENT.WeaponTable = { -- spawnable weapons
  'igfl_357',
  'igfl_ak47',
  'igfl_aug',
  'igfl_awp',
  'igfl_deagle',
  'igfl_fiveseven',
  'igfl_g3sg1',
  'igfl_galil',
  'igfl_glock17',
  'igfl_glock18',
  'igfl_glock19',
  'igfl_m3super90',
  'igfl_m4a1',
  'igfl_mac10',
  'igfl_mp5',
  'igfl_mp7',
  'igfl_p90',
  'igfl_p228',
  'igfl_scout',
  'igfl_sg550',
  'igfl_sg552',
  'igfl_tmp',
  'igfl_ump45',
  'igfl_usp',
  'igfl_uspmatch',
  'igfl_xm1014'
}

function ENT:Use( activator, called, use_type )
  if not activator:IsPlayer() then return end
  if activator.NextUse and self.NextUse > CurTime() then return end
  if not self:GetAvailable() then -- gun dealers present
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('zombie_dispenser_dealer'))
    return
  end
  if activator.NextZAWepDispUse and activator.NextZAWepDispUse > CurTime() then -- cool down purchases
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('have_to_wait', math.ceil(activator.NextZAWepDispUse - CurTime()), 'random weapon dispenser'))
    return
  end
  if activator:getDarkRPVar('money') < self:GetPrice() then -- not enough money
    DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', 'random weapon from dispenser'))
    return
  end
  local end_time = GetGlobalFloat('RPZombieApocalypseEndTime')
  if end_time >= CurTime() and CurTime() + 1 >= end_time then
    return -- if the apocalypse is about to end, do not allow players to purchase anything
  end
  activator:addMoney(-self:GetPrice())
  DarkRP.notify(activator, NOTIFY_GENERIC, 4, DarkRP.getPhrase('you_bought', 'random weapon from dispenser', DarkRP.formatMoney(self:GetPrice())))
  self.sparking = true
  timer.Create(self:GetClass() .. self:EntIndex(), 1, 1, function()
    self.sparking = false
    local class = self.WeaponTable[math.random(1, #self.WeaponTable)]
    local _weapon = ents.Create(class) -- create dummy weapon to get model
    local weapon = ents.Create('spawned_weapon')
    weapon:Setamount(1)
    weapon:SetWeaponClass(class)
    weapon.clip1 = _weapon:GetMaxClip1()
    weapon.ammoadd = _weapon:GetMaxClip1() + _weapon:GetRewardAmmo()
    weapon:SetModel(_weapon:GetModel())
    weapon:SetPos(self:GetPos() + Vector(0, 0, 25))
    weapon:Spawn()
    _weapon:Remove() -- remove dummy weapon
  end)
  self.NextUse = CurTime() + 1
  activator.NextZAWepDispUse = CurTime() + GAMEMODE.Config.zombieWeaponDispenserCooldown
end

function ENT:Think()
  if self.sparking then
    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect('Sparks', effectdata)
  end
end
