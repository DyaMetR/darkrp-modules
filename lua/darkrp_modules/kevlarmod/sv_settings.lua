--[[---------------------------------------------------------------------------
  KevlarMod settings
]]-----------------------------------------------------------------------------

-- headdamage -- damage multiplier to the head
GM.Config.headdamage = 6

-- torsodamage -- damage multiplier to the torso
GM.Config.torsodamage = 1.25

-- armsdamage -- damage multiplier to the arms
GM.Config.armsdamage = .35

-- legsdamage -- damage multiplier to the legs
GM.Config.legsdamage = .5

--[[---------------------------------------------------------------------------
  Armour drop block
]]-----------------------------------------------------------------------------
local blockTypes = {'Physgun1', 'Spawning1', 'Toolgun1'}

FPP.AddDefaultBlocked(blockTypes, 'armour_civilian')
FPP.AddDefaultBlocked(blockTypes, 'armour_advanced')
FPP.AddDefaultBlocked(blockTypes, 'armour_contraband')
