--[[---------------------------------------------------------------------------
  Cook entities
]]-----------------------------------------------------------------------------

-- add entities
DarkRP.createCategory {
    name = 'Cook',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 238, 99, 99 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createEntity('Keg', {
    ent = 'keg',
    model = 'models/props/de_inferno/wine_barrel.mdl',
    price = 300,
    max = 1,
    cmd = 'buykeg',
    allowed = TEAM_COOK,
    category = 'Cook'
})

-- add drink shipments
DarkRP.createCategory {
    name = 'Drinks',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 130, 170, 100 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 101,
}

DarkRP.createShipment('Moonshine', {
    model = 'models/props_junk/glassjug01.mdl',
    entity = 'alcohol_moonshine',
    price = 530,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmodel = 'models/props/cs_militia/caseofbeer01.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 105
})

DarkRP.createShipment('Vodka', {
    model = 'models/props_junk/GlassBottle01a.mdl',
    entity = 'alcohol_vodka',
    price = 600,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmodel = 'models/props/cs_militia/caseofbeer01.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 104
})

DarkRP.createShipment('Wine', {
    model = 'models/props_junk/GlassBottle01a.mdl',
    entity = 'alcohol_wine',
    price = 500,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmodel = 'models/props/cs_militia/caseofbeer01.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 103
})

DarkRP.createShipment('Beer', {
    model = 'models/props_junk/garbage_glassbottle001a.mdl',
    entity = 'alcohol_beer',
    price = 400,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmodel = 'models/props/cs_militia/caseofbeer01.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 102
})

DarkRP.createShipment('Cider', {
    model = 'models/props_junk/GlassBottle01a.mdl',
    entity = 'alcohol_cider',
    price = 350,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmodel = 'models/props/cs_militia/caseofbeer01.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 101
})

DarkRP.createShipment('Soda', {
    model = 'models/props_junk/PopCan01a.mdl',
    entity = 'spawned_soda',
    price = 175,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Drinks',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})
