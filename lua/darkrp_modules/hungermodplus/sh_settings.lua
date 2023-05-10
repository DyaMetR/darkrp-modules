--[[---------------------------------------------------------------------------
  HungerMod+ settings
]]-----------------------------------------------------------------------------

-- initialEnergy - Energy amount which players spawn with for the first time
GM.Config.initialEnergy       = 100

-- respawnEnergy - Energy amount which players respawn with
GM.Config.respawnEnergy       = 50

-- hungerSpeed - How much energy is depleted per tick
GM.Config.hungerSpeed         = 0.75

-- starveSpeed - How much health is lost per tick when starving
GM.Config.starveSpeed         = 1

-- foodWorth - How much is 1% of energy worth in money
GM.Config.foodWorth           = 0.8

-- foodDefaultProfit - Price difference between the cooking cost and the sale price
GM.Config.foodDefaultProfit   = 1.25

-- maxFoodPrice - How many times the original price can a cooked food be sold at
GM.Config.maxFoodPrice        = 2

-- regenThreshold - How much energy is required for the player to start regenerating
GM.Config.regenThreshold      = 70

-- regenMaxHealth - How much health can the energy regenerate
GM.Config.regenMaxHealth      = 30

-- minRegeneration - Minimum health regenerated per tick
GM.Config.minRegeneration     = 1

-- maxRegeneration - Maximum health regenerated per tick
GM.Config.maxRegeneration     = 3

-- regenerationCost - How much additional energy is consumed when regenerating health
GM.Config.regenerationCost    = 0.25

-- microwavefoodenergy - How much energy does microwave food replenish
GM.Config.microwavefoodenergy = 50


--[[---------------------------------------------------------------------------
DarkRP settings
]]-----------------------------------------------------------------------------

GM.Config.PocketBlacklist['stove'] = true

if SERVER then
  local blockTypes = {'Physgun1', 'Spawning1', 'Toolgun1'}

  FPP.AddDefaultBlocked(blockTypes, 'spawned_cratefood')
  FPP.AddDefaultBlocked(blockTypes, 'stove')
  FPP.AddDefaultBlocked(blockTypes, 'spawned_stovefood')
  FPP.AddDefaultBlocked(blockTypes, 'spawned_soda')
end
