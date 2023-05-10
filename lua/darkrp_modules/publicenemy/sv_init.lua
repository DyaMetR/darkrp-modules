
DarkRP.isPublicEnemyInstalled = true

-- Reset variables
hook.Add('PlayerSpawn', 'publicenemy_spawn', function(_player)
  _player:resetAutoWantKills()
end)

-- Remove timer
hook.Add('PlayerDisconnected', 'publicenemy_disconnect', function(_player)
  _player:resetAutoWantKills()
end)

-- Get death
hook.Add('PlayerDeath', 'publicenemy_death', function(victim, inflictor, killer)
  if victim == killer or not IsValid(killer) or not killer:IsPlayer() or killer:isCP() then return end
  killer:addAutoWantKill( victim )
end)
