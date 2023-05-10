
-- constants
local TABLE_TYPE = 'table'

-- variables
local models = {}

--[[---------------------------------------------------------------------------
  Adds an array of hurt sounds for a player model
  @param {string|table} model/s
  @param {table} sounds
    - pain
    - death
]]-----------------------------------------------------------------------------
function DarkRP.addPainSounds(model, sounds)
  if type(model) == TABLE_TYPE then
    for _, mdl in pairs(model) do
        models[mdl] = sounds
    end
  else
    models[model] = sounds
  end
end

--[[---------------------------------------------------------------------------
  Gets the pain sounds for the given player model
  @param {string} model
  @return {table} sounds
]]-----------------------------------------------------------------------------
function DarkRP.getPainSounds(model)
  return models[model].pain
end

--[[---------------------------------------------------------------------------
  Gets the death sounds for the given player model
  @param {string} model
  @return {table} sounds
]]-----------------------------------------------------------------------------
function DarkRP.getDeathSounds(model)
  return models[model].death
end

--[[---------------------------------------------------------------------------
  Default sounds
]]-----------------------------------------------------------------------------

-- metro police
DarkRP.addPainSounds(
{
  'models/player/police.mdl',
  'models/player/police_fem.mdl'
},
{
  pain = { Sound('NPC_MetroPolice.Pain') },
  death = { Sound('NPC_MetroPolice.Die') }
})

-- combine soldier
DarkRP.addPainSounds(
{
  'models/player/combine_soldier.mdl',
  'models/player/combine_soldier_prisonguard.mdl',
  'models/player/combine_super_soldier.mdl'
},
{
  pain = {
    'npc/combine_soldier/pain1.wav',
    'npc/combine_soldier/pain2.wav',
    'npc/combine_soldier/pain3.wav'
  },
  death = {
    'npc/combine_soldier/die1.wav',
    'npc/combine_soldier/die2.wav',
    'npc/combine_soldier/die3.wav'
  }
})

-- male citizens
DarkRP.addPainSounds(
{
  'models/player/group01/male_01.mdl',
  'models/player/group01/male_02.mdl',
  'models/player/group01/male_03.mdl',
  'models/player/group01/male_04.mdl',
  'models/player/group01/male_05.mdl',
  'models/player/group01/male_06.mdl',
  'models/player/group01/male_07.mdl',
  'models/player/group01/male_08.mdl',
  'models/player/group01/male_09.mdl',
  'models/player/group03/male_01.mdl',
  'models/player/group03/male_02.mdl',
  'models/player/group03/male_03.mdl',
  'models/player/group03/male_04.mdl',
  'models/player/group03/male_05.mdl',
  'models/player/group03/male_06.mdl',
  'models/player/group03/male_07.mdl',
  'models/player/group03/male_08.mdl',
  'models/player/group03/male_09.mdl',
  'models/player/hostage/hostage_04.mdl',
  'models/player/hostage/hostage_02.mdl',
  'models/player/odessa.mdl',
  'models/player/breen.mdl',
  'models/player/eli.mdl',
  'models/player/gman_high.mdl',
  'models/player/kleiner.mdl'
},
{
  pain = {
    'vo/npc/male01/ow01.wav',
    'vo/npc/male01/ow02.wav',
    'vo/npc/male01/pain01.wav',
    'vo/npc/male01/pain02.wav',
    'vo/npc/male01/pain03.wav',
    'vo/npc/male01/pain04.wav',
    'vo/npc/male01/pain05.wav',
    'vo/npc/male01/pain06.wav',
    'vo/npc/male01/pain07.wav',
    'vo/npc/male01/pain08.wav',
    'vo/npc/male01/pain09.wav',
  }
})

-- female citizens
DarkRP.addPainSounds(
{
  'models/player/group01/female_01.mdl',
  'models/player/group01/female_02.mdl',
  'models/player/group01/female_03.mdl',
  'models/player/group01/female_04.mdl',
  'models/player/group01/female_05.mdl',
  'models/player/group01/female_06.mdl',
  'models/player/group03/female_01.mdl',
  'models/player/group03/female_02.mdl',
  'models/player/group03/female_03.mdl',
  'models/player/group03/female_04.mdl',
  'models/player/group03/female_05.mdl',
  'models/player/group03/female_06.mdl',
  'models/player/mossman.mdl',
  'models/player/mossman_arctic.mdl'
},
{
  pain = {
    'vo/npc/female01/ow01.wav',
    'vo/npc/female01/ow02.wav',
    'vo/npc/female01/pain01.wav',
    'vo/npc/female01/pain02.wav',
    'vo/npc/female01/pain03.wav',
    'vo/npc/female01/pain04.wav',
    'vo/npc/female01/pain05.wav',
    'vo/npc/female01/pain06.wav',
    'vo/npc/female01/pain07.wav',
    'vo/npc/female01/pain08.wav',
    'vo/npc/female01/pain09.wav',
  }
})

-- monk
DarkRP.addPainSounds('models/player/monk.mdl',
{
  pain = {
    'vo/ravenholm/monk_pain01.wav',
    'vo/ravenholm/monk_pain02.wav',
    'vo/ravenholm/monk_pain03.wav',
    'vo/ravenholm/monk_pain04.wav',
    'vo/ravenholm/monk_pain05.wav',
    'vo/ravenholm/monk_pain06.wav',
    'vo/ravenholm/monk_pain07.wav',
    'vo/ravenholm/monk_pain08.wav',
    'vo/ravenholm/monk_pain09.wav',
    'vo/ravenholm/monk_pain10.wav',
    'vo/ravenholm/monk_pain11.wav',
    'vo/ravenholm/monk_pain12.wav'
  }
})

-- alyx
DarkRP.addPainSounds('models/player/alyx.mdl',
{
  pain = {
    'vo/npc/alyx/hurt04.wav',
    'vo/npc/alyx/hurt05.wav',
    'vo/npc/alyx/hurt06.wav',
    'vo/npc/alyx/hurt08.wav'
  }
})
