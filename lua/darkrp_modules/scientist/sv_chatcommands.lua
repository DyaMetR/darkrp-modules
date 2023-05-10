--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

-- scientist help
DarkRP.defineChatCommand('scientisthelp', function(_player, args)
  if not _player:isScientist() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('scientist_only'))
    return ''
  end

  _player:ConCommand('rp_scientisthelp ' .. math.abs(_player:GetInfoNum('rp_scientisthelp', 1) - 1))

  return ''
end)
