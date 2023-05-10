
DarkRP.isPoliceGearInstalled = true

-- add locker phrases
DarkRP.addPhrase('en', 'cp_locker_ammo', 'Ammunition replenished.')
DarkRP.addPhrase('en', 'cp_locker_armour', 'Kevlar armour replaced.')
DarkRP.addPhrase('en', 'cp_locker_full', 'Ammunition full.')
DarkRP.addPhrase('en', 'cp_locker_full_kev', 'Ammunition and kevlar armour already on optimal levels.')
DarkRP.addPhrase('en', 'cp_locker', 'the locker')

--[[---------------------------------------------------------------------------
  Applies all of the custom lockdown conditions to all players
]]-----------------------------------------------------------------------------
hook.Add('lockdownStarted', 'policegear_lockdown_start', function()
  for _, _player in pairs( player.GetAll() ) do
    _player:applyLockdownGear()
  end
end)

--[[---------------------------------------------------------------------------
  Reverts all of the custom lockdown conditions to all players
]]-----------------------------------------------------------------------------
hook.Add('lockdownEnded', 'policegear_lockdown_end', function()
  for _, _player in pairs( player.GetAll() ) do
    _player:revertLockdownGear()
  end
end)

--[[---------------------------------------------------------------------------
  Give weaponry and ammo on respawn
]]-----------------------------------------------------------------------------
hook.Add('PlayerSpawn', 'policegear_lockdown_spawn', function( _player )
  -- give class gear
  if _player:canGetPoliceGear() then
    for danger, _ in pairs(DarkRP.getDangerousCitizens()) do
      _player:updatePoliceGear(danger)
    end
  end

  -- apply lockdown
  if not DarkRP.getLockdownTeam(_player:Team()) or not GetGlobalBool('DarkRP_LockDown') then return end
  timer.Simple(0.1, function()
    DarkRP.giveLockdownWeapons(_player)
    _player:applyLockdownModel()
  end)
end)

--[[---------------------------------------------------------------------------
  Set lockdown conditions if they change teams
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerChangedTeam', 'policegear_lockdown_changeteam', function( _player, old_team, _team )
  if not GetGlobalBool('DarkRP_LockDown') or not DarkRP.getLockdownTeam(_team) then return end
  _player.PreLockdown = nil -- destroy data from older job
  timer.Simple(0.1, function()
    _player:applyLockdownGear()
  end)
end)

--[[---------------------------------------------------------------------------
  Check when a citizen picks up a weapon
]]-----------------------------------------------------------------------------
hook.Add( 'WeaponEquip', 'policegear_pickup', function(weapon, _player)
  if not IsValid(weapon) then return end
  DarkRP.citizenPicksUpWeapon(_player, weapon:GetClass())
end)

--[[---------------------------------------------------------------------------
  Check when a citizen drops a weapon
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerDroppedWeapon', 'policegear_drop', function(_player, weapon)
  if not _player:IsPlayer() or not IsValid(weapon) then return end
  DarkRP.citizenDropsWeapon(_player, weapon:GetClass())
end)

--[[---------------------------------------------------------------------------
  Check when a citizen gets their weapons cleared after dying
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerDeath', 'policegear_death', function(_player, inflictor, attacker)
  DarkRP.clearCitizenDangerLevel(_player)
end)

--[[---------------------------------------------------------------------------
  Check when a player disconnects to remove them from the dangerous level
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerDisconnected', 'policegear_disconnect', function(_player)
  DarkRP.clearCitizenDangerLevel(_player)
end)

--[[---------------------------------------------------------------------------
  Check when a player changes teams, stripping all of their current weapons
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerChangedTeam', 'policegear_changeteam', function(_player, old_team, _team)
  DarkRP.clearCitizenDangerLevel(_player) -- clear previous state
  -- if the new job can have gear, give it to them
  timer.Simple(0.1, function()
    if _player:canGetPoliceGear() then
      for danger, _ in pairs(DarkRP.getDangerousCitizens()) do
        _player:updatePoliceGear(danger)
      end
    end
  end)
end )
