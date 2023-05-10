
DarkRP.isKevlarVestsInstalled = true

-- Reset kevlar variables
hook.Add( 'PlayerSpawn', 'kevlarvests_spawn', function( _player )
  if DarkRP.hasTeamKevlar( _player:Team() ) then
    _player:setKevlar( DarkRP.getTeamKevlar( _player:Team() ).kevlar_type )
  else
    _player:removeKevlar()
  end
end )

-- Remove kevlar if they switch jobs
hook.Add( 'OnPlayerChangedTeam', 'kevlarvests_job', function( _player, previous, current )
  if ( not DarkRP.hasTeamKevlar( previous ) and not DarkRP.hasTeamKevlar( current ) ) or ( DarkRP.hasTeamKevlar( previous ) and not DarkRP.getTeamKevlar( previous ).remove ) then return end
  if DarkRP.hasTeamKevlar( current ) then
    _player:setKevlar( DarkRP.getTeamKevlar( current ).kevlar_type )
  else
    _player:removeKevlar()
  end
end )
