
DarkRP.isPoliceRequestInstalled = true

-- Intialize cooldown variables
hook.Add('PlayerInitialSpawn', 'policerequest_initspawn', function(_player)
  _player.NextPoliceRequest = 0
end)

-- Delete request upon disconnecting
hook.Add('PlayerDisconnected', 'policerequest_disconnect', function(_player)
  DarkRP.removePoliceRequest(_player:EntIndex())
end)
