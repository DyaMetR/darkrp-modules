--[[---------------------------------------------------------------------------
  Currently active requests
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

local NET_ADD = 'policerequest_add'
local NET_REMOVE = 'policerequest_remove'
local NET_BULK = 'policerequest_bulk'

if SERVER then

  -- add phrases
  DarkRP.addPhrase('en', 'cp_use_radio', 'You can\'t file a police request. Use the radio to call for help.')
  DarkRP.addPhrase('en', 'cprequest', '%s filed a help request!')
  DarkRP.addPhrase('en', 'cprequest_attended', '%s attended %s\'s request.')
  DarkRP.addPhrase('en', 'cprequest_expired', '%s\'s request expired.')
  DarkRP.addPhrase('en', 'cprequest_sent', 'You alerted the police.')
  DarkRP.addPhrase('en', 'your_cprequest_expired', 'Your police request expired.')
  DarkRP.addPhrase('en', 'cannot_cprequest_active', 'You already have a police request active!')
  DarkRP.addPhrase('en', 'cannot_cprequest_cooldown', 'You have to wait %s seconds before calling for help again.')

  -- network strings
  util.AddNetworkString(NET_ADD)
  util.AddNetworkString(NET_REMOVE)
  util.AddNetworkString(NET_BULK)

  local TIMER_EXPIRE = 'policerequest_expire_%i'
  local TIMER_CYCLE = 'policerequest_check_%i'

  local CYCLE_TICK = 1

  local requests = {} -- active requests

  --[[---------------------------------------------------------------------------
    Updates all player's clients with the new information
    @param {number} entity index
    @param {boolean} should be notification be removed
  ]]-----------------------------------------------------------------------------
  local function updatePlayersClient(ent_index, remove)
    if remove then
      net.Start(NET_REMOVE)
      net.WriteFloat(ent_index)
      net.Broadcast()
    else
      local requester = ents.GetByIndex(ent_index)
      net.Start(NET_ADD)
      net.WriteFloat(ent_index)
      net.WriteVector(requester:GetPos())
      net.Broadcast()
    end
  end

  --[[---------------------------------------------------------------------------
    Sends a notification to all police members
    @param {number} notification type
    @param {number} duration
    @param {string} message
  ]]-----------------------------------------------------------------------------
  local function notifyPolice(_type, duration, message)
    for _, _player in pairs(player.GetAll()) do
      if not _player:isCP() or _player:isMayor() then continue end
      DarkRP.notify(_player, _type, duration, message)
    end
  end

  --[[---------------------------------------------------------------------------
    Attempts to call for help to the police, returns whether it was possible
    @return {boolean} can request
  ]]-----------------------------------------------------------------------------
  function Player:attemptPoliceRequest()

    -- disallow CPs to call for help
    if self:isCP() and not self:isMayor() then
      DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('cp_use_radio'))
      return false
    end

    -- disallow players to call a request when there's an active one
    if timer.Exists(string.format(TIMER_EXPIRE, self:EntIndex())) then
      DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('cannot_cprequest_active'))
      return false
    end

    -- disallow spam
    if self.NextPoliceRequest > CurTime() then
      DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('cannot_cprequest_cooldown', math.ceil( self.NextPoliceRequest - CurTime())))
      return false
    end

    return true

  end

  --[[---------------------------------------------------------------------------
    Notifies the police about a player requiring help
  ]]-----------------------------------------------------------------------------
  function Player:addPoliceRequest()
    local canRequest = self:attemptPoliceRequest()
    if not canRequest then return end

    -- add request
    requests[self:EntIndex()] = self:GetPos()
    updatePlayersClient(self:EntIndex())
    DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('cprequest_sent'))
    notifyPolice(NOTIFY_ERROR, 8, DarkRP.getPhrase('cprequest', self:Name()))

    -- expire timer
    timer.Create(string.format(TIMER_EXPIRE, self:EntIndex()), GAMEMODE.Config.requestTime, 1, function()
      DarkRP.policeRequestExpired(self:EntIndex())
    end )

    -- check for CPs timer
    timer.Create(string.format(TIMER_CYCLE, self:EntIndex()), CYCLE_TICK, 0, function()
      for _, _player in pairs(ents.FindInSphere(requests[self:EntIndex()], GAMEMODE.Config.requestAttendRadius)) do
        if not _player:IsPlayer() or not _player:isCP() or _player:isMayor() then continue end
        _player:attendPoliceRequest(self:EntIndex())
      end
    end )
  end

  --[[---------------------------------------------------------------------------
    Removes a player's police request
    @param {number} player's entity index
  ]]-----------------------------------------------------------------------------
  function DarkRP.removePoliceRequest(ent_index)
    if not requests[ent_index] then return end

    ents.GetByIndex(ent_index).NextPoliceRequest = CurTime() + GAMEMODE.Config.requestCooldown
    timer.Remove(string.format(TIMER_EXPIRE, ent_index))
    timer.Remove(string.format(TIMER_CYCLE, ent_index))
    requests[ent_index] = nil
    updatePlayersClient(ent_index, true)
  end

  --[[---------------------------------------------------------------------------
    Marks a request as attended by the player
    @param {number} entity index of the requester
  ]]-----------------------------------------------------------------------------
  function Player:attendPoliceRequest(ent_index)
    if not self:isCP() or self:isMayor() then return end

    DarkRP.removePoliceRequest(ent_index)
    notifyPolice(3, 4, DarkRP.getPhrase('cprequest_attended', self:Name(), ents.GetByIndex(ent_index):Name()))
  end

  --[[---------------------------------------------------------------------------
    Marks a request as expired
    @param {number} entity index of the requester
  ]]-----------------------------------------------------------------------------
  function DarkRP.policeRequestExpired(ent_index)
    local _player = ents.GetByIndex(ent_index)

    DarkRP.removePoliceRequest(ent_index)
    DarkRP.notify(_player, NOTIFY_UNDO, 4, DarkRP.getPhrase('your_cprequest_expired'))
    notifyPolice(NOTIFY_UNDO, 4, DarkRP.getPhrase('cprequest_expired', _player:Name()))
  end

  -- update new player with the current police requests
  hook.Add( 'PlayerInitialSpawn', 'policerequest_bulk', function(_player)
    net.Start(NET_BULK)
    net.WriteTable(requests)
    net.Send(_player)
  end )

end

if CLIENT then

  local requests = {}

  --[[---------------------------------------------------------------------------
    Returns the current received police requests
    @return {table} requests
  ]]-----------------------------------------------------------------------------
  function DarkRP.getPoliceRequests()
    if not LocalPlayer():isCP() or LocalPlayer():isMayor() then return end -- do not allow information to go outside if the player is not CP
    return requests
  end

  -- receive a new notification
  net.Receive( NET_ADD, function( len )
    local ent_index = net.ReadFloat()
    local pos = net.ReadVector()
    requests[ent_index] = pos
  end )

  -- receive a notification removal
  net.Receive( NET_REMOVE, function( len )
    local ent_index = net.ReadFloat()
    requests[ent_index] = nil
  end )

  -- receive notifications in bulk
  net.Receive( NET_BULK, function( len )
    local tbl = net.ReadTable()
    -- fill current table with the given contents
    for i, pos in pairs( tbl ) do
      requests[i] = pos
    end
  end )

end
