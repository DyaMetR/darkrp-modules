--[[---------------------------------------------------------------------------
  Settings
]]-----------------------------------------------------------------------------

-- novotekickwithadmins -- Whether Votekick should be disabled when admins are present
GM.Config.novotekickwithadmins         = false

-- votekickbanleavers -- Whether players that are being voted off get banned if they leave
GM.Config.votekickbanleavers           = true

-- votekickfreshspawncooldown -- Initial cooldown for new players
GM.Config.votekickfreshspawncooldown   = 300

-- minvotekickcooldown -- Minimum amount of cooldown when a vote fails
GM.Config.minvotekickcooldown          = 600

-- maxvotekickcooldown -- Maximum amount of cooldown when the player's votes fail repeatedly
GM.Config.maxvotekickcooldown          = 1200

-- votekickcooldown -- Amount of cooldown added with each failed vote
GM.Config.votekickcooldown             = 120

-- minvotekickbantime -- Minimum amount of minutes a player is banned
GM.Config.minvotekickbantime           = 5

-- votekickbantime -- Amount of minutes a player is additionally banned when repeatedly votekicked
GM.Config.votekickbantime              = 5

-- maxvotekickbantime -- Maximum amount of minutes a player is banned
GM.Config.maxvotekickbantime           = 15

-- votekickminplayers -- Minimum amount of players required to start a kick vote
GM.Config.votekickminplayers           = 5

-- votekicksuccesspercentage -- Percentage of players that have to vote 'yes' to pass a kick vote
GM.Config.votekicksuccesspercentage    = 75

-- maxreasonlength -- Maximum amount of characters allows to explain a vote kick reason
GM.Config.maxreasonlength              = 40

-- minreasonlength -- Minimum amount of characters allows to explain a vote kick reason
GM.Config.minreasonlength              = 3

-- votekicktime -- Time the vote lasts for
GM.Config.votekicktime                 = 30

-- bantimecooldownresettime -- How much times does a player need to go by without getting kicked to reset the penalty accumulation
GM.Config.bantimecooldownresettime     = 3600

--[[---------------------------------------------------------------------------
  Phrases
]]-----------------------------------------------------------------------------

-- notification
DarkRP.addPhrase('en', 'votekick_admins', 'There are admins online. Refer to them to solve your issue with %s.')
DarkRP.addPhrase('en', 'votekick_freshspawncooldown', 'You need to play on this server for %i seconds before being able to make a vote.')
DarkRP.addPhrase('en', 'votekick_cooldown', 'You have to wait %i seconds before being able to make a vote again.')
DarkRP.addPhrase('en', 'votekick_players', 'Cannot start vote, not enough players present (>= %i).')
DarkRP.addPhrase('en', 'votekick_fail', 'Vote to kick %s failed. Less than the %i%% of the server voted \'Yes\'.')
DarkRP.addPhrase('en', 'votekick_votestarted', '%s has started a vote to kick player %s.')
DarkRP.addPhrase('en', 'votekick_already', 'There\'s already a vote in progress.')
DarkRP.addPhrase('en', 'votekick_success', '%s has been voted off the server for %i minutes.')
DarkRP.addPhrase('en', 'votekick', '%s wants to kick %s:\n"%s"')
DarkRP.addPhrase('en', 'votekick_notfound', 'User not found!')
DarkRP.addPhrase('en', 'votekick_noreason', 'Invalid reason!')
DarkRP.addPhrase('en', 'votekick_toolong', 'Reason too long (> %i)')
DarkRP.addPhrase('en', 'votekick_tooshort', 'Reason too short (< %i)')
DarkRP.addPhrase('en', 'votekick_banmessage', 'You\'ve been voted off.\nReason: %s.\nCome back in %i minutes')
DarkRP.addPhrase('en', 'votekick_leavemessage', 'Leave the game to avoid punishment.')
DarkRP.addPhrase('en', 'votekick_yourself', 'You cannot vote kick yourself.')

-- console
DarkRP.addPhrase('en', 'votekick_log_startvote', 'Player %s (%s) started a vote to kick player %s (%s) for: %s')
DarkRP.addPhrase('en', 'votekick_log_success', 'Player %s (%s) has been voted off for %i minutes with the reason: %s')
DarkRP.addPhrase('en', 'votekick_log_fail', 'Player %s (%s)\'s vote to kick player %s (%s) has failed.')
