--[[---------------------------------------------------------------------------
  Blocked entities
]]-----------------------------------------------------------------------------
local blockTypes = {'Physgun1', 'Spawning1', 'Toolgun1'}

FPP.AddDefaultBlocked(blockTypes, 'counterfeit_printer')
FPP.AddDefaultBlocked(blockTypes, 'pot_weed')
FPP.AddDefaultBlocked(blockTypes, 'spawned_weed')
FPP.AddDefaultBlocked(blockTypes, 'pot_shroom')
FPP.AddDefaultBlocked(blockTypes, 'spawned_shroom')

GM.Config.PocketBlacklist['counterfeit_printer'] = true
GM.Config.PocketBlacklist['pot_weed'] = true
GM.Config.PocketBlacklist['spawned_weed'] = true
GM.Config.PocketBlacklist['pot_shroom'] = true
GM.Config.PocketBlacklist['spawned_shroom'] = true
