
DarkRP.isVotekickInstalled = true

-- votekick status table
DarkRP.VOTEKICK = {
  in_progress = false, -- whether there's a vote in progress
  voted_player = nil, -- the currently voted player
  kicker = nil, -- player that started the vote
  banned_players = {}, -- currently banned players
  cooldown_players = {}, -- players previously banned (ban accumulation)
  forgive_players = {} -- time required for each player to get their penalty reset
}

--[[---------------------------------------------------------------------------
  Initialize player's variables
]]-----------------------------------------------------------------------------
hook.Add('PlayerInitialSpawn', 'votekick_spawn', function(_player, transition)
  _player.VotekickCooldown = 0
  _player.VotekickCooldownAccumulated = 0

  if transition then return end
  _player.VotekickFreshCooldown = CurTime() + GAMEMODE.Config.votekickfreshspawncooldown
end)

--[[---------------------------------------------------------------------------
  Kick players that are banned
]]-----------------------------------------------------------------------------
hook.Add('PlayerAuthed', 'votekick_auth', function(_player, steamid, uniqueid)
  local ban = DarkRP.VOTEKICK.banned_players[steamid]
  if ban then
    if ban.time > RealTime() then
      _player:Kick(DarkRP.getPhrase('votekick_banmessage', ban.reason, math.ceil((ban.time - RealTime()) / 60)))
    else
      DarkRP.VOTEKICK.banned_players[steamid] = nil
    end
  end
end)

--[[---------------------------------------------------------------------------
  Automatically ban leavers
]]-----------------------------------------------------------------------------
hook.Add('PlayerDisconnected', 'votekick_disconnect', function(_player)
  -- abort if the one that starts the vote leaves
  if DarkRP.VOTEKICK.kicker and DarkRP.VOTEKICK.kicker == _player then
    DarkRP.abortVotekick()
    return
  end

  -- ban if kicked person leaves
  if not DarkRP.VOTEKICK.voted_player or DarkRP.VOTEKICK.voted_player ~= _player or not _player:SteamID() then return end

  -- ban player
  DarkRP.VOTEKICK.banned_players[ _player:SteamID() ] = { reason = DarkRP.getPhrase( 'votekick_leavemessage' ), time = CurTime() + ( _player:getVotekickBanTime() * 60 ) }
  DarkRP.VOTEKICK.cooldown_players[ _player:SteamID() ] = ( DarkRP.VOTEKICK.cooldown_players[_player:SteamID()] or 0 ) + GAMEMODE.Config.votekickbantime
  DarkRP.VOTEKICK.forgive_players[ _player:SteamID() ] = CurTime() + GAMEMODE.Config.bantimecooldownresettime

  -- reset vote
  DarkRP.destroyVotesWithEnt( _player )
  DarkRP.VOTEKICK.in_progress = false
  DarkRP.VOTEKICK.voted_player = nil
end)
