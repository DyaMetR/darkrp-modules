--[[---------------------------------------------------------------------------
  Custom OOC command so in chat it stands out from the rest of messages
  Code taken from the original chat module
  https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/chat/sv_chatcommands.lua
]]-----------------------------------------------------------------------------

local NET = 'darkrp_ooc'

if SERVER then
  util.AddNetworkString(NET)

  -- OOC
  local function OOC(ply, args)
      if not GAMEMODE.Config.ooc then
          DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("disabled", DarkRP.getPhrase("ooc"), ""))
          return ""
      end

      local DoSay = function(text)
          if text == "" then
              DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
              return ""
          end
          local col = team.GetColor(ply:Team())
          local col2 = Color(255, 255, 255, 255)
          if not ply:Alive() then
              col2 = Color(255, 200, 200, 255)
              col = col2
          end

          local name = ply:Nick()

          -- send message
          net.Start(NET)
          net.WriteColor(col)
          net.WriteString(name)
          net.WriteColor(col2)
          net.WriteString(text)
          net.Broadcast()
      end
      return args, DoSay
  end
  DarkRP.defineChatCommand("/", OOC, true, 1.5)
  DarkRP.defineChatCommand("a", OOC, true, 1.5)
  DarkRP.defineChatCommand("ooc", OOC, true, 1.5)

end

if CLIENT then

  local OOC_COLOUR = Color(255, 0, 0)
  local OOC_PREFIX = '(%s)'
  local NAME_FORMAT = ' %s'
  local MESSAGE_FORMAT = ': %s'

  -- receive and print message
  net.Receive(NET, function(len)
    local col = net.ReadColor()
    local name = net.ReadString()
    local col2 = net.ReadColor()
    local message = net.ReadString()

    chat.AddText(OOC_COLOUR, string.format(OOC_PREFIX, DarkRP.getPhrase('ooc')), col, string.format(NAME_FORMAT, name), col2, string.format(MESSAGE_FORMAT, message))
  end)

end
