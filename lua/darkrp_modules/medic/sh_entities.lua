
-- add category
DarkRP.createCategory {
    name = 'Medic',
    categorises = 'shipments',
    startExpanded = true,
    color = Color(47, 79, 79),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

-- add entities
DarkRP.DARKRP_LOADING = true

if DarkRP.isStatusModInstalled then

  -- phrases
  DarkRP.addPhrase('en', 'medkit_in_effect', 'You have to wait for the previous first aid kit to take full effect before using another one.')
  DarkRP.addPhrase('en', 'firstaid_status', 'First aid kit')
  DarkRP.addPhrase('en', 'firstaid_status_desc', 'Regenerates 50%% of health. Prevents any other first aid kit to be used while active.')
  DarkRP.addPhrase('en', 'painkiller_status', 'Painkiller')
  DarkRP.addPhrase('en', 'painkiller_status_desc', 'Overheals up to 50%% of health. Reduces damage by %i%%.')
  DarkRP.addPhrase('en', 'painkiller_overdose', 'You overdosed on painkillers.')

  local TIMER = 'painkiller_cooldown_%i'

  -- add painkiller status
  DarkRP.addStatus('painkiller', {
    name = DarkRP.getPhrase('painkiller_status'),
    desc = DarkRP.getPhrase('painkiller_status_desc', (1 - GAMEMODE.Config.painkillerDamage) * 100),
    icon = Material('icon16/pill.png'),
    effects = {
      ['overheal'] = { 1, 50, 50 },
      ['defense'] = { GAMEMODE.Config.painkillerDamage, 50 }
    },
    on_add = function(_player)
      if not _player.Painkillers then
        _player.Painkillers = 1
      else
        _player.Painkillers = _player.Painkillers + 1
      end

      -- kill on overdose
      if _player.Painkillers > GAMEMODE.Config.maxPainkillers then
        _player:Kill()
        DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('painkiller_overdose'))
        _player.Painkillers = nil
        return
      end

      -- cooldown
      timer.Create(string.format(TIMER, _player:EntIndex()), 50, _player.Painkillers, function()
        _player.Painkillers = _player.Painkillers - 1
      end)
    end,
    on_expire = function(_player)
      _player.Painkillers = nil
      timer.Remove(string.format(TIMER, _player:EntIndex()))
    end
  })

  -- add medkit status
  DarkRP.addStatus('firstaid', {
    name = DarkRP.getPhrase('firstaid_status'),
    desc = DarkRP.getPhrase('firstaid_status_desc'),
    icon = Material('icon16/heart_add.png'),
    effects = {
      ['regeneration'] = { 50, 0.8 }
    }
  } )

  -- add entities
  DarkRP.createShipment('First aid kit', {
      model = 'models/Items/HealthKit.mdl',
      entity = 'item_firstaid',
      price = 750,
      amount = 10,
      allowed = TEAM_MEDIC,
      category = 'Medic',
      shipmentClass = 'entity_shipment',
      sortOrder = 100
  })

  DarkRP.createShipment('Bandage', {
      model = 'models/props/cs_office/paper_towels.mdl',
      entity = 'item_bandage',
      price = 200,
      amount = 10,
      allowed = TEAM_MEDIC,
      category = 'Medic',
      shipmentClass = 'entity_shipment',
      sortOrder = 101
  })

  DarkRP.createShipment('Painkillers', {
      model = 'models/props_lab/jar01b.mdl',
      entity = 'item_painkillers',
      price = 400,
      amount = 10,
      allowed = TEAM_MEDIC,
      category = 'Medic',
      shipmentClass = 'entity_shipment',
      sortOrder = 102
  })

else

  DarkRP.createShipment('Health kit', {
      model = 'models/Items/HealthKit.mdl',
      entity = 'item_healthkit',
      price = 500,
      amount = 10,
      allowed = TEAM_MEDIC,
      category = 'Medic',
      shipmentClass = 'entity_shipment',
      sortOrder = 100
  })

  DarkRP.createShipment('Health vial', {
      model = 'models/healthvial.mdl',
      entity = 'item_healthvial',
      price = 200,
      amount = 10,
      allowed = TEAM_MEDIC,
      category = 'Medic',
      shipmentClass = 'entity_shipment',
      sortOrder = 101
  })

end

DarkRP.DARKRP_LOADING = nil
