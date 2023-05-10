--[[---------------------------------------------------------------------------
  Setup spawns for vending machines
]]-----------------------------------------------------------------------------

local REPLACE_CLASS = 'prop_dynamic'

local spawns = {}

--[[---------------------------------------------------------------------------
  Adds a spawn position for a map
  @param {string} map
  @param {Vector} position
  @param {Angles} angles
]]-----------------------------------------------------------------------------
function DarkRP.addVendingMachineSpawn(map, pos, ang)
  if not spawns[map] then
    spawns[map] = {}
  end
  table.insert(spawns[map], {pos = pos, ang = ang or Angle(0, 0, 0)})
end

-- spawn vending machines
hook.Add('InitPostEntity', 'vendingmachines_spawn', function()
  -- check if there are any fake vending machines and replace them
  if GAMEMODE.Config.replaceVendingMachines then
    for _, ent in pairs(ents.GetAll()) do
      if ent:GetClass() ~= REPLACE_CLASS then continue end
      if GAMEMODE.Config.vendingReplace[string.lower(ent:GetModel())] then
        DarkRP.spawnVendingMachine(ent:GetPos(), ent:GetAngles())
        ent:Remove()
      end
    end
  end
  -- check map configuration
  local map = game.GetMap()
  local data = spawns[map]
  if not data then return end
  for _, vM in pairs(data) do
    DarkRP.spawnVendingMachine(vM.pos, vM.ang)
  end
end)

--[[---------------------------------------------------------------------------
  Default configuration
]]-----------------------------------------------------------------------------

-- rp_bangclaw
local bangclaw = 'rp_bangclaw'
DarkRP.addVendingMachineSpawn(bangclaw, Vector(-1258, -765, 120))
DarkRP.addVendingMachineSpawn(bangclaw, Vector(725, 1261, 120))
DarkRP.addVendingMachineSpawn(bangclaw, Vector(5482, -2607, 120), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(bangclaw, Vector(2417, -834, 120), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(bangclaw, Vector(3882, -489, 120), Angle(0, 180, 0))

-- rp_bloc42_v2
local bloc42 = 'rp_bloc42_v2'
DarkRP.addVendingMachineSpawn(bloc42, Vector(1346, 1226, -15), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(bloc42, Vector(7196, -2154, -15), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(bloc42, Vector(2893, 2261, -79), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(bloc42, Vector(5968, 1578, -79), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(bloc42, Vector(3562, 91, 48), Angle(0, -180, 0))

-- rp_city19
local city19 = 'rp_city19'
DarkRP.addVendingMachineSpawn(city19, Vector(615, 661, 336), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(city19, Vector(-995, -711, 336), Angle(0, 0, 0))
DarkRP.addVendingMachineSpawn(city19, Vector(-2159, -21, 376), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(city19, Vector(-1733, 1402, 336), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(city19, Vector(3627, 2025, 336), Angle(0, -90, 0))

-- rp_cscdesert_v2-1
local cscdesert = 'rp_cscdesert_v2-1'
DarkRP.addVendingMachineSpawn(cscdesert, Vector(1365, -9111, 48))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(3818, -9395, 48), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(-1095, 7445, 64), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(-2841, 5290, -143), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(2451, 2730, -975), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(8170, 2695, -527), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(cscdesert, Vector(5186, -1162, -102), Angle(-82, -74, -90))

-- rp_downtown_v2
local downtownv2 = 'rp_downtown_v2'
DarkRP.addVendingMachineSpawn(downtownv2, Vector(-1060, -370, -147), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(downtownv2, Vector(-1891, 341, -831), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(downtownv2, Vector(57, 429, -147), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(downtownv2, Vector(1322, -1419, -143), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(downtownv2, Vector(-1977, -194, -407))

-- rp_downtown_v2_fiend_v2b
local downtownv2fiend = 'rp_downtown_v2_fiend_v2b'
DarkRP.addVendingMachineSpawn(downtownv2fiend, Vector(-1465, -402, 148), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(downtownv2fiend, Vector(-2296, 343, -535), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(downtownv2fiend, Vector(917, -1419, 152), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(downtownv2fiend, Vector(-2383, -197, -111))
DarkRP.addVendingMachineSpawn(downtownv2fiend, Vector(-345, 431, 148), Angle(0, 90, 0))

-- rp_downtown_v4c_v2
local downtownv4 = 'rp_downtown_v4c_v2'
DarkRP.addVendingMachineSpawn(downtownv4, Vector(-1777, -677, -147), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(downtownv4, Vector(-67, 430, -147), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(downtownv4, Vector(2341, 2565, -147))
DarkRP.addVendingMachineSpawn(downtownv4, Vector(2460, -549, -147), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(downtownv4, Vector(-297, -1856, -147))
DarkRP.addVendingMachineSpawn(downtownv4, Vector(-1138, -7236, -150))

-- rp_eastcoast_v4c
local eastcoast = 'rp_eastcoast_v4c'
DarkRP.addVendingMachineSpawn(eastcoast, Vector(3654, 21, 144), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(1301, -607, 16))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(2457, -2764, 16), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(2444, -1642, 16), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(-917, -897, 16), Angle(0, 180, 0))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(-3329, 805, 48), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(eastcoast, Vector(-1445, 1205, -143), Angle(0, 90, 0))

-- gm_construct
local gmconstruct = 'gm_construct'
DarkRP.addVendingMachineSpawn(gmconstruct, Vector(1098, 303, -95), Angle(0, 180, 0))

-- rp_construct_v1
local rpconstruct = 'rp_construct_v1'
DarkRP.addVendingMachineSpawn(rpconstruct, Vector(-18, 1390, 80))
DarkRP.addVendingMachineSpawn(rpconstruct, Vector(-106, 57, 80))
DarkRP.addVendingMachineSpawn(rpconstruct, Vector(972, 1305, 80), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(rpconstruct, Vector(537, -2125, 76), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(rpconstruct, Vector(1621, 177, 80))

-- rp_locality
local locality = 'rp_locality'
--DarkRP.addVendingMachineSpawn(locality, Vector(-1910, -1546, 32), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(locality, Vector(-1997, -385, 32), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(locality, Vector(-1957, 1527, 40), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(locality, Vector(250, -35, 41), Angle(0, -180, 0))
DarkRP.addVendingMachineSpawn(locality, Vector(-3190, 410, -335))

-- rp_tb_city45_v02n
local city45 = 'rp_tb_city45_v02n'
DarkRP.addVendingMachineSpawn(city45, Vector(-2980, 2837, 271), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(city45, Vector(-1526, 2768, 271))
DarkRP.addVendingMachineSpawn(city45, Vector(-472, 3838, 232), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(city45, Vector(1850, 3160, 232), Angle(0, -90, 0))
DarkRP.addVendingMachineSpawn(city45, Vector(-2748, 533, 232), Angle(0, 90, 0))
DarkRP.addVendingMachineSpawn(city45, Vector(8765, -1685, 228), Angle(0, -90, 0))
