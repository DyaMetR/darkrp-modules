--[[---------------------------------------------------------------------------
  Anti jail kill
  Punishes CPs that kill prisoners
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase( 'en', 'jailkill_warning', 'Killing unarmed prisoners will get you demoted.' )
DarkRP.addPhrase( 'en', 'jailkill_demote', 'You have been demoted for killing an unarmed prisoner.' )

-- Government official murders an unarmed prisioner
hook.Add( 'PlayerDeath', 'antijailkill_death', function(victim, inflictor, killer)
  if not victim:isArrested() or not killer:isCP() or (IsValid(victim:GetActiveWeapon()) and GAMEMODE.NoLicense[victim:GetActiveWeapon():GetClass()]) then return end
  if killer:isCP() or killer:isMayor() then
    -- demote
    killer:changeTeam( TEAM_CITIZEN, true )
    -- ban from any entry level government jobs
    killer:teamBan( TEAM_CP )
    killer:teamBan( TEAM_MAYOR )
    -- notify
    DarkRP.notify( killer, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'jailkill_demote' ) )
    -- respawn killer
    killer:Spawn()
  end
end )

-- Warn upon hurting an unarmed prisioner
hook.Add( 'EntityTakeDamage', 'antijailkill_hurt', function(victim, dmginfo)
  local attacker = dmginfo:GetAttacker()
  if not victim:IsPlayer() or not attacker:IsPlayer() or not victim:isArrested() or not attacker:isCP() or ( IsValid( attacker:GetActiveWeapon() ) and GAMEMODE.NoLicense[ attacker:GetActiveWeapon():GetClass() ] ) then return end
  if not attacker.JailKillWarning then
    DarkRP.notify( attacker, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'jailkill_warning' ) )
    attacker.JailKillWarning = true
  end
end )

-- Upon changing jobs, reset warning
hook.Add( 'OnPlayerChangedTeam', 'antijailkill_changeteam', function(_player, _, team)
  if not GAMEMODE.CivilProtection[team] then return end
  _player.JailKillWarning = nil
end )
