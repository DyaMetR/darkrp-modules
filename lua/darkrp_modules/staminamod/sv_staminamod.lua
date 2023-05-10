-- spawn with 100% stamina and oxygen
hook.Add('PlayerSpawn', 'staminamod_spawn', function(_player)
  _player:setDarkRPVar('stamina', 100)
  _player:setDarkRPVar('oxygen', 100)
  _player.Sprinting = false
  _player.Fatigue = 1
  _player.DrownRecovery = 0
end)

-- flush all timers on disconnect
hook.Add('PlayerDisconnected', 'staminamod_disconnect', function(_player)
  _player:flushStaminaTimer()
  _player:flushOxygenTimers()
end)

-- reset stamina and oxygen values on death
hook.Add('PlayerDeath', 'staminamod_death', function(_player)
  _player:flushStaminaTimer()
  _player:flushOxygenTimers()
  _player.Sprinting = false
end)

-- detect jumping
hook.Add('KeyPress', 'staminamod_keypress', function(_player, key)
  if key ~= IN_JUMP or not _player:OnGround() then return end
  _player:addStamina(-GAMEMODE.Config.jumpCost)
  _player.Sprinting = true
end)

-- detect sprinting
hook.Add('PlayerTick', 'staminamod_tick', function(_player)
  if not _player:Alive() then return end
  local sprinting = _player:IsSprinting() and _player:GetVelocity():Length() >= _player:GetWalkSpeed()
  if sprinting then
    _player:startSprint()
  else
    _player:stopSprint()
  end
end)

-- detect waterlevel change
hook.Add('OnEntityWaterLevelChanged', 'staminamod_waterlevel', function(_player, oldWaterLevel, waterLevel)
  if not _player:IsPlayer() or not _player:Alive() then return end
  if waterLevel >= 3 then
    _player:submerge()
  else
    _player:surface()
  end
end)
