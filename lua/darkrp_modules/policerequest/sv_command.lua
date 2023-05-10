--[[---------------------------------------------------------------------------
  Override original CombineRequest chat command to implement system
]]-----------------------------------------------------------------------------

local COMMANDS = {
  ['cr'] = true,
  ['911'] = true,
  ['999'] = true,
  ['112'] = true,
  ['000'] = true
}

-- has made the command
hook.Add('onChatCommand', 'policerequest_chatcommand', function(_player, command, args, _return)
  if not COMMANDS[command] or not args or string.len(string.Trim(args)) <= 0 then return end
  _player:addPoliceRequest()
end)

-- prohibit from requesting police help if they're already a CP
hook.Add('canChatCommand', 'policerequest_citizenonly', function(_player, command, args, _return)
  if not COMMANDS[command] then return end
  if not _player:attemptPoliceRequest() or not args or string.len(string.Trim(args)) <= 0 then return false end
end)
