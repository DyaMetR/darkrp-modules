--[[---------------------------------------------------------------------------
  Security Guard settings
]]-----------------------------------------------------------------------------

-- guardSalary - Salary applied to a Security Guard once its contracted
GM.Config.guardSalary           = 50

-- guardDelay - How much time does a client/guard wait before being able to share a contract again
GM.Config.guardDelay            = 300

-- guardPermanency - How much time does a guard have to be in a contract before changing clients
GM.Config.guardPermanency       = 300

-- guardRejectDelay - How much times does a customer/guard have to wait to request/offer again to the same person
GM.Config.guardRejectDelay      = 120

-- guardQuestionTime - How long does the question last for
GM.Config.guardQuestionTime     = 30

-- guardDemoteTime - How long is a guard demoted for killing their client
GM.Config.guardDemoteTime       = 300

-- minGuardDistance - Maximum distance to hire a Security Guard
GM.Config.minGuardDistance    = 150

-- guardHudText - Text displayed when a security guard can be hired
GM.Config.guardHudText        = 'I\'m a Security Guard.\nPress E on me to hire my services!'

-- guardHired - Text displayed when a security guard is hired
GM.Config.guardHired          = 'Hired by:\n%s'

-- guardHudTextUnable - Text displayed on a security guard when already on a contract
GM.Config.guardHudTextUnable  = 'You cannot hire another Security Guard.\nEnd your current contract to switch Security Guards.'

-- buyKevlarPrice - How much does kevlar cost
GM.Config.buyKevlarPrice        = 300

-- buyKevlarDelay - How long does it take to be able to buy kevlar again
GM.Config.buyKevlarDelay        = 420

-- add nightstick as legal weapon
GM.Config.NoLicense['guard_stick'] = true
