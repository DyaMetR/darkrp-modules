--[[---------------------------------------------------------------------------
  StatusMod support
]]-----------------------------------------------------------------------------

--[[---------------------------------------------------------------------------
  Initialize status data
]]-----------------------------------------------------------------------------
hook.Add( 'PlayerInitialSpawn', 'hungermodplus_statusmod_spawn', function(_player)
  if not DarkRP.isStatusModInstalled then return end
  _player.HungerReduction = {
    instances = {},
    total = 1
  }
end)

--[[---------------------------------------------------------------------------
  Hunger reduction
]]-----------------------------------------------------------------------------
hook.Add( 'playerHunger', 'hungermodplus_statusmod_reduction', function(_player, energy, speed)
  if not DarkRP.isStatusModInstalled then return end
  return speed * _player.HungerReduction.total
end)

DarkRP.DARKRP_LOADING = true

--[[---------------------------------------------------------------------------
  Add new status type
]]-----------------------------------------------------------------------------

-- add effect phrases
DarkRP.addPhrase('en', 'hungerrate', 'Hunger rate reduction')

-- timer
local TIMER = 'statusmod_%i_%s'

-- add hungerrate effect
DarkRP.addStatusEffect( 'hungerrate', {
  name = DarkRP.getPhrase( 'hungerrate' ),
  unstackable = true,

  on_add = function(_player, instance, reduction, duration)
    reduction = 1 - (reduction * .01)
    local _timer = string.format(TIMER, _player:EntIndex(), instance)

    if not timer.Exists(_timer) then
      if reduction > _player.HungerReduction.total then
        _player.HungerReduction.total = reduction
      end
      _player.HungerReduction.instances[instance] = reduction
    end

    timer.Create(_timer, duration, 1, function()
      _player:removeStatusEffect(instance)
    end)
  end,

  on_expire = function(_player, instance)
    if _player.HungerReduction.instances[instance] >= _player.HungerReduction.total then
      local total = 0
      for _, reduction in pairs(_player.HungerReduction.instances) do
        if reduction < total then continue end
        total = reduction
      end
      _player.HungerReduction.total = total
    end
    _player.HungerReduction.instances[instance] = nil
    timer.Remove(string.format(TIMER, _player:EntIndex(), instance))
  end
})

--[[---------------------------------------------------------------------------
  Food and statuses setup
]]-----------------------------------------------------------------------------
-- add phrases
DarkRP.addPhrase( 'en', 'sugar_status', 'Sugar' )
DarkRP.addPhrase( 'en', 'sugar_status_desc', 'Offers a 5%% (up to 15%%) overheal and a brief 10%% boost on stamina and speed.' )
DarkRP.addPhrase( 'en', 'hunger1_status', 'Hunger reduction I' )
DarkRP.addPhrase( 'en', 'hunger1_status_desc', 'Reduces hunger rate by 30%%.' )
DarkRP.addPhrase( 'en', 'hunger2_status', 'Hunger reduction II' )
DarkRP.addPhrase( 'en', 'hunger2_status_desc', 'Reduces hunger rate by 40%%.' )
DarkRP.addPhrase( 'en', 'hunger3_status', 'Hunger reduction III' )
DarkRP.addPhrase( 'en', 'hunger3_status_desc', 'Reduces hunger rate by 50%%.' )
DarkRP.addPhrase( 'en', 'hunger4_status', 'Hunger reduction IV' )
DarkRP.addPhrase( 'en', 'hunger4_status_desc', 'Reduces hunger rate by 75%%.' )
DarkRP.addPhrase( 'en', 'caffeine_status', 'Caffeine' )
DarkRP.addPhrase( 'en', 'caffeine_status_desc', 'Increases stamina by 50%% and speed by 15%%.' )
DarkRP.addPhrase( 'en', 'theine_status', 'Theine' )
DarkRP.addPhrase( 'en', 'theine_status_desc', 'Increases stamina by 25%%.' )

DarkRP.addPhrase( 'en', 'foodst_hunger', 'Reduces hunger rate by %i%% for %i seconds. ' )
DarkRP.addPhrase( 'en', 'foodst_stamina', 'Increases stamina by %i%% for %i seconds. ' )
DarkRP.addPhrase( 'en', 'foodst_regen', 'Regenerates %i%% of health. ' )
DarkRP.addPhrase( 'en', 'foodst_overheal', 'Adds %i%% of overheal with a maximum of %i. ' )
DarkRP.addPhrase( 'en', 'foodst_speed', 'Increases speed by %i%% for %i seconds. ' )

