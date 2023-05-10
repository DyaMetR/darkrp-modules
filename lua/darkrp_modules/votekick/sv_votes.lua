--[[---------------------------------------------------------------------------
  Vote functions
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

--[[---------------------------------------------------------------------------
  Resets the current votekick data
]]-----------------------------------------------------------------------------
local function resetVoteData()
  DarkRP.VOTEKICK.in_progress = false
  DarkRP.VOTEKICK.voted_player = nil
  DarkRP.VOTEKICK.kicker = nil
end

local votekickFailure
local votekickCallback

--[[---------------------------------------------------------------------------
  Gets the amount of time a player should be banned for if they get votekicked
  @return {number} ban time (in minutes)
]]-----------------------------------------------------------------------------
function Player:getVotekickBanTime()
  return math.min( GAMEMODE.Config.minvotekickbantime + ( DarkRP.VOTEKICK.cooldown_players[self:SteamID()] or 0 ), GAMEMODE.Config.maxvotekickbantime )
end

--[[---------------------------------------------------------------------------
  Kicks a player after being voted off, applies a temporary ban and penalties
  @param {Player} kicker
  @param {string} reason
]]-----------------------------------------------------------------------------
function Player:voteKicked( kicker, reason )

  -- if the player was forgiven, reset cooldown
  if DarkRP.VOTEKICK.forgive_players[self:SteamID()] and DarkRP.VOTEKICK.forgive_players[self:SteamID()] <= RealTime() then
    DarkRP.VOTEKICK.cooldown_players[self:SteamID()] = nil
  end

  local time = self:getVotekickBanTime()

  -- log
  DarkRP.log(DarkRP.getPhrase('votekick_log_success', self:Name(), self:SteamID(), time, reason), Color(255, 30, 30))

  -- notify
  DarkRP.notifyAll(NOTIFY_GENERIC, 4, DarkRP.getPhrase( 'votekick_success', self:Name(), time))

  -- ban and kick player
  DarkRP.VOTEKICK.banned_players[self:SteamID()] = { reason = reason, time = RealTime() + (time * 60) }
  DarkRP.VOTEKICK.cooldown_players[self:SteamID()] = (DarkRP.VOTEKICK.cooldown_players[self:SteamID()] or 0) + GAMEMODE.Config.votekickbantime
  DarkRP.VOTEKICK.forgive_players[self:SteamID()] = RealTime() + GAMEMODE.Config.bantimecooldownresettime
  self:Kick(DarkRP.getPhrase('votekick_banmessage', reason, time))
end

--[[---------------------------------------------------------------------------
  Attempts to start a kick vote
  @param {string|num} name | player ID
  @param {string} reason
]]-----------------------------------------------------------------------------
function Player:makeKickVote( kicked, reason )

  -- check for online admins
  if GAMEMODE.Config.novotekickwithadmins then
    for _, admin in pairs( player.GetAll() ) do
      if admin:IsAdmin() then
        DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_admins', kickid))
        return
      end
    end
  end

  -- fresh spawn
  if self.VotekickFreshCooldown > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_freshspawncooldown', math.ceil(self.VotemapFreshCooldown - CurTime())))
    return
  end

  -- do not let make another vote if there's already one
  if DarkRP.VOTEKICK.in_progress then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_already'))
    return
  end

  -- check cooldown
  if self.VotekickCooldown > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_cooldown', math.ceil( self.VotekickCooldown - CurTime())))
    return
  end

  -- was kicked found?
  if not kicked then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_notfound'))
    return
  end

  -- was player trying to kick themselves?
  if kicked == self then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_yourself'))
    return
  end

  -- check reason length
  if string.len(reason) > GAMEMODE.Config.maxreasonlength then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'votekick_toolong', GAMEMODE.Config.maxreasonlength))
    return
  elseif string.len(reason) < GAMEMODE.Config.minreasonlength then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'votekick_tooshort', GAMEMODE.Config.minreasonlength))
    return
  end

  -- not enough players?
  if table.Count(player.GetAll()) < GAMEMODE.Config.votekickminplayers then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_players', GAMEMODE.Config.votekickminplayers))
    return
  end

  -- if everything's okay, start the vote
  DarkRP.notifyAll(NOTIFY_GENERIC, 6, DarkRP.getPhrase('votekick_votestarted', self:Name(), kicked:Name()))
  DarkRP.log(DarkRP.getPhrase('votekick_log_startvote', self:Name(), self:SteamID(), kicked:Name(), kicked:SteamID(), reason), Color( 255, 150, 60 ))
  DarkRP.VOTEKICK.in_progress = true
  DarkRP.VOTEKICK.voted_player = kicked
  DarkRP.VOTEKICK.kicker = self
  DarkRP.createVote(DarkRP.getPhrase('votekick', self:Name(), kicked:Name(), reason ), 'votekick', kicked, GAMEMODE.Config.votekicktime, votekickCallback, { [self] = true, [kicked] = true }, votekickFailure, { kicker = self, reason = reason })
end

--[[---------------------------------------------------------------------------
  Function called when the vote ends in a theoretical success
  @param {table} vote status
]]-----------------------------------------------------------------------------
votekickCallback = function(vote)
  -- reset vote
  resetVoteData()

  -- a certain percentage of the server needs to vote yes in order to kick a player
  if vote.yea >= math.ceil( ( table.Count( player.GetAll() ) - 2 ) * ( GAMEMODE.Config.votekicksuccesspercentage * .01 ) ) then
    vote.target:voteKicked( vote.info.kicker, vote.info.reason )
  else
    votekickFailure( vote )
  end

  -- apply standard cooldown
  vote.info.kicker.VotekickCooldown = CurTime() + GAMEMODE.Config.minvotekickcooldown
end

--[[---------------------------------------------------------------------------
  Function called when a vote irrefutably fails
  @param {table} vote status
]]-----------------------------------------------------------------------------
votekickFailure = function(vote)
  local kicker, kicked = vote.info.kicker, vote.target

  -- log
  DarkRP.log(DarkRP.getPhrase('votekick_log_fail', kicker:Name(), kicker:SteamID(), kicked:Name(), kicked:SteamID()), Color(255, 200, 60))

  -- notify
  DarkRP.notifyAll(NOTIFY_ERROR, 4, DarkRP.getPhrase('votekick_fail', kicked:Name(), GAMEMODE.Config.votekicksuccesspercentage))

  -- penalize kicker
  kicker.VotekickCooldownAccumulated = kicker.VotekickCooldownAccumulated + GAMEMODE.Config.votekickcooldown
  kicker.VotekickCooldown = CurTime() + math.min(GAMEMODE.Config.minvotekickcooldown + (kicker.VotekickCooldownAccumulated - GAMEMODE.Config.votekickcooldown), GAMEMODE.Config.maxvotekickcooldown)

  -- reset vote
  resetVoteData()
end

--[[---------------------------------------------------------------------------
  Aborts the current kick voting
]]-----------------------------------------------------------------------------
function DarkRP.abortVotekick()
  if not DarkRP.VOTEKICK.in_progress then return end
  resetVoteData()
  DarkRP.destroyLastVote()
end
