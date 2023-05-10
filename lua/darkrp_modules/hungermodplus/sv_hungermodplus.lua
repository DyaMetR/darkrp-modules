local HUNGER_CYCLE_TIMER = 'hungermodplus_update'
local HUNGER_TICK_RATE = 10 -- how often hunger updates

-- spawn with 100% energy the first time
hook.Add('PlayerInitialSpawn', 'hungermodplus_initspawn', function(_player)

  -- set first spawn flag
  _player.hungerModInit = true

end)

-- respawn with 50% energy
hook.Add('PlayerSpawn', 'hungermodplus_spawn', function(_player)

  -- negate this hook on first spawn
  if _player.hungerModInit then
    _player:setDarkRPVar('Energy', GAMEMODE.Config.initialEnergy)
    _player.hungerModInit = nil
    return
  end

  -- set energy to respawn values
  _player:setDarkRPVar('Energy', GAMEMODE.Config.respawnEnergy)

end)

-- save hunger and restore it when toggling AFK
hook.Add('playerSetAFK', 'hungermodplus_afk', function(_player, afk)
  if afk then
    _player.preAFKHunger = _player:getDarkRPVar('Energy')
  else
    _player:setDarkRPVar('Energy', _player.preAFKHunger or 50)
    _player.preAFKHunger = nil
  end
end)

-- create timer
timer.Create( HUNGER_CYCLE_TIMER, HUNGER_TICK_RATE, 0, function()

  for _, _player in pairs(player.GetAll()) do
    if not _player:Alive() then return end
    _player:hungerTick()
  end

end )
