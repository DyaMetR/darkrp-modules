
local DISTANCE = 50
local DOOR_TYPES = {
  ['func_door'] = true,
  ['prop_door'] = true
}
local FLAG = 32768 -- flag indicating a door should ignore +USE
local PROP_DOOR_ROTATING = 'prop_door_rotating'

local maps = {}

--[[---------------------------------------------------------------------------
  Adds a map that supports opening func_doors with the USE key
  @param {string} map name
]]-----------------------------------------------------------------------------
function DarkRP.addMapUseDoor(map)
  maps[map] = true
end

-- whether an entity is a door that is ignoring +USE
local function isIgnoreDoor(ent)
  return ent:GetClass() == PROP_DOOR_ROTATING and ent:HasSpawnFlags(FLAG)
end

-- get if player tries to use a door
hook.Add('KeyPress', 'cpdooruseopen', function(_player, key)
  if not maps[game.GetMap()] or not _player:Alive() or key ~= IN_USE then return end
  local trace = _player:GetEyeTrace()
  if not trace.Hit or (not DOOR_TYPES[trace.Entity:GetClass()] and not isIgnoreDoor(trace.Entity)) or trace.HitPos:Distance(_player:EyePos()) > DISTANCE then return end
  if _player:canKeysUnlock(trace.Entity) then -- if the can unlock it, they can open it
    trace.Entity:Fire('Toggle')
  end
end)

--[[---------------------------------------------------------------------------
  Default maps
]]-----------------------------------------------------------------------------
DarkRP.addMapUseDoor('rp_tb_city45_v02n')
DarkRP.addMapUseDoor('rp_city45_2020')
DarkRP.addMapUseDoor('rp_city19')
DarkRP.addMapUseDoor('rp_bloc42_v2')
