--[[---------------------------------------------------------------------------
  StaminaMod support
]]-----------------------------------------------------------------------------

hook.Add('playerFatigue', 'hungermod_staminamod', function(_player, stamina, oxygen)
  local energy = _player:getDarkRPVar('Energy') * .01
  _player.Fatigue = _player.Fatigue * (1 - math.pow(1 - energy, 3))
end)
