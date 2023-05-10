--[[---------------------------------------------------------------------------
  Classic advert system
]]-----------------------------------------------------------------------------

local NET = 'DarkRP_Advert'

if SERVER then

  util.AddNetworkString(NET)

  -- define chat command
  DarkRP.defineChatCommand('advert', function(_player, args)
    if string.len(string.Trim(args)) <= 0 then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('invalid_x', 'advert', DarkRP.getPhrase('too_short')))
      return ''
    end

    net.Start(NET)
    net.WriteFloat(_player:Team())
    net.WriteString(_player:Name())
    net.WriteString(args)
    net.Broadcast()
    return ''
  end)

end

if CLIENT then

  local FORMAT = '%s %s'
  local MSG_FORMAT = ': %s'
  local ADVERT_COLOUR = Color(255, 255, 0)

  -- add phrase
  DarkRP.addPhrase('en', 'advert', '[Advert]')

  -- receive advert
  net.Receive(NET, function(len)
    local _team = net.ReadFloat()
    local name = net.ReadString()
    local message = net.ReadString()
    chat.AddText(team.GetColor(_team), string.format(FORMAT, DarkRP.getPhrase('advert'), name), ADVERT_COLOUR, string.format(MSG_FORMAT, message))
  end)

end
