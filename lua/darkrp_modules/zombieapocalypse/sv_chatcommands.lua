--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

-- start invasion
DarkRP.defineChatCommand('startzombieapocalypse', function(_player, args)
  if not FAdmin.Access.PlayerHasPrivilege(_player, 'ZombieApocalypse') and not _player:IsAdmin() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('no_privilege'))
    return ''
  end

  if DarkRP.isZombieApocalypseActive() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('zombie_already'))
    return ''
  end

  DarkRP.startZombieApocalypse(tonumber(args))
  return ''
end)

-- end invasion
DarkRP.defineChatCommand('endzombieapocalypse', function(_player, args)
  if not FAdmin.Access.PlayerHasPrivilege(_player, 'ZombieApocalypse') and not _player:IsAdmin() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('no_privilege'))
    return ''
  end

  if not DarkRP.isMapSupportedByZombieApocalypse() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('zombie_nospawns'))
    return ''
  end

  if not DarkRP.isZombieApocalypseActive() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('zombie_notactive'))
    return ''
  end

  DarkRP.endZombieApocalypse(tonumber(args))
  return ''
end)