-- status description
local EFFECT_DESC = {
  ['hungerrate'] = 'foodst_hunger',
  ['stamina'] = 'foodst_stamina',
  ['regeneration'] = 'foodst_regen',
  ['overheal'] = 'foodst_overheal',
  ['speed'] = 'foodst_speed'
}

-- price functions
local EFFECT_PRICES = {
  ['hungerrate'] = function(reduction, duration) return ( ( duration / 10 ) * ( reduction / 100 ) ) * 1.15 end,
  ['stamina'] = function(reduction, duration) return ( ( duration / 12 ) * ( reduction / 125 ) ) * 1.18 end, -- 1.25
  ['speed'] = function(increase, duration) return ( ( duration / 10 ) * ( increase / 110 ) ) * 1.2 end, -- 1.25
  ['regeneration'] = function(health, rate) return health * 1.5 end,
  ['overheal'] = function(health, rate) return (health * 1.5) / (rate * .5) end
}

--[[---------------------------------------------------------------------------
  New statuses
]]-----------------------------------------------------------------------------

DarkRP.addStatus('sugar1', {
  name = DarkRP.getPhrase('sugar_status'),
  desc = DarkRP.getPhrase('sugar_status_desc'),
  icon = Material('icon16/lightning.png'),
  effects = {
    ['overheal'] = { 10, 5, 15 },
    ['stamina'] = { 110, 120 },
    ['speed'] = { 10, 120 }
  }
} )

DarkRP.addStatus( 'hunger1', {
  name = DarkRP.getPhrase('hunger1_status'),
  desc = DarkRP.getPhrase('hunger1_status_desc'),
  icon = Material('icon16/cake.png'),
  effects = {
    ['hungerrate'] = { 30, 300 }
  }
} )

DarkRP.addStatus('hunger2', {
  name = DarkRP.getPhrase('hunger2_status'),
  desc = DarkRP.getPhrase('hunger2_status_desc'),
  icon = Material('icon16/cake.png'),
  effects = {
    ['hungerrate'] = { 40, 420 }
  }
} )

DarkRP.addStatus('hunger3', {
  name = DarkRP.getPhrase('hunger3_status'),
  desc = DarkRP.getPhrase('hunger3_status_desc'),
  icon = Material('icon16/cake.png'),
  effects = {
    ['hungerrate'] = { 50, 600 }
  }
} )

DarkRP.addStatus( 'hunger4', {
  name = DarkRP.getPhrase( 'hunger4_status' ),
  desc = DarkRP.getPhrase( 'hunger4_status_desc' ),
  icon = Material('icon16/cake.png'),
  effects = {
    ['hungerrate'] = { 75, 600 }
  }
} )

DarkRP.addStatus( 'caffeine', {
  name = DarkRP.getPhrase( 'caffeine_status' ),
  desc = DarkRP.getPhrase( 'caffeine_status_desc' ),
  icon = Material('icon16/cup_add.png'),
  effects = {
    ['stamina'] = { 150, 600 },
    ['speed'] = { 15, 600 }
  }
} )

DarkRP.addStatus('theine', {
  name = DarkRP.getPhrase('theine_status'),
  desc = DarkRP.getPhrase('theine_status_desc'),
  icon = Material('icon16/cup.png'),
  effects = {
    ['stamina'] = { 125, 600 }
  }
} )

if CLIENT then
  -- add phrases
  DarkRP.addPhrase('en', 'wellfed_status', 'Well fed')
  DarkRP.addPhrase('en', 'wellfed_status_desc', 'Peak stamina performance and health regeneration up to 30%%.')

  -- add custom status
  DarkRP.addClientStatus('wellfed', DarkRP.getPhrase('wellfed_status'), DarkRP.getPhrase('wellfed_status_desc'), Material('icon16/heart.png'), function() return LocalPlayer():getDarkRPVar('Energy') >= GAMEMODE.Config.regenThreshold end)
end

