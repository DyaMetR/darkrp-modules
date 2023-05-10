--[[---------------------------------------------------------------------------
  StatusMod support
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase('en', 'alcohol_status', 'Alcohol')
DarkRP.addPhrase('en', 'alcohol_status_desc', 'Defense against damage (up to %i%%) relative to alcohol content in blood.')
DarkRP.addPhrase('en', 'hangover_status', 'Hungover')
DarkRP.addPhrase('en', 'hangover_status_desc', 'Health is decreased based on dehydration caused by the alcohol excess.')

-- add custom statuses
DarkRP.addClientStatus('alcohol', DarkRP.getPhrase('alcohol_status'), DarkRP.getPhrase('alcohol_status_desc', 35 ), Material('icon16/drink.png'), function() return LocalPlayer():getDarkRPVar('alcohol') > 0 end)
DarkRP.addClientStatus('hangover', DarkRP.getPhrase('hangover_status'), DarkRP.getPhrase('hangover_status_desc'), Material('icon16/drink_empty.png'), function() return LocalPlayer():getDarkRPVar('hangover') > GAMEMODE.Config.alcoholOverdose end)
