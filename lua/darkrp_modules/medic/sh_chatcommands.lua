--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

DarkRP.declareChatCommand{
    command = 'requestheal',
    description = 'Requests a medical treatment to the medic you\'re looking at.',
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'offerheal',
    description = 'As a Medic, offers a medical treatment to the player you\'re looking at.',
    condition = function( _player ) return _player:isMedic() end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'setbasefee',
    description = 'As a Medic, sets the minimum price to your medical treatment.',
    condition = function( _player ) return _player:isMedic() end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'sethealprice',
    description = 'As a Medic, sets the maximum price to your medical treatment.',
    condition = function( _player ) return _player:isMedic() end,
    delay = 1.5
}

DarkRP.declareChatCommand{
    command = 'buyhealth',
    description = 'As a Medic, restores your health for ' .. DarkRP.formatMoney(GAMEMODE.Config.buyhealthPrice) .. '.',
    condition = function( _player ) return _player:isMedic() end,
    delay = 1.5
}
