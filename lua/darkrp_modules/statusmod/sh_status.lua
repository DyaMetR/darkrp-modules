--[[---------------------------------------------------------------------------
  Status (effect grouping) declaration
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

local NET_ADD = 'statusmod_status_add'
local NET_REMOVE = 'statusmod_status_remove'
local NET_CLEAR = 'statusmod_status_clear'

local statuses = {}

--[[---------------------------------------------------------------------------
  Declares a status
  @param {number|string} identifier
  @param {table} status data
  - name (print name)
  - desc (description)
  - icon (Material)
  - effects (table with effects to apply)
    [EFFECT_ID] = { args }
  - on_add (function called when the effect is applied to a player)
    > player (Player to apply the status to)
    > instance (effect instance identifier)
  - on_expire (function called when the status expires)
    > player (Player to apply the status to)
    > instance (effect instance identifier)
  @return {number} table position
]]-----------------------------------------------------------------------------
function DarkRP.addStatus(id, status_data)
  if CLIENT then
    statuses[id] = { name = status_data.name, desc = status_data.desc, icon = status_data.icon, effects = status_data.effects }
  end

  if SERVER then
    statuses[id] = { on_add = status_data.on_add, effects = status_data.effects, on_expire = status_data.on_expire }
  end

  return id
end

--[[---------------------------------------------------------------------------
  Gets a status' data
  @param {number|string} identifier
  @return {table} status data
]]-----------------------------------------------------------------------------
function DarkRP.getStatus(status)
  return statuses[status]
end

if SERVER then

  util.AddNetworkString(NET_ADD)
  util.AddNetworkString(NET_REMOVE)
  util.AddNetworkString(NET_CLEAR)

  local EFFECT_NAME = '%s_%s'

  --[[---------------------------------------------------------------------------
    Whether the player has the current status instance
    @param {number|string} status instance
    @return {boolean} has status instance
  ]]-----------------------------------------------------------------------------
  function Player:hasStatus(instance)
    return self.StatusMod.statuses[instance]
  end

  --[[---------------------------------------------------------------------------
    Applies a status to the player
    @param {number|string} status identifier
    @param {number|string} status instance
  ]]-----------------------------------------------------------------------------
  function Player:addStatus(status, instance)
    local on_add = DarkRP.getStatus( status ).on_add

    self.StatusMod.statuses[instance] = { type = status, effects = {} }

    for effect, args in pairs(DarkRP.getStatus( status ).effects) do
      local id = string.format(EFFECT_NAME, instance, effect)
      self.StatusMod.statuses[instance].effects[id] = effect
      self:addStatusEffect(effect, id, status, unpack(args))
    end

    if on_add then on_add(self, instance) end

    -- send to client
    net.Start(NET_ADD)
    net.WriteString(status)
    net.WriteString(instance)
    net.Send(self)
  end

  --[[---------------------------------------------------------------------------
    Removes a status and its effects from the player
    @param {number|string} instance
  ]]-----------------------------------------------------------------------------
  function Player:removeStatus(instance)
    local status = self.StatusMod.statuses[instance]
    local on_expire = DarkRP.getStatus(status.type).on_expire

    if on_expire then on_expire(self, instance) end

    -- remove effects
    for effect, _ in pairs(status.effects) do
      if not self.StatusMod.effects[effect] then continue end
      self:removeStatusEffect(effect)
    end

    self.StatusMod.statuses[instance] = nil

    -- send to client
    net.Start(NET_REMOVE)
    net.WriteString(instance)
    net.Send(self)
  end

  --[[---------------------------------------------------------------------------
    Removes all statuses
  ]]-----------------------------------------------------------------------------
  function Player:flushStatuses()
    for status, _ in pairs(self.StatusMod.statuses) do
      self:removeStatus(status)
    end

    -- send to client
    net.Start(NET_CLEAR)
    net.Send(self)
  end

end

if CLIENT then

  local cl_statuses = {} -- clientside only statuses
  local active_statuses = {}
  local effects_priority = {} -- which status has the best implementation of the effect

  --[[---------------------------------------------------------------------------
    Adds a custom status type that doesn't utilize the framework, but a custom
    function to determine whether it's present
    @param {string} identifier
    @param {string} name
    @param {string} description
    @param {Material} icon
    @param {function} function that returns whether is present or not
  ]]-----------------------------------------------------------------------------
  function DarkRP.addClientStatus(id, name, desc, icon, func)
    cl_statuses[id] = { name = name, desc = desc, icon = icon, func = func }
  end

  --[[---------------------------------------------------------------------------
    Gets all available client statuses
    @return {table} statuses
  ]]-----------------------------------------------------------------------------
  function DarkRP.getClientStatuses()
    return cl_statuses
  end

  --[[---------------------------------------------------------------------------
    Gets all currently active statuses
    @return {table} active statuses
  ]]-----------------------------------------------------------------------------
  function DarkRP.getActiveStatuses()
    return active_statuses
  end

  --[[---------------------------------------------------------------------------
    Gets an active status' details
    @param {number|string} status instance
    @return {table} details
  ]]-----------------------------------------------------------------------------
  function DarkRP.getActiveStatus(instance)
    return active_statuses[instance]
  end

  --[[---------------------------------------------------------------------------
    Whether the given status has an effect overriden by another one
    @param {string} status
    @param {string} effect
    @return {boolean} is overriden
    @return {string} best status
  ]]-----------------------------------------------------------------------------
  function DarkRP.isStatusEffectOverriden(status, effect)
    return effects_priority[effect] and effects_priority[effect] ~= status, effects_priority[effect]
  end

  -- update the currently best status for the given effect
  local function checkBestStatusForEffect(effect)
    if not DarkRP.getStatusEffect(effect).unstackable then return end

    effects_priority[effect] = nil

    for instance, status in pairs(active_statuses) do
      if not DarkRP.getStatus(status).effects[effect] then continue end

      if not effects_priority[effect] then
        effects_priority[effect] = status
      else
        if DarkRP.getStatusEffect(effect).compare(DarkRP.getStatus(status).effects[effect], DarkRP.getStatus(effects_priority[effect]).effects[effect]) then
          effects_priority[effect] = status
        end
      end
    end
  end

  -- receive new status
  net.Receive(NET_ADD, function(len)
    local status = net.ReadString()
    local instance = net.ReadString()

    active_statuses[instance] = status

    for effect, _ in pairs(DarkRP.getStatus(status).effects) do
      checkBestStatusForEffect(effect)
    end
  end)

  -- receive status deletion
  net.Receive(NET_REMOVE, function(len)
    local instance = net.ReadString()

    if not active_statuses[instance] then return end

    for effect, _ in pairs(DarkRP.getStatus(active_statuses[instance]).effects) do
      checkBestStatusForEffect(effect)
    end

    active_statuses[instance] = nil
  end)

  -- receive new status
  net.Receive(NET_CLEAR, function(len)
    table.Empty(effects_priority)
    table.Empty(active_statuses)
  end )

end
