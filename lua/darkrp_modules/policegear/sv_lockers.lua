--[[---------------------------------------------------------------------------
  Civil Protection supply lockers spawning
]]-----------------------------------------------------------------------------

local CLASS = 'cp_locker'

-- where the supply lockers spawn in every map
local spawns = {}

--[[---------------------------------------------------------------------------
  Adds a position and angle to spawn a supply locker in a map
  @param {string} map
  @param {Vector} position
  @param {Angle} angle
]]-----------------------------------------------------------------------------
function DarkRP.addSupplyLockerPos( map, pos, ang )
  if not spawns[map] then spawns[map] = {} end
  table.insert(spawns[map], { pos = pos, ang = ang })
end

--[[---------------------------------------------------------------------------
  Spawn locker
]]-----------------------------------------------------------------------------
hook.Add( 'InitPostEntity', 'policegear_lockers', function()
  local map_data = spawns[game.GetMap()]
  if not map_data then return end
  for _, pos in pairs(map_data) do
    local locker = ents.Create( CLASS )
    locker:SetPos( pos.pos )
    locker:SetAngles( pos.ang )
    locker:Spawn()
  end
end )

--[[---------------------------------------------------------------------------
  Default locations
]]-----------------------------------------------------------------------------
DarkRP.addSupplyLockerPos('rp_downtown_v2', Vector(-1687, 181, -160), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_downtown_v2_fiend_v2b', Vector(-2091, 205, 135), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_construct_v1', Vector(203, -1069, 100), Angle(0, -90, 0))
DarkRP.addSupplyLockerPos('rp_locality', Vector(-1462, -769, 20), Angle(0, -90, 0))
DarkRP.addSupplyLockerPos('rp_cscdesert_v2-1', Vector(2758, -8687, 44), Angle(0, 90, 0))
DarkRP.addSupplyLockerPos('rp_eastcoast_v4c', Vector(689, 393, 36), Angle(0, 90, 0))
DarkRP.addSupplyLockerPos('gm_construct', Vector(1015, -91, -108), Angle(0, 180, 0))
DarkRP.addSupplyLockerPos('rp_city19', Vector(1129, 1454, 579), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_city19', Vector(921, 4511, 531), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_city19', Vector(321, 5025, 532), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_tb_city45_v02n', Vector(691, 1624, 460), Angle(0, 180, 0))
DarkRP.addSupplyLockerPos('rp_bloc42_v2', Vector(2529, 621, 100), Angle(0, 0, 0))
DarkRP.addSupplyLockerPos('rp_downtown_v4c_v2', Vector(-1782, 223, -124), Angle(0, 0, 0))
