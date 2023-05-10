
-- Setup status container
hook.Add('PlayerInitialSpawn', 'statusmod_initspawn', function(_player)
  _player.StatusMod = {
    effects = {},
    statuses = {}
  }
end)

-- Flush statuses on death
hook.Add('PlayerDeath', 'statusmod_death', function(_player)
  _player:flushStatuses()
  _player:flushStatusEffects()
end)

-- Flush statuses on disconnect
hook.Add('PlayerDisconnected', 'statusmod_disconnect', function(_player)
  _player:flushStatuses()
  _player:flushStatusEffects()
end)
