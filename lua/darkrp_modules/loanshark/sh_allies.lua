--[[---------------------------------------------------------------------------
  Allow loan sharks to have allies
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

-- phrases
if SERVER then
  DarkRP.addPhrase('en', 'loanshark_ally_kill', '%s took your %s by force from %s back to you.')
  DarkRP.addPhrase('en', 'loanshark_ally_kill_self', 'You took %s\'s %s back from %s to them by force.')
  DarkRP.addPhrase('en', 'loanshark_ally_killed_you', '%s took %s\'s %s back to them by force.')
end
if CLIENT then
  DarkRP.addPhrase('en', 'loanshark_boss_loan', 'Has a %s loan from your boss.')
  DarkRP.addPhrase('en', 'loanshark_boss_debtor', 'Owes money to your boss!')
end

--[[---------------------------------------------------------------------------
  Whether this player is an ally of the given loan shark
  @param {Player} loan shark
  @return {boolean} is ally
]]-----------------------------------------------------------------------------
function Player:isLoanSharkAlly(loanShark)
  return hook.Run('isPlayerLoanSharkAlly', self, loanShark) or false
end

--[[---------------------------------------------------------------------------
  Mob Boss and Gangsters
]]-----------------------------------------------------------------------------
hook.Add('isPlayerLoanSharkAlly', 'loanshark_default', function(ally, loanShark)
  if not loanShark or not IsValid(loanShark) or ally:Team() ~= TEAM_GANG or loanShark:Team() ~= TEAM_MOB then return end
  return true
end)
