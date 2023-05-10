--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

DarkRP.defineChatCommand('votemap', function(_player, args)
  _player:makeMapVote( args )
  return ''
end)

DarkRP.defineChatCommand('abortmapchange', function(_player, args)
  if not _player:IsAdmin() then
    DarkRP.notify( _player, 1, 4, DarkRP.getPhrase( 'need_admin', 'abortmapchange' ) )
    return ''
  end
  _player:abortMapChange()
  return ''
end)
