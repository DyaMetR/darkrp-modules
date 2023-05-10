local Weapon = FindMetaTable('Weapon')

local TIMER = 'zombieapocalypse_%i'

-- set and send money to a player
local function setMoney(_player, money)
  _player.ZombieApocalypse.money = money
  net.Start('zombieapocalypse_money')
  net.WriteFloat(money)
  net.Send(_player)
end

-- set and send kills to a player
local function setKills(_player, kills)
  _player.ZombieApocalypse.kills = kills
  net.Start('zombieapocalypse_kill')
  net.WriteFloat(kills)
  net.Send(_player)
end

--[[---------------------------------------------------------------------------
  Returns the ammunition granted as a reward
  @return {number} extra ammo
]]-----------------------------------------------------------------------------
function Weapon:GetRewardAmmo()
  return math.Clamp(self:GetMaxClip1() * math.max(1 - math.pow(self.Primary.Damage * .01, 0.5), 0) * 2.5, 1, GAMEMODE.Config.zombieMaxAmmo)
end

--[[---------------------------------------------------------------------------
  Starts the reward collection timer for a player
  @param {Player} player
]]-----------------------------------------------------------------------------
function DarkRP.setupZombieRewards(_player)
  local _timer = string.format(TIMER, _player:EntIndex())
  if timer.Exists(_timer) then return end
  -- start timer
  timer.Create(_timer, DarkRP.getZombieRewardRate(), 1, function()
    DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('zombie_receive', DarkRP.formatMoney(_player.ZombieApocalypse.money), _player.ZombieApocalypse.kills))
    _player:addMoney(_player.ZombieApocalypse.money)
    setKills(_player, 0)
    setMoney(_player, 0)
  end)
  -- send time to player
  net.Start('zombieapocalypse_time')
  net.WriteFloat(CurTime() + DarkRP.getZombieRewardRate())
  net.Send(_player)
end

--[[---------------------------------------------------------------------------
  Resets the zombie invasion data of a player
  @param {Player} player
]]-----------------------------------------------------------------------------
function DarkRP.resetZombieApocalypseData(_player)
  setKills(_player, 0)
  setMoney(_player, 0)
  _player.ZombieApocalypse.kills_total = 0
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end

--[[---------------------------------------------------------------------------
  Add reward upon killing an NPC
]]-----------------------------------------------------------------------------
hook.Add('OnNPCKilled', 'zombieapocalypse_kill', function(npc, attacker, inflictor)
  if not DarkRP.isZombieApocalypseActive() or not IsValid(attacker) or not attacker:IsPlayer() then return end
  local reward = DarkRP.getEnemyKillReward(npc:GetClass())
  if not reward then return end
  setMoney(attacker, attacker.ZombieApocalypse.money + reward)
  setKills(attacker, attacker.ZombieApocalypse.kills + 1)
  attacker.ZombieApocalypse.kills_total = attacker.ZombieApocalypse.kills_total + 1
  DarkRP.setupZombieRewards(attacker)
  -- give ammo every 5 kills
  if attacker.ZombieApocalypse.kills % 5 == 0 then
    for _, weapon in pairs(attacker:GetWeapons()) do
      if weapon:GetPrimaryAmmoType() <= 0 then continue end
      attacker:GiveAmmo(weapon:GetRewardAmmo(), weapon:GetPrimaryAmmoType())
    end
    DarkRP.notify(attacker, NOTIFY_UNDO, 4, DarkRP.getPhrase('zombie_ammo'))
  end
end)

--[[---------------------------------------------------------------------------
  Reset the reward money
]]-----------------------------------------------------------------------------
hook.Add('PlayerDeath', 'zombieapocalypse_death', function(_player)
  if not DarkRP.isZombieApocalypseActive() then return end
  setMoney(_player, 0)
  setKills(_player, 0)

  -- reset timer
  timer.Remove(string.format(TIMER, _player:EntIndex()))
  net.Start('zombieapocalypse_time')
  net.WriteFloat(0)
  net.Send(_player)
end)

--[[---------------------------------------------------------------------------
  Setup variables upon spawning for the first time
]]-----------------------------------------------------------------------------
hook.Add('PlayerInitialSpawn', 'zombieapocalypse_spawn', function(_player)
  _player.ZombieApocalypse = {
    kills = 0,
    kills_total = 0,
    money = 0
  }
end)

--[[---------------------------------------------------------------------------
  Remove timer on disconnect
]]-----------------------------------------------------------------------------
hook.Add('PlayerDisconnected', 'zombieapocalypse_disconnect', function(_player)
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end)
