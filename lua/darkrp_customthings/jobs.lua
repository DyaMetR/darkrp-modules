--[[---------------------------------------------------------------------------
  Police
]]-----------------------------------------------------------------------------

local POLICE = RPExtraTeams[TEAM_POLICE]
local CHIEF = RPExtraTeams[TEAM_CHIEF]

-- add weapons
table.Add(POLICE.weapons, { 'cp_pistol', 'weaponchecker_fast' })
table.Add(CHIEF.weapons, { 'chief_pistol', 'weaponchecker_fast' })

-- add ammunition
if not POLICE.ammo then POLICE.ammo = {} end
if not CHIEF.ammo then CHIEF.ammo = {} end
POLICE.ammo.pistol  = 54
CHIEF.ammo['357']   = 24

-- disable dropping
GM.Config.DisallowDrop.cp_pistol          = true
GM.Config.DisallowDrop.cp_smg             = true
GM.Config.DisallowDrop.cp_sniper          = true
GM.Config.DisallowDrop.chief_pistol       = true
GM.Config.DisallowDrop.ow_rifle           = true
GM.Config.DisallowDrop.ow_shotgun         = true
GM.Config.DisallowDrop.weaponchecker_fast = true

--[[---------------------------------------------------------------------------
  Mob Boss
]]-----------------------------------------------------------------------------
local MOB = RPExtraTeams[TEAM_MOB]

-- MOB.name = 'Mob Boss'
table.insert(MOB.weapons, 'keypad_cracker')
GM.Config.DisallowDrop.keypad_cracker = true

--[[---------------------------------------------------------------------------
  Guard
]]-----------------------------------------------------------------------------
GM.Config.DisallowDrop.guard_stick            = true
GM.Config.DisallowDrop.weaponchecker_guard    = true
