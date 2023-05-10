-- constants
local INVASION = 'RPZombieApocalypse'
local INVASION_END = 'RPZombieApocalypseEndTime'

--[[---------------------------------------------------------------------------
  Whether a zombie invasion is taking place
  @return {boolean} zombie invasion active
]]-----------------------------------------------------------------------------
function DarkRP.isZombieApocalypseActive()
  return GetGlobalBool(INVASION)
end

--[[---------------------------------------------------------------------------
  When the zombie invasion started
  @return {number} zombie invasion start time
]]-----------------------------------------------------------------------------
function DarkRP.getZombieApocalypseStartTime()
  return GetGlobalBool(INVASION)
end

if CLIENT then
  DarkRP.addPhrase('en', 'zombie_dispenser', 'Random weapon dispenser')
  DarkRP.addPhrase('en', 'zombie_dispenser_unavailable', 'Out of order')
end

if SERVER then

  -- constants
  local TIMER = 'zombieapocalypse'

  -- network strings
  util.AddNetworkString('zombieapocalypse_kill')
  util.AddNetworkString('zombieapocalypse_money')
  util.AddNetworkString('zombieapocalypse_time')
  util.AddNetworkString('zombieapocalypse_timeleft')

  -- language
  DarkRP.addPhrase('en', 'zombie_start', 'A zombie apocalypse has started!')
  DarkRP.addPhrase('en', 'zombie_end', 'Zombie apocalypse ended.')
  DarkRP.addPhrase('en', 'zombie_end_time', 'Zombie apocalypse will end in %s %s.')
  DarkRP.addPhrase('en', 'zombie_mvp', '%s got the most kills with %i.')
  DarkRP.addPhrase('en', 'zombie_already', 'There\'s already a zombie apocalypse in progress!')
  DarkRP.addPhrase('en', 'zombie_notactive', 'There isn\'t a zombie apocalypse in progress.')
  DarkRP.addPhrase('en', 'zombie_admin', 'Zombie apocalypse event started with the following setup:\nSpawn rate: %i seconds.\nMaximum NPCs at once: %i.\nRewards every: %i seconds.\nYou can end the apocalypse at any time typing /endzombieapocalypse')
  DarkRP.addPhrase('en', 'zombie_receive', 'You received %s for %i kills.')
  DarkRP.addPhrase('en', 'zombie_ammo', 'Kill streak! Backup ammo received.')
  DarkRP.addPhrase('en', 'zombie_nospawns', 'This map has no spawns set! Contact a superadmin.')
  DarkRP.addPhrase('en', 'zombie_dispenser_dealer', 'You have to purchase weapons from a Gun Dealer!')
  DarkRP.addPhrase('en', 'zombie_hint_1', 'Acquire weaponry from random dispensers scattered around.')
  DarkRP.addPhrase('en', 'zombie_hint_2', 'Every 5 kills you will acquire extra ammunition for your current weapons.')
  DarkRP.addPhrase('en', 'zombie_hint_3', 'When low on ammunition, focus on headcrabs, as they are easier to kill.')

  -- starts a countdown to end the apocalypse after the given time
  local function startTimedApocalypse(time)
    -- create timer
    timer.Create(TIMER, time, 1, function()
      DarkRP.endZombieApocalypse()
    end)
    -- update players' clients
    SetGlobalFloat(INVASION_END, CurTime() + time)
  end

  --[[---------------------------------------------------------------------------
    Starts the zombie invasion
    @param {number} time that the event will last for
  ]]-----------------------------------------------------------------------------
  function DarkRP.startZombieApocalypse(time)
    SetGlobalBool(INVASION, true)
    DarkRP.spawnZombieWeaponDispensers()
    DarkRP.startZombieSpawnRoutine()
    -- notify everyone
    DarkRP.notifyAll(NOTIFY_GENERIC, 6, DarkRP.getPhrase('zombie_start'))
    -- give hints to all players
    timer.Simple(2, function() DarkRP.notifyAll(NOTIFY_HINT, 6, DarkRP.getPhrase('zombie_hint_1')) end)
    timer.Simple(6, function() DarkRP.notifyAll(NOTIFY_HINT, 6, DarkRP.getPhrase('zombie_hint_2')) end)
    timer.Simple(10, function() DarkRP.notifyAll(NOTIFY_HINT, 6, DarkRP.getPhrase('zombie_hint_3')) end)
    -- notify admins of the current parameters
    for _, _player in pairs(player.GetAll()) do
      if not _player:IsAdmin() then continue end
      _player:ChatPrint(DarkRP.getPhrase('zombie_admin', DarkRP.getZombieSpawnRate(), DarkRP.getMaxZombies(), math.ceil(DarkRP.getZombieRewardRate())))
    end
    -- if time is provided, end the event after the given time
    if not time then SetGlobalFloat(INVASION_END, -1) return end
    startTimedApocalypse(time)
  end

  --[[---------------------------------------------------------------------------
    Ends the zombie invasion
    @param {number} how long it'll take for the event to end
  ]]-----------------------------------------------------------------------------
  function DarkRP.endZombieApocalypse(time)
    if time then
      startTimedApocalypse(time)
      -- notify players of the time left
      local unit = 'seconds'
      if time >= 60 then
        unit = 'minutes'
        time = math.ceil(time / 60)
      end
      DarkRP.notifyAll(NOTIFY_HINT, 4, DarkRP.getPhrase('zombie_end_time', time, unit))
    else
      timer.Remove(TIMER)
      SetGlobalBool(INVASION, false)
      DarkRP.removeZombieWeaponDispensers()
      DarkRP.stopZombieSpawnRoutine()
      DarkRP.notifyAll(NOTIFY_HINT, 4, DarkRP.getPhrase('zombie_end'))
      -- get mvp
      local mvp, kills = nil, 0
      for _, _player in pairs(player.GetAll()) do
        if _player.ZombieApocalypse.kills_total > kills then
          mvp = _player:Name()
          kills = _player.ZombieApocalypse.kills_total
        end
        -- give what money was left for this player to receive
        if _player.ZombieApocalypse.money > 0 then
          DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('zombie_receive', DarkRP.formatMoney(_player.ZombieApocalypse.money), _player.ZombieApocalypse.kills))
          _player:addMoney(_player.ZombieApocalypse.money)
        end
        -- reset variables
        DarkRP.resetZombieApocalypseData(_player)
      end
      if mvp then
        timer.Simple(1.5, function()
          DarkRP.notifyAll(NOTIFY_GENERIC, 4, DarkRP.getPhrase('zombie_mvp', mvp, kills))
        end)
      end
    end
  end

end
