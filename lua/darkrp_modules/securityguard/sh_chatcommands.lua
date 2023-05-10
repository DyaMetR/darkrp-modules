--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

DarkRP.declareChatCommand{
    command = 'requestsecurity',
    description = 'Requests security services to a Security Guard.',
    condition = function(_player) return not _player:isSecurityGuard() end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'offersecurity',
    description = 'Offers security services to a player.',
    condition = Player.isSecurityGuard,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'endsecuritycontract',
    description = 'Ends the current security contract.',
    condition = function(_player) return _player:getDarkRPVar('guardContract') end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'buykevlar',
    description = 'As a Security Guard, it replaces your current kevlar vest with a new one for ' .. DarkRP.formatMoney( GAMEMODE.Config.buyKevlarPrice or 0 ),
    condition = function( _player ) return _player:Team() == TEAM_SECURITYGUARD and _player:getDarkRPVar( 'money' ) >= GAMEMODE.Config.buyKevlarPrice end,
    delay = 1.5
}
