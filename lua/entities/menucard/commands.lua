--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

DarkRP.declareChatCommand {
  command = 'menucardtitle',
  description = 'Sets a title to the menu card',
  condition = function(_player) return _player:isCook() end,
  delay = 1
}

DarkRP.declareChatCommand {
  command = 'menucard',
  description = 'Spawn a menu card listing stove food available and their price. You will need a Stove.',
  condition = function(_player) return _player:isCook() end,
  delay = 2
}

DarkRP.declareChatCommand {
  command = 'removemenucard',
  description = 'Removes the menu card you\'re looking at',
  condition = function(_player) return _player:isCook() end,
  delay = 1
}

DarkRP.declareChatCommand {
  command = 'removeallmenucards',
  description = 'Removes all spawned menu cards',
  condition = function(_player) return _player:isCook() end,
  delay = 5
}

DarkRP.declareChatCommand {
  command = 'foodprice',
  description = 'Sets a specific price to a stove cooked food type',
  condition = function(_player) return _player:isCook() end,
  delay = 1
}

DarkRP.declareChatCommand {
  command = 'resetfoodprice',
  description = 'Reset a specific stove cooked food type price',
  condition = function(_player) return _player:isCook() end,
  delay = 1
}

DarkRP.declareChatCommand {
  command = 'resetallfoodprices',
  description = 'Resets all stove cooked food types\' prices',
  condition = function(_player) return _player:isCook() end,
  delay = 3
}

--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------
if SERVER then

  -- language
  DarkRP.addPhrase('en', 'menucards', 'menu cards')
  DarkRP.addPhrase('en', 'food_type', 'food type')
  DarkRP.addPhrase('en', 'food_price_changed', 'Changed %s price to %s.')
  DarkRP.addPhrase('en', 'food_price_reset', '%s price has been reset.')
  DarkRP.addPhrase('en', 'food_prices_reset', 'All food types prices have been reset.')
  DarkRP.addPhrase('en', 'menucardtitle_set', 'Menu card title updated.')
  DarkRP.addPhrase('en', 'menucardtitle_reset', 'Menu card title reset.')
  DarkRP.addPhrase('en', 'menucardsremoved', 'All menu cards have been removed.')
  DarkRP.addPhrase('en', 'menucard_need_stove', 'You need to own a Stove to use menu cards!')

  -- set a title to the menu card
  DarkRP.defineChatCommand('menucardtitle', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    -- if no args are supplied, reset it
    if args == '' then
      _player.CookMenuCard.title = nil
      DarkRP.notify(_player, NOTIFY_UNDO, 4, DarkRP.getPhrase('menucardtitle_reset'))
    else
      _player.CookMenuCard.title = args
      DarkRP.notify(_player, NOTIFY_UNDO, 4, DarkRP.getPhrase('menucardtitle_set'))
    end

    return ''
  end)

  -- set a price to a food type
  DarkRP.defineChatCommand('foodprice', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    -- is a food name present?
    local namepos = string.find(args, " ")
    if not namepos then
        DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
        return ''
    end

    -- is a price present?
    local name = string.sub(args, 1, namepos - 1)
    local price = string.sub(args, namepos + 1)
    if price == '' or tonumber(price) == nil then
        DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
        return ''
    end

    -- ids are numeric
    name = tonumber(name)

    -- is the given food type valid?
    if not DarkRP.getFood(name) then
      DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('food_type'), ''))
      return ''
    end

    -- set new price
    local food = DarkRP.getFood(name)
    _player.CookMenuCard.prices[name] = math.Clamp(tonumber(price), food.price, food.price * GAMEMODE.Config.maxFoodPrice)
    DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('food_price_changed', food.name, DarkRP.formatMoney(_player.CookMenuCard.prices[name])))

    return ''
  end)

  -- reset a food type's price
  DarkRP.defineChatCommand('resetfoodprice', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    -- check valid args
    if args == '' then
      DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
      return ''
    end

    -- ids are numeric
    args = tonumber(args)

    -- is the given food type valid?
    if not DarkRP.getFood(args) then
      DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('food_type'), ''))
      return ''
    end

    _player.CookMenuCard.prices[args] = nil
    DarkRP.notify(_player, NOTIFY_UNDO, 4, DarkRP.getPhrase('food_price_reset', DarkRP.getFood(args).name))
    return ''
  end)

  -- reset all food types' prices
  DarkRP.defineChatCommand('resetallfoodprices', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    table.Empty(_player.CookMenuCard.prices)
    DarkRP.notify(_player, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('food_prices_reset'))
    return ''
  end)

  -- spawn a menu card
  DarkRP.defineChatCommand('menucard', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    -- check maximum
    if _player.maxMenuCards and _player.maxMenuCards >= GAMEMODE.Config.maxMenuCards then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('limit', DarkRP.getPhrase('menucards')))
      return ''
    end

    -- check whether there's a stove present
    if not _player.stoveEntity then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('menucard_need_stove'))
      return ''
    end

    -- trace player view
    local _trace = {
      start = _player:EyePos(),
      endpos = _player:EyePos() + (_player:GetAimVector() * 40),
      filter = _player
    }
    local trace = util.TraceLine(_trace)

    -- spawn card
    local card = ents.Create('menucard')
    card:SetPos(trace.HitPos)
    card:Setowning_ent(_player)
    card:Spawn()
    _player.maxMenuCards = _player.maxMenuCards and _player.maxMenuCards + 1 or 1

    return ''
  end)

  -- remove the menu card you're looking at
  DarkRP.defineChatCommand('removemenucard', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    local trace = _player:GetEyeTrace()
    if not trace.Hit or trace.Entity:GetClass() ~= 'menucard' or trace.Entity:Getowning_ent() ~= _player then return end
    trace.Entity:Remove()
  end)

  -- remove all menu cards
  DarkRP.defineChatCommand('removeallmenucards', function(_player, args)
    -- restrict command to cooks only
    if not _player:isCook() then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cooks_only'))
      return ''
    end

    _player:removeAllMenuCards()
    DarkRP.notify(_player, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('menucardsremoved'))
    return ''
  end)

end
