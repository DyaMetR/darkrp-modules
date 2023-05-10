--[[---------------------------------------------------------------------------
  Entity synchronization
]]-----------------------------------------------------------------------------

local NET_CLEAR = 'securityguard_entities_clear'
local NET_BULK = 'securityguard_entities_bulk'
local NET_REMOVE = 'securityguard_entities_remove'
local NET = 'securityguard_entities_update'

if SERVER then

  util.AddNetworkString(NET)
  util.AddNetworkString(NET_BULK)
  util.AddNetworkString(NET_CLEAR)
  util.AddNetworkString(NET_REMOVE)

  local entities = {}

  local isValidClient

  --[[---------------------------------------------------------------------------
    Registers an entity type to be sent to a security guard, function returns a
    value between 0 and 1
    @param {string} entity class name
    @param {function} health fetching function
  ]]-----------------------------------------------------------------------------
  function DarkRP.registerSecuredEntity(class_name, health_function)
    entities[class_name] = health_function
  end

  --[[---------------------------------------------------------------------------
    Gets a registered entity type health fetching function
    @param {string} entity class name
    @return {function} health fetching function
  ]]-----------------------------------------------------------------------------
  function DarkRP.getSecuredEntity(class_name)
    return entities[class_name]
  end

  --[[---------------------------------------------------------------------------
    Sends a signal to this guard's client to clear the entities list
    @param {Player} security guard
  ]]-----------------------------------------------------------------------------
  function DarkRP.clearSecurityEntities(guard)
    net.Start(NET_CLEAR)
    net.Send(guard)
  end

  --[[---------------------------------------------------------------------------
    Synchronizes a security guard's client entities
    @param {Player} security guard client
  ]]-----------------------------------------------------------------------------
  function DarkRP.syncSecurityEntities(client)
    if not isValidClient(client) then return end

    local _entities = {}

    for _, ent in pairs(ents.GetAll()) do
      if not entities[ent:GetClass()] or ent.SID ~= client. SID then continue end
      _entities[ent:EntIndex()] = entities[ent:GetClass()](ent)
    end

    net.Start(NET_BULK)
    net.WriteTable(_entities)
    net.Send(client:getSecurityContractTarget())
  end

  --[[---------------------------------------------------------------------------
    Sends the health of an entity to the security guard
    @param {Entity} entity
  ]]-----------------------------------------------------------------------------
  function DarkRP.updateSecurityEntity(ent)
    if not entities[ent:GetClass()] then return end
    if not isValidClient(ent:Getowning_ent()) then return end

    net.Start(NET)
    net.WriteFloat(ent:EntIndex())
    net.WriteFloat(entities[ent:GetClass()](ent))
    net.Send(ent:Getowning_ent():getSecurityContractTarget())
  end

  --[[---------------------------------------------------------------------------
    Send a signal to the guard's client to remove this entity
    @param {Entity} entity
  ]]-----------------------------------------------------------------------------
  function DarkRP.securityEntityRemoved(ent)
    if not entities[ent:GetClass()] or not isValidClient(ent:Getowning_ent()) then return end

    net.Start(NET_REMOVE)
    net.WriteFloat(ent:EntIndex())
    net.Send(ent:Getowning_ent():getSecurityContractTarget())
  end

  --[[---------------------------------------------------------------------------
    Whether the given player is a valid security guard client
    @param {Player} client
    @return {boolean} whether it's a valid client
  ]]-----------------------------------------------------------------------------
  isValidClient = function(_player)
    return IsValid(_player) and not _player:isSecurityGuard() and _player:getSecurityContractTarget()
  end

  --[[---------------------------------------------------------------------------
    Register spawned entity
  ]]-----------------------------------------------------------------------------
  hook.Add('playerBoughtCustomEntity', 'securityguard_spawnent', function(_player, data, ent, cost)
    DarkRP.updateSecurityEntity(ent)
  end)

  --[[---------------------------------------------------------------------------
    Register removed entity
  ]]-----------------------------------------------------------------------------
  hook.Add('EntityRemoved', 'securityguard_removeent', function(ent)
    DarkRP.securityEntityRemoved(ent)
  end)

  --[[---------------------------------------------------------------------------
    Update entity on damage
  ]]-----------------------------------------------------------------------------
  hook.Add('EntityTakeDamage', 'securityguard_entdamage', function(ent, dmginfo)
    DarkRP.updateSecurityEntity(ent)
  end)

  --[[---------------------------------------------------------------------------
    Default entities
  ]]-----------------------------------------------------------------------------
  DarkRP.registerSecuredEntity('microwave', function(ent) return ent.damage / 100 end)
  DarkRP.registerSecuredEntity('money_printer', function(ent) return ent.damage / 100 end)
  DarkRP.registerSecuredEntity('drug_lab', function(ent) return ent.damage / 100 end)
  DarkRP.registerSecuredEntity('gunlab', function(ent) return ent.damage / 100 end)

  -- load modules entities
  DarkRP.DARKRP_LOADING = true

  DarkRP.registerSecuredEntity('stove', function(ent) return ent.damage / 200 end)
  DarkRP.registerSecuredEntity('sc_terminal', function(ent) return ent.damage / 300 end)
  DarkRP.registerSecuredEntity('sc_acetylator', function(ent) return ent.damage / 150 end)
  DarkRP.registerSecuredEntity('sc_diluent', function(ent) return ent.damage / 100 end)
  DarkRP.registerSecuredEntity('sc_methlab', function(ent) return ent.damage / 250 end)
  DarkRP.registerSecuredEntity('home_printer', function(ent) return ent.Damage / 25 end)
  DarkRP.registerSecuredEntity('modern_printer', function(ent) return ent.Damage / 200 end)
  DarkRP.registerSecuredEntity('counterfeit_printer', function(ent) return ent.Damage / 100 end)
  DarkRP.registerSecuredEntity('mob_printer', function(ent) return ent.Damage / 125 end)
  DarkRP.registerSecuredEntity('science_printer', function(ent) return ent.Damage / 150 end)

  DarkRP.DARKRP_LOADING = nil

end

if CLIENT then

  local entities = {}

  -- returns all of the currently tracked entities
  function DarkRP.getSecurityTrackedEntities()
    return entities
  end

  -- receive bulk data
  net.Receive(NET_BULK, function(len)
    entities = net.ReadTable()
  end)

  -- receive entity update
  net.Receive(NET, function(len)
    local entIndex = net.ReadFloat()
    local health = net.ReadFloat()
    hook.Run('securityEntityUpdated', entIndex, entities[entIndex] or 0, health)
    entities[entIndex] = health
  end)

  -- receive entity cleanup
  net.Receive(NET_CLEAR, function(len)
    table.Empty(entities)
  end)

  -- receive entity removal
  net.Receive(NET_REMOVE, function(len)
    local entIndex = net.ReadFloat()
    entities[entIndex] = nil
  end)

end
