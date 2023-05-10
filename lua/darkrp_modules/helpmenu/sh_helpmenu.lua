
local NET = 'DarkRP_ShowHelp'

local Player = FindMetaTable('Player')

DarkRP.declareChatCommand{
    command = 'help',
    description = 'Opens this menu.',
    delay = 1.5
}

if SERVER then

  util.AddNetworkString(NET)

  DarkRP.defineChatCommand('help', function(_player, args)
    net.Start(NET)
    net.Send(_player)
    return ''
  end)

end

if CLIENT then

  -- receive signal and toggle help menu
  net.Receive(NET, function(len)
    hook.Run('ShowHelp')
  end)

end
