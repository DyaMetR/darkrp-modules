--[[---------------------------------------------------------------------------
  Add job
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

-- add isBlackMarketDealer function
Player.isBlackMarketDealer = fn.Compose{ fn.Curry( fn.GetValue, 2 )( 'blackmarketdealer' ), Player.getJobTable }

-- add phrases
DarkRP.addPhrase( 'blackmarketdealer_only', 'Black Market Dealers only.' )

-- add job
TEAM_BLACKMARKET = DarkRP.createJob('Black Market Dealer', {
    color = Color( 136, 162, 66 ),
    model = { 'models/player/eli.mdl' },
    description = [[The Black Market Dealer has access to an arrange of contraband items.

Said products are handy and/or powerful yet unreliable and illegal.

The weapons you can buy/sell are completely outlawed and cannot be used even with a gun license.

Getting caught selling your merchandise can get you arrested.]],
    weapons = {},
    command = 'blackmarketdealer',
    max = 2,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = 'Citizens',
    blackmarketdealer = true
})
