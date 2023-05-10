--[[---------------------------------------------------------------------------
  Register new variable and shared functions
]]-----------------------------------------------------------------------------

-- register variables
DarkRP.DARKRP_LOADING = true

DarkRP.registerDarkRPVar('alcohol', net.WriteFloat, net.ReadFloat)
DarkRP.registerDarkRPVar('hangover', net.WriteFloat, net.ReadFloat)

DarkRP.DARKRP_LOADING = nil

-- add phrases
DarkRP.addPhrase('en', 'keg', 'Keg')
DarkRP.addPhrase('en', 'beer', 'Beer')
DarkRP.addPhrase('en', 'drinkdanger', 'Taking another drink like that is not recommended beyond this point.')
DarkRP.addPhrase('en', 'alcoholoverdose', 'You suffered an alcohol overdose.')
DarkRP.addPhrase('en', 'dehydration', 'You dehydrated.')
DarkRP.addPhrase('en', 'drunk', 'You\'re drunk.')
DarkRP.addPhrase('en', 'drunkcure', 'You have been disintoxicated.')
DarkRP.addPhrase('en', 'hangover', 'You have a hangover.')
DarkRP.addPhrase('en', 'hangoverdanger', 'You\'re severly dehydrated. Drinking is not recommended beyond this point.')
DarkRP.addPhrase('en', 'hangovercured', 'Hangover cured.')
DarkRP.addPhrase('en', 'hangovercuring', 'Hangover is curing...')
DarkRP.addPhrase('en', 'hangoverresume', 'Your hangover came back.')
