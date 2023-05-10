--[[---------------------------------------------------------------------------
  Static settings for items
]]-----------------------------------------------------------------------------

-- minAlcoholTime - Minimum duration (in seconds) that an alcohol drink's effects lasts
GM.Config.minAlcoholTime          = 30

-- maxAlcoholTime - Maximum duration (in seconds) that an alcohol drink's effects lasts
GM.Config.maxAlcoholTime          = 300

-- alcoholTime - Additional time (in seconds) to an alcohol drink's effects duration per alcohol unit
GM.Config.alcoholTime             = 2.5

-- alcoholOverdose - At which alcohol percentage the player get drunk/hangover
GM.Config.alcoholOverdose         = 30

-- hangoverSpeed - How fast the hangover cycle updates
GM.Config.hangoverSpeed           = 3

-- hangoverRate - How much hangover is cured per cycle
GM.Config.hangoverRate            = 1.5

-- overdosePenalty - How much health is lost per hangover cycle after having overdosed
GM.Config.overdosePenalty         = 1

-- alcoholMaxBoost - Maximum amount of health boost that alcohol can bring
GM.Config.alcoholMaxBoost         = 20

-- alcoholBoostDecay - How fast health gained by boost decays
GM.Config.alcoholBoostDecay       = 5

-- alcoholDefense - Maximum percentage of damage blocked by alcohol
GM.Config.alcoholDefense          = 40

-- kegdrinkcost - Sets the sale price of Keg drinks.
GM.Config.kegdrinkcost            = 40

-- maxdrinks - Sets the max drink bottles per Keg owner.
GM.Config.maxdrinks               = 20

-- add keg to the pocket blacklist
GM.Config.PocketBlacklist['keg']  = true
