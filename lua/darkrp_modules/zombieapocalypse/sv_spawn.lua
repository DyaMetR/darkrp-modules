
-- constants
local TIMER = 'zombieapocalypse_spawn'
local PLAYER_CLASS = 'player'
local RADIUS = 120

-- variables
local spawns = {} -- stored spawns
local class_spawns = {} -- stored spawns for specific classes
local enemy_types = {} -- enemy classes to spawn
local class_rewards = {} -- money reward per class
local dispensers = {} -- stored spawns for dispensers
local spawned_enemies = {} -- spawned enemies
local spawned_dispensers = {} -- spawned weapon dispensers
local gun_dealers = 0 -- gun dealers present

--[[---------------------------------------------------------------------------
  Whether the current map supports Zombie Apocalypse
  @return {boolean} is map supported
]]-----------------------------------------------------------------------------
function DarkRP.isMapSupportedByZombieApocalypse()
  return table.Count(spawns[game.GetMap()]) > 0
end

--[[---------------------------------------------------------------------------
  Adds a spawning position for a zombie
  @param {string} map
  @param {Vector} position
  @param {string|nil} (optional) restrict to npc class
]]-----------------------------------------------------------------------------
function DarkRP.addZombieSpawn(map, pos, class)
  if class then
    if not class_spawns[map] then class_spawns[map] = {} end
    if not class_spawns[map][class] then class_spawns[map][class] = {} end
    table.insert(class_spawns[map][class], pos)
  else
    if not spawns[map] then spawns[map] = {} end
    table.insert(spawns[map], pos)
  end
end

--[[---------------------------------------------------------------------------
  Gets all of the available zombie spawns for the current map
  @return {table} spawns
]]-----------------------------------------------------------------------------
function DarkRP.getZombieSpawns()
  local map = game.GetMap()
  if not spawns[map] then return {} end
  return spawns[map]
end

--[[---------------------------------------------------------------------------
  Gets all of the available zombie spawns for the current map and the given class
  Returns the general spawn list if no specific spawns were found
  @param {string} class
  @return {table} spawns
]]-----------------------------------------------------------------------------
function DarkRP.getZombieSpawnsForClass(class)
  return class_spawns[game.GetMap()][class]
end

--[[---------------------------------------------------------------------------
  Adds an enemy class to spawn
  @param {string} class
  @param {number} kill reward
]]-----------------------------------------------------------------------------
function DarkRP.addEnemyType(class, reward)
  table.insert(enemy_types, class)
  class_rewards[class] = reward
end

--[[---------------------------------------------------------------------------
  Gets all enemy classes to spawn
  @return {table} enemy types
]]-----------------------------------------------------------------------------
function DarkRP.getEnemyTypes()
  return enemy_types
end

--[[---------------------------------------------------------------------------
  Gets the reward to receive for killing an enemy of the given class
  @param {string} class
  @return {number} reward
]]-----------------------------------------------------------------------------
function DarkRP.getEnemyKillReward(class)
  return class_rewards[class] or 0
end

--[[---------------------------------------------------------------------------
  Adds a zombie weapon dispenser position
  @param {string} map
  @return {Vector} position
]]-----------------------------------------------------------------------------
function DarkRP.addZombieWeaponDispenserPos(map, pos)
  if not dispensers[map] then dispensers[map] = {} end
  table.insert(dispensers[map], pos)
end


--[[---------------------------------------------------------------------------
  Spawns the weapon dispenser
]]-----------------------------------------------------------------------------
function DarkRP.spawnZombieWeaponDispensers()
  local map_dispensers = dispensers[game.GetMap()]
  if not map_dispensers then return end
  for _, pos in pairs(map_dispensers) do
    local ent = ents.Create('weapondispenser')
    ent:SetPos(pos)
    ent:Spawn()
    spawned_dispensers[ent:EntIndex()] = ent
  end
end

--[[---------------------------------------------------------------------------
  Removes the weapon dispenser
]]-----------------------------------------------------------------------------
function DarkRP.removeZombieWeaponDispensers()
  for i, ent in pairs(spawned_dispensers) do
    ent:Remove()
    spawned_dispensers[i] = nil
  end
end

