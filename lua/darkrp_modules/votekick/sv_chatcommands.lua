--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

-- vote kick
DarkRP.defineChatCommand( 'votekick', function( _player, args )
  local namepos = string.find(args, " ")
  if not namepos then
      DarkRP.notify( _player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), '') )
      return ''
  end

  local name = string.sub(args, 1, namepos - 1)
  local reason = string.sub(args, namepos + 1)
  if reason == '' then
      DarkRP.notify( _player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), '') )
      return ''
  end

  _player:makeKickVote( DarkRP.findPlayer( name ), reason )
  return ''
end )

-- abort current vote kick
DarkRP.defineChatCommand( 'abortvotekick', function( _player, args )
  if not _player:IsAdmin() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('need_admin', 'abortvotekick'))
    return ''
  end
  DarkRP.abortVotekick()
  return ''
end )
