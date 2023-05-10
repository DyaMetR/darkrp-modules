
local SUICIDE_LOCALE = 'You cannot suicide as the Mayor!'
local MAYOR_LOCALE = 'You have died as the Mayor and will not be able to revote for %i seconds'
local ANNOUNCEMENT_LOCALE = 'Mayor %s has died!'
local TRAITOR_LOCALE = 'You have killed the Mayor as a Police member and thus, have been demoted'
local WANTED_REASON = 'High treason'

-- Demote Mayor upon dying
hook.Add( 'PlayerDeath', 'mayordeath_death', function( victim, inflictor, killer )
  if not victim:isMayor() then return end

  -- demote traitor and make them wanted
  if IsValid(killer) and killer:IsPlayer() and GAMEMODE.Config.demoteMayorTraitors and killer ~= victim and killer:isCP() then
    killer:wanted(nil, WANTED_REASON)
    killer:changeTeam(TEAM_CITIZEN, true)
    killer:teamBan(TEAM_CP )
    DarkRP.notify(killer, NOTIFY_ERROR, 6, TRAITOR_LOCALE)
  end

  -- demote mayor
  victim:changeTeam(TEAM_CITIZEN, true, true)
  victim:teamBan(TEAM_MAYOR)
  DarkRP.notify(victim, NOTIFY_ERROR, 6, string.format(MAYOR_LOCALE, GAMEMODE.Config.demotetime))

  -- notify the server about the mayor's death
  DarkRP.notifyAll(NOTIFY_ERROR, 4, string.format(ANNOUNCEMENT_LOCALE, victim:Name()))
end )

-- Prevent Mayor from killing themselves
hook.Add( 'CanPlayerSuicide', 'mayordeath_suicide', function(_player)
  if not GAMEMODE.Config.preventMayorSuicide or not _player:isMayor() then return end
  DarkRP.notify(_player, NOTIFY_ERROR, 4, SUICIDE_LOCALE)
  return false
end )