--[[---------------------------------------------------------------------------
  Whether the given position is obstructed by a player or another NPC
  @param {Vector} position
  @return {boolean} obstructed
]]-----------------------------------------------------------------------------
local function isSpawnPointObstructed(pos)
  local block = ents.FindInSphere(pos, RADIUS)
  for _, ent in pairs(block) do
    if ent:GetClass() == PLAYER_CLASS or class_rewards[ent:GetClass()] then
      return true
    end
  end
  return false
end

--[[---------------------------------------------------------------------------
  Starts spawning enemies at random positions
]]-----------------------------------------------------------------------------
function DarkRP.startZombieSpawnRoutine()
  timer.Create(TIMER, DarkRP.getZombieSpawnRate(), 0, function()
    if table.Count(spawned_enemies) >= DarkRP.getMaxZombies() then return end
    local class = enemy_types[math.random(1, #enemy_types)]
    local spawns = DarkRP.getZombieSpawns()

    -- select spawn at random
    local spawn = spawns[math.random(1, #spawns)]
    if class_spawns[game.GetMap()] then
      local class_spawns = DarkRP.getZombieSpawnsForClass(class)
      if class_spawns then
        local i = math.random(1, #spawns + #class_spawns)
        if i > #spawns then
          spawn = class_spawns[i - #spawns]
        end
      end
    end

    -- check if the spawn is available
    local blocked = isSpawnPointObstructed(spawn)
    if blocked then
      if DarkRP.isZombieCheapSpawningEnabled() then return end -- skip spawn if 'cheap spawns' is enabled
      -- look for another spawn (costly operation)
      for _, pos in pairs(spawns) do
        if not isSpawnPointObstructed(pos) then
          spawn = pos
          break;
        end
      end
    end

    -- spawn new enemy
    local ent = ents.Create(class)
    ent:SetPos(spawn)
    ent:Spawn()
    spawned_enemies[ent:EntIndex()] = ent -- add to enemies list
  end)
end

--[[---------------------------------------------------------------------------
  Stops spawning enemies and removes all of the previously spawned ones (if enabled)
]]-----------------------------------------------------------------------------
function DarkRP.stopZombieSpawnRoutine()
  timer.Remove(TIMER)
  if DarkRP.shouldRemoveZombiesOnEnd() then
    for i, zombie in pairs(spawned_enemies) do
      if IsValid(zombie) then
        zombie:Remove()
      end
      spawned_enemies[i] = nil
    end
  end
end

--[[---------------------------------------------------------------------------
  Remove enemy from list if removed
]]-----------------------------------------------------------------------------
hook.Add('OnEntityRemoved', 'zombieapocalypse_unlist_remove', function(npc)
  if not npc:IsNPC() then return end
  if not spawned_enemies[npc:EntIndex()] then return end
  spawned_enemies[npc:EntIndex()] = nil
end)

--[[---------------------------------------------------------------------------
  Remove enemy from list if killed
]]-----------------------------------------------------------------------------
hook.Add('OnNPCKilled', 'zombieapocalypse_unlist', function(npc, attacker, inflictor)
  if not spawned_enemies[npc:EntIndex()] then return end
  spawned_enemies[npc:EntIndex()] = nil
end)

--[[---------------------------------------------------------------------------
  Make weapon dispenser not work if there's a gun dealer present
]]-----------------------------------------------------------------------------
-- team changed
hook.Add('PlayerChangedTeam', 'zombieapocalypse_newdealer', function(_player, oldTeam, newTeam)
  if not DarkRP.isZombieApocalypseActive() then return end
  if oldTeam == TEAM_GUN then
    gun_dealers = math.max(gun_dealers - 1, 0)
  elseif newTeam == TEAM_GUN then
    gun_dealers = gun_dealers + 1
  end
  for _, dispenser in pairs(spawned_dispensers) do
    dispenser:SetAvailable(gun_dealers <= 0)
  end
end)

-- gun dealer disconnects
hook.Add('PlayerDisconnected', 'zombieapocalypse_dealerdisconnect', function(_player)
  if not DarkRP.isZombieApocalypseActive() then return end
  if _player:Team() == TEAM_GUN then
    gun_dealers = math.max(gun_dealers - 1, 0)
    for _, dispenser in pairs(spawned_dispensers) do
      dispenser:SetAvailable(gun_dealers <= 0)
    end
  end
end)
