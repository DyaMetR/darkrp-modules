--[[---------------------------------------------------------------------------
  Declare chat command
]]-----------------------------------------------------------------------------

DarkRP.declareChatCommand{
    command = 'votekick',
    description = 'Create a vote to kick a player',
    delay = 3
}

DarkRP.declareChatCommand{
    command = 'abortvotekick',
    description = 'Aborts the current votekick',
    condition = function(_player) return _player:IsAdmin() end,
    delay = 1.5
}
