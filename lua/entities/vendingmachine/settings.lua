--[[---------------------------------------------------------------------------
  Vending machines settings
]]-----------------------------------------------------------------------------

-- vendingPrice - How much is a vending machine drink
GAMEMODE.Config.vendingPrice            = 30

-- vendingEnergy - How much energy does a drink from a vending machine restore
GAMEMODE.Config.vendingEnergy           = 25

-- vendingCooldown - How often can people buy drinks from the same machine
GAMEMODE.Config.vendingCooldown         = 120

-- replaceVendingMachines - Whether fake vending machines should be replaced
GAMEMODE.Config.replaceVendingMachines  = true

-- vendingReplace - Which props get replaced by a real vending machine
GAMEMODE.Config.vendingReplace = {
  ['models/props_interiors/vendingmachinesoda01a.mdl'] = true
}

-- Black list it from pocket
GAMEMODE.Config.PocketBlacklist['vendingmachine'] = true
