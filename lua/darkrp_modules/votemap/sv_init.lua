
DarkRP.isVotemapInstalled = true

local Player = FindMetaTable('Player')

-- networking
local NET = 'votemap_menu'
util.AddNetworkString(NET)

-- constants
local DEFAULT_TRANSITION_TIME = 3
local VOTEMAP = 'votemap'

-- variables
local initialcooldown = 0
local voteInProgress = false

-- callbacks
local voteCallback
local failCallback

-- Setup an initial cooldown
hook.Add('PlayerInitialSpawn', 'votemap_connect', function(_player, transition)
  _player.VotemapCooldown = 0
  _player.VotemapCooldownAccumulated = 0
  if transition then return end
  _player.VotemapFreshCooldown = CurTime() + GAMEMODE.Config.votemapfreshspawncooldown
end)

--[[---------------------------------------------------------------------------
  Apply penalty to the player than started the vote
  @param {Player} player that started the vote
]]-----------------------------------------------------------------------------
local function voteFailed(_player)
  -- log
  DarkRP.log(DarkRP.getPhrase('votemap_log_fail', _player:Name(), _player:SteamID(), map), Color(255, 255, 60))

  -- notify and apply cooldown
  DarkRP.notifyAll(NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_fail', GAMEMODE.Config.votemapsuccesspercentage))
  _player.VotemapCooldownAccumulated = math.Clamp(_player.VotemapCooldownAccumulated + GAMEMODE.Config.cooldownpermapvote, GAMEMODE.Config.minvotemapcooldown, GAMEMODE.Config.maxvotemapcooldown)
  _player.VotemapCooldown = CurTime() + _player.VotemapCooldownAccumulated
end

--[[---------------------------------------------------------------------------
  Makes a vote to change map
  @param {string} map
]]-----------------------------------------------------------------------------
function Player:makeMapVote(map)
  if initialcooldown > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_initialcooldown', initialcooldown - CurTime()))
    return
  end

  if self.VotemapFreshCooldown > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_freshspawncooldown', self.VotemapFreshCooldown - CurTime()))
    return
  end

  if self.VotemapCooldown > CurTime() then
    DarkRP.notify( self, 1, 4, DarkRP.getPhrase( 'votemap_cooldown', self.VotemapCooldown - CurTime() ) )
    return
  end

  if table.Count(player.GetAll()) < GAMEMODE.Config.votemapminplayers then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_players', GAMEMODE.Config.votemapminplayers))
    return
  end

  if voteInProgress then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_already'))
    return
  end

  if timer.Exists(VOTEMAP) then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_transition'))
    return
  end

  if not map or not DarkRP.hasMapToVote(map) then
    net.Start(NET)
    net.Send(self)
    return
  end

  voteInProgress = true

  -- log
  DarkRP.log(DarkRP.getPhrase('votemap_log_startvote', self:Name(), self:SteamID(), map), Color(60, 180, 255))

  -- create vote
  DarkRP.createVote(DarkRP.getPhrase(VOTEMAP, self:Name(), map), VOTEMAP, self, GAMEMODE.Config.votemaptime, voteCallback, nil, failCallback)
end

--[[---------------------------------------------------------------------------
  Called when the vote ends with more 'yes' than 'no' votes
  @param {table} vote data
]]-----------------------------------------------------------------------------
voteCallback = function(vote)
  if vote.yea >= math.ceil(table.Count(player.GetAll()) * (GAMEMODE.Config.votemapsuccesspercentage * .01)) then -- if the vote won, start map transition
    -- log
    DarkRP.log(DarkRP.getPhrase('votemap_log_success', vote.target:Name(), vote.target:SteamID(), map), Color(100, 255, 100))

    -- notify all players
    DarkRP.notifyAll(NOTIFY_GENERIC, 4, DarkRP.getPhrase('votemap_success', map, GAMEMODE.Config.mapchangetime))

    -- start map transition progress
    timer.Create(VOTEMAP, GAMEMODE.Config.mapchangetime, 1, function()
      DarkRP.notifyAll(NOTIFY_HINT, 4, DarkRP.getPhrase('votemap_change', map))

      -- log
      DarkRP.log( DarkRP.getPhrase('votemap_log_change', map), Color(190, 190, 255))

      -- create the confirmation timer
      timer.Create( VOTEMAP, DEFAULT_TRANSITION_TIME, 1, function()
        RunConsoleCommand('changelevel', map)
      end)
    end)
  else -- otherwise mark the vote as failed
    voteFailed(vote.target)
  end
  voteInProgress = false
end

--[[---------------------------------------------------------------------------
  Called when the vote ends with more 'no' than 'yes' votes
  @param {table} vote data
]]-----------------------------------------------------------------------------
failCallback = function(vote)
  voteFailed(vote.target)
  voteInProgress = false
end

--[[---------------------------------------------------------------------------
  Aborts a map transition (administrator only)
]]-----------------------------------------------------------------------------
function Player:abortMapChange()
  if not self:IsAdmin() then return end

  if not timer.Exists( VOTEMAP ) then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'votemap_nochange'))
    return
  end

  -- log
  DarkRP.log( DarkRP.getPhrase('votemap_log_abort', self:Name(), self:SteamID()), Color(255, 30, 30))

  -- abort map transition
  timer.Remove(VOTEMAP )
  DarkRP.notifyAll(NOTIFY_ERROR, 4, DarkRP.getPhrase('votemap_abort'))
end