--[[---------------------------------------------------------------------------
  Adds a stove food supporting StatusMod; it automatically calculates price
  @param {string} print name
  @param {string} model
  @param {number} energy it replenishes
  @param {table} effects/statuses to apply
    effects -- single effects to apply
      { [EFFECT_ID] = { args }, ... }
    statuses -- statuses to apply
    { STATUS_ID1, STATUS_ID2, ... }
]]-----------------------------------------------------------------------------
function DarkRP.addStatusFood(name, model, energy, effects)
  local price = 0
  local desc = ''
  local statuses = {}

  -- check status effects
  if effects.statuses then
    for k, i in pairs(effects.statuses) do
      local effects = DarkRP.getStatus(i).effects
      for effect, args in pairs(effects) do
        statuses[effect] = args
        if EFFECT_PRICES[effect] then price = price + EFFECT_PRICES[effect](unpack(args)) end
      end
    end
  end

  -- check standalone effects
  if effects.effects then
    for effect, args in pairs(effects.effects) do
      statuses[effect] = args
      if EFFECT_PRICES[effect] then price = price + EFFECT_PRICES[effect](unpack(args)) end
    end
  end

  -- describe statuses effects
  for effect, args in pairs(statuses) do
    local _args = args
    if effect == 'stamina' then
      _args = table.Copy(args)
      _args[1] = _args[1] - 100
    end
    desc = desc .. DarkRP.getPhrase(EFFECT_DESC[effect], unpack(_args))
  end

  -- add food
  local food = DarkRP.addFood(name, model, energy, desc, function(self, _player)
    local instance = '%i_%s'

    -- check status effects
    if effects.statuses then
      for _, i in pairs(effects.statuses) do
        _player:addStatus(i, string.format(instance, self:GetfoodItem(), i))
      end
    end

    -- check standalone effects
    if effects.effects then
      for effect, args in pairs(effects.effects) do
        _player:addStatusEffect(effect, string.format(instance, self:GetfoodItem(), effect), nil, unpack(args))
      end
    end
  end)

  -- update price
  DarkRP.getFood(food).price = math.ceil((DarkRP.getFood(food).price + price) / 5) * 5
end

--[[---------------------------------------------------------------------------
  Food types
]]-----------------------------------------------------------------------------

-- add food names
DarkRP.addPhrase('en', 'pasta', 'Pasta')
DarkRP.addPhrase('en', 'tea', 'Tea')
DarkRP.addPhrase('en', 'coffee', 'Coffee')
DarkRP.addPhrase('en', 'hotdog', 'Hot dog')
DarkRP.addPhrase('en', 'salad', 'Salad')
DarkRP.addPhrase('en', 'casserole', 'Casserole')
DarkRP.addPhrase('en', 'steak', 'Steak')
DarkRP.addPhrase('en', 'burger', 'Burger')
DarkRP.addPhrase('en', 'noddles', 'Noddles')
DarkRP.addPhrase('en', 'doughnut', 'Doughnut')

-- add foods
DarkRP.addStatusFood( DarkRP.getPhrase('tea'), 'models/props_junk/garbage_coffeemug001a.mdl', 15, { statuses = { 'theine' } })
DarkRP.addStatusFood( DarkRP.getPhrase('coffee'), 'models/props_junk/garbage_coffeemug001a.mdl', 30, { statuses = { 'caffeine' } })
DarkRP.addStatusFood( DarkRP.getPhrase('hotdog'), 'models/food/hotdog.mdl', 50, { effects = { ['regeneration'] = { 10, 1 } } } )
DarkRP.addStatusFood( DarkRP.getPhrase('pasta'), 'models/props_interiors/pot02a.mdl', 75, { statuses = { 'hunger1' } } )
DarkRP.addStatusFood( DarkRP.getPhrase('casserole'), 'models/props_c17/metalPot001a.mdl', 100, { statuses = { 'hunger4' } })
DarkRP.addStatusFood( DarkRP.getPhrase('salad'), 'models/props_c17/metalPot002a.mdl', 35, { effects = { ['regeneration'] = { 15, 3 } } })
DarkRP.addStatusFood( DarkRP.getPhrase('steak'), 'models/props_c17/metalPot002a.mdl', 75, { effects = { ['regeneration'] = { 20, 3 } } })
DarkRP.addStatusFood( DarkRP.getPhrase('burger'), 'models/food/burger.mdl', 85, { statuses = { 'hunger2' }, effects = { ['regeneration'] = { 10, 3 } } })
DarkRP.addStatusFood( DarkRP.getPhrase('noddles'), 'models/props_junk/garbage_takeoutcarton001a.mdl', 100, { statuses = { 'hunger3' }, effects = { ['regeneration'] = { 10, 3 } } })
DarkRP.addStatusFood( DarkRP.getPhrase('doughnut'), 'models/noesis/donut.mdl', 40, { statuses = { 'hunger1', 'sugar1' } })

DarkRP.DARKRP_LOADING = nil
