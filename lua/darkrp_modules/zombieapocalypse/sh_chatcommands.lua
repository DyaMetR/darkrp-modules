--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

-- add FAdmin privilege for command
FAdmin.Access.AddPrivilege('ZombieApocalypse', 2)

local Player = FindMetaTable('Player')

DarkRP.declareChatCommand{
    command = 'startzombieapocalypse',
    description = 'Starts a zombie invasion event.',
    condition = function(_player) return (FAdmin.Access.PlayerHasPrivilege(_player, 'ZombieApocalypse') or _player:IsAdmin()) and not DarkRP.isZombieApocalypseActive() end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'endzombieapocalypse',
    description = 'Ends the current zombie invasion event.',
    condition = function(_player) return (FAdmin.Access.PlayerHasPrivilege(_player, 'ZombieApocalypse') or _player:IsAdmin()) and DarkRP.isZombieApocalypseActive() end,
    delay = 1.5
}
