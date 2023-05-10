
-- add phrases
DarkRP.addPhrase('en', 'scientist_only', 'Scientists only')
DarkRP.addPhrase('en', 'scientist_destroyed', 'Your %s has been destroyed!')
DarkRP.addPhrase('en', 'drug_overdose', 'You overdosed on %s.')
DarkRP.addPhrase('en', 'sclab_hasingredients', 'Press \'%s\' to retreive ingredients')
DarkRP.addPhrase('en', 'drug_ingredients', 'drug ingredients')
DarkRP.addPhrase('en', 'sc_terminal_tab_buy', 'Buy')
DarkRP.addPhrase('en', 'sc_terminal_tab_buy_desc', 'Drug ingredients market')
DarkRP.addPhrase('en', 'sc_terminal_tab_recipes', 'Recipes')
DarkRP.addPhrase('en', 'sc_terminal_tab_recipes_desc', 'How to synthetize drugs')

-- drugs and their recipes
local names = {}
local recipes = {}
local ingredients = {}

--[[---------------------------------------------------------------------------
  Adds a laboratory localization
  @param {string} laboratory entity
  @param {string} name
]]-----------------------------------------------------------------------------
function DarkRP.addLabName(labEnt, name)
  names[labEnt] = name
end

--[[---------------------------------------------------------------------------
  Gets a laboratory localization
  @param {string} laboratory entity
  @return {string} name
]]-----------------------------------------------------------------------------
function DarkRP.getLabName(labEnt)
  return names[labEnt]
end

--[[---------------------------------------------------------------------------
  Adds a drug recipe
  @param {string} drug entity
  @param {string} drug name
  @param {string} laboratory entity
  @param {table} ingredients
  @param {string} model
]]-----------------------------------------------------------------------------
function DarkRP.addDrugRecipe(drugEnt, drugName, labEnt, ingredients, model)
  if not recipes[labEnt] then
    recipes[labEnt] = {}
  end
  recipes[labEnt][drugEnt] = {ingredients = ingredients, name = drugName, model = model or 'models/props_lab/jar01a.mdl'}
end

--[[---------------------------------------------------------------------------
  Gets a drug recipe
  @param {string} drug entity
  @param {string} laboratory entity
  @return {table} ingredients
]]-----------------------------------------------------------------------------
function DarkRP.getDrugRecipe(labEnt, drugEnt)
  return recipes[labEnt][drugEnt].ingredients
end

--[[---------------------------------------------------------------------------
  Gets a lab's recipes
  @param {string} drug entity
  @return {table} recipes
]]-----------------------------------------------------------------------------
function DarkRP.getDrugLabRecipes(labEnt)
  return recipes[labEnt]
end

--[[---------------------------------------------------------------------------
  Gets all drug entities with their recipes
  @return {table} recipes
]]-----------------------------------------------------------------------------
function DarkRP.getDrugRecipes()
  return recipes
end

--[[---------------------------------------------------------------------------
  Adds an ingredient for Scientists to buy
  @param {string} ingredient class
  @param {string} print name
  @param {number} price
  @param {string} model
]]-----------------------------------------------------------------------------
function DarkRP.addIngredient(class, name, price, model)
  ingredients[class] = {name = name, price = price, model = model or 'models/props_junk/garbage_bag001a.mdl'}
end

--[[---------------------------------------------------------------------------
  Gets an ingredient's info
  @param {string} ingredient
  @return {table} data
]]-----------------------------------------------------------------------------
function DarkRP.getIngredient(ingredient)
  return ingredients[ingredient]
end

--[[---------------------------------------------------------------------------
  Gets all of the available ingredients
  @return {table} ingredients
]]-----------------------------------------------------------------------------
function DarkRP.getIngredients()
  return ingredients
end

--[[---------------------------------------------------------------------------
  Default ingredients and recipes
]]-----------------------------------------------------------------------------
DarkRP.addIngredient('meth_chems', 'Corrosive chemicals', 40, 'models/props_junk/garbage_plasticbottle001a.mdl')
DarkRP.addIngredient('ephedrine', 'Ephedra', 100)
DarkRP.addIngredient('opium', 'Opium', 150)
DarkRP.addIngredient('cocaleaf', 'Coca leaves', 165)
DarkRP.addIngredient('ergot', 'Ergot', 115)
DarkRP.addLabName('sc_diluent', 'Chemical diluent')
DarkRP.addLabName('sc_methlab', 'Meth lab')
DarkRP.addLabName('sc_acetylator', 'Acetylator')
DarkRP.addDrugRecipe('drug_meth', 'Crystal meth', 'sc_methlab', {'meth_chems', 'ephedrine'})
DarkRP.addDrugRecipe('drug_heroin', 'Heroin', 'sc_acetylator', {'opium'}, 'models/props_junk/cardboard_box004a.mdl')
DarkRP.addDrugRecipe('drug_cocaine', 'Cocaine', 'sc_diluent', {'cocaleaf'}, 'models/props_junk/garbage_bag001a.mdl')
DarkRP.addDrugRecipe('drug_lsd', 'LSD', 'sc_diluent', {'ergot'}, 'models/props_lab/box01a.mdl')
