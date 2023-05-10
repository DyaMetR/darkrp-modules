DarkRP.isHungerModPlusInstalled = true -- module installation flag

local stoveFoods = {} -- registered food types

--[[---------------------------------------------------------------------------
  Adds a food type spawnable by the stove
  @param {string} name
  @param {string} model
  @param {number} energy
  @param {string|nil} additional information alongside energy percentage
  @param {function|nil} function called on eat (eater, food identifier)
  @return {number} table position it was inserted
]]-----------------------------------------------------------------------------
function DarkRP.addFood(name, model, energy, info, onEat)
  local food = { -- create food structure
    name = name,
    model = model,
    energy = energy,
    price = energy * GAMEMODE.Config.foodWorth, -- price according to energy worth
    info = info
  }

  if SERVER then -- only add function serverside
    food.onEat = onEat
  end

  return table.insert(stoveFoods, food)
end

--[[---------------------------------------------------------------------------
  Returns a stove food's information
  @param {number} food identifier
  @return {table} food data
]]-----------------------------------------------------------------------------
function DarkRP.getFood(food)
  return stoveFoods[food]
end

--[[---------------------------------------------------------------------------
  Returns all available stove foods
  @return {table} stove foods available
]]-----------------------------------------------------------------------------
function DarkRP.getFoods()
  return stoveFoods
end

-- stove phrases
if CLIENT then

  DarkRP.addPhrase('en', 'stove', 'Stove')
  DarkRP.addPhrase('en', 'stove_food_restore', 'Restores %d%% of energy. ')
  DarkRP.addPhrase('en', 'stove_title', '%s\'s %s')

end

if SERVER then

  DarkRP.addPhrase('en', 'stove_food', 'You cooked %s for %s.')
  DarkRP.addPhrase('en', 'stove_destroyed', 'Your stove has been destroyed!')

end

-- food names
DarkRP.addPhrase('en', 'bread', 'Bread')
DarkRP.addPhrase('en', 'juice', 'Juice')
DarkRP.addPhrase('en', 'beans', 'Canned beans')

DarkRP.DARKRP_LOADING = true

DarkRP.registerDarkRPVar('Energy', net.WriteFloat, net.ReadFloat)

-- add food
DarkRP.addFood( DarkRP.getPhrase( 'juice' ), 'models/props_junk/garbage_plasticbottle003a.mdl', 30 )
DarkRP.addFood( DarkRP.getPhrase( 'bread' ), 'models/props_junk/garbage_bag001a.mdl', 50 )
DarkRP.addFood( DarkRP.getPhrase( 'beans' ), 'models/props_junk/garbage_metalcan001a.mdl', 75 )

DarkRP.DARKRP_LOADING = nil
