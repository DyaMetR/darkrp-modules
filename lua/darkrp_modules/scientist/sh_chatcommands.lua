--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

DarkRP.declareChatCommand{
    command = 'scientisthelp',
    description = 'Toggles the help box for the Scientist.',
    condition = Player.isScientist,
    delay = 1.5
}
