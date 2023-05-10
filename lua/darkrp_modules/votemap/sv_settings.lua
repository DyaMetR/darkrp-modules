--[[---------------------------------------------------------------------------
  Settings
]]-----------------------------------------------------------------------------

-- votemapinitialcooldown -- Initial cooldown when the map starts
GM.Config.votemapinitialcooldown      = 30

-- votemapfreshspawncooldown -- Initial cooldown for new players
GM.Config.votemapfreshspawncooldown   = 300

-- minvotemapcooldown -- Minimum amount of cooldown when a vote is failed
GM.Config.minvotemapcooldown          = 600

-- maxvotemapcooldown -- Maximum amount of cooldown when the player's votes fail repeatedly
GM.Config.maxvotemapcooldown          = 1200

-- cooldownpermapvote -- Amount of cooldown added when a player's vote fail repeatedly
GM.Config.cooldownpermapvote          = 5

-- votemaptime -- Time the vote lasts for
GM.Config.votemaptime                 = 30

-- mapchangetime -- Time before the map changes
GM.Config.mapchangetime               = 30

-- votemapminplayers -- Minimum amount of players required to initiate a map vote
GM.Config.votemapminplayers           = 3

-- votemapsuccesspercentage -- Percentage of players that have to vote 'yes' to pass a map vote
GM.Config.votemapsuccesspercentage    = 90

--[[---------------------------------------------------------------------------
  Phrases
]]-----------------------------------------------------------------------------

-- notification phrases
DarkRP.addPhrase( 'en', 'votemap_initialcooldown', 'You need to let the server run this map %i seconds before voting another one.' )
DarkRP.addPhrase( 'en', 'votemap_freshspawncooldown', 'You need to play on this server for %i seconds before being able to make a vote.' )
DarkRP.addPhrase( 'en', 'votemap_cooldown', 'You have to wait %i seconds before being able to make a vote again.' )
DarkRP.addPhrase( 'en', 'votemap_players', 'Cannot start vote, not enough players present (>= %i).' )
DarkRP.addPhrase( 'en', 'votemap_success', 'Vote succeeded. Changing map to %s in %i seconds.' )
DarkRP.addPhrase( 'en', 'votemap_change', 'Changing map to %s...' )
DarkRP.addPhrase( 'en', 'votemap_fail', 'Map vote failed. Less than the %i%% of the server voted \'Yes\'.' )
DarkRP.addPhrase( 'en', 'votemap_votestarted', '%s has started a vote to change map to %s.' )
DarkRP.addPhrase( 'en', 'votemap', '%s\nwants to change map to\n%s' )
DarkRP.addPhrase( 'en', 'votemap_transition', 'Cannot vote for another map. Server is on a map transition progress.' )
DarkRP.addPhrase( 'en', 'votemap_already', 'There\'s already a map vote in progress.' )
DarkRP.addPhrase( 'en', 'votemap_abort', 'The map transition was aborted by an administrator.' )
DarkRP.addPhrase( 'en', 'votemap_nochange', 'There is no map transition in progress.' )

-- console phrases
DarkRP.addPhrase( 'en', 'votemap_log_startvote', 'Player %s (%s) started a vote to change map to %s.' )
DarkRP.addPhrase( 'en', 'votemap_log_votesuccess', 'Player %s (%s)\'s vote to change map to %s succeeded.' )
DarkRP.addPhrase( 'en', 'votemap_log_fail', 'Player %s (%s)\'s vote to change map to %s failed. Current map stays.' )
DarkRP.addPhrase( 'en', 'votemap_log_change', 'Map is changing to %s...' )
DarkRP.addPhrase( 'en', 'votemap_log_abort', 'Admin %s (%s) aborted the map change.' )
