--[[---------------------------------------------------------------------------
  Entities
]]-----------------------------------------------------------------------------
DarkRP.createCategory {
    name = 'Contraband',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 136, 162, 66 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createEntity('Counterfeit money printer', {
    ent = 'counterfeit_printer',
    model = 'models/props_c17/consolebox05a.mdl',
    price = 3000,
    max = 1,
    cmd = 'buycounterfeitmoneyprinter',
    category = 'Contraband',
    allowed = TEAM_BLACKMARKET
})

--[[---------------------------------------------------------------------------
  Shipments
]]-----------------------------------------------------------------------------
DarkRP.createShipment('Contraband kevlar vest', {
    model = 'models/props_c17/SuitCase001a.mdl',
    entity = 'armour_contraband',
    price = 1500,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Kevlar armour',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})

-- add utility category
DarkRP.createCategory {
    name = 'Utility',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 137, 147, 173 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 101,
}

DarkRP.createShipment('Keypad cracker', {
    model = 'models/weapons/w_c4.mdl',
    entity = 'bm_keypad_cracker',
    price = 3000,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Utility',
    sortOrder = 100
})

DarkRP.createShipment('Unarrest baton', {
    model = 'models/weapons/w_stunbaton.mdl',
    entity = 'bm_unarrest_stick',
    price = 2500,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Utility',
    sortOrder = 101
})

DarkRP.createShipment('Lock pick', {
    model = 'models/weapons/w_crowbar.mdl',
    entity = 'bm_lockpick',
    price = 1750,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Utility',
    sortOrder = 102
})

DarkRP.createShipment('5 keypad cracker batteries', {
    model = 'models/Items/battery.mdl',
    entity = 'ammo_battery',
    price = 300,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Utility',
    sortOrder = 103,
    shipmentClass = 'entity_shipment',
})

-- add weapons category
DarkRP.createCategory {
    name = 'Weapons',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 136, 162, 66 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 103,
}

-- add weapons
DarkRP.createShipment('Knife', {
    model = 'models/weapons/w_knife_t.mdl',
    entity = 'igfl_knife',
    price = 1600,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Weapons',
    sortOrder = 101
})

DarkRP.createShipment('Counterfeit Glock 18', {
    model = 'models/weapons/w_pist_glock18.mdl',
    entity = 'igfl_glock18_auto',
    price = 1700,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Weapons',
    sortOrder = 102
})

DarkRP.createShipment('SPAS-12', {
    model = 'models/weapons/w_shotgun.mdl',
    entity = 'igfl_spas12',
    price = 4250,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Weapons',
    sortOrder = 103
})

DarkRP.createShipment('Counterfeit Pulse-Rifle', {
    model = 'models/weapons/w_irifle.mdl',
    entity = 'igfl_ar2_bm',
    price = 5200,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Weapons',
    sortOrder = 104
})

DarkRP.createShipment('M249 Para', {
    model = 'models/weapons/w_mach_m249para.mdl',
    entity = 'igfl_m249',
    price = 6000,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Weapons',
    sortOrder = 105
})

-- add ammunition category (in case it doesn't exist)
DarkRP.createCategory {
    name = 'Ammunition',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 140, 140, 100 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 101,
}

DarkRP.createShipment('30 pistol rounds (x5)', {
    model = 'models/Items/BoxSRounds.mdl',
    entity = 'ammo_pistol',
    price = 300,
    amount = 5,
    allowed = TEAM_BLACKMARKET,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})

DarkRP.createShipment('18 shotgun rounds (x5)', {
    model = 'models/Items/BoxBuckshot.mdl',
    entity = 'ammo_buckshot',
    price = 225,
    amount = 5,
    allowed = TEAM_BLACKMARKET,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 101
})

DarkRP.createShipment('60 rifle rounds (x5)', {
    model = 'models/Items/BoxMRounds.mdl',
    entity = 'ammo_ar2',
    price = 675,
    amount = 5,
    allowed = TEAM_BLACKMARKET,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 102
})

--[[
DarkRP.createShipment('6 crossbow bolts', {
    model = 'models/Items/CrossbowRounds.mdl',
    entity = 'ammo_crossbow',
    price = 120,
    amount = 10,
    allowed = TEAM_BLACKMARKET,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 103
})]]
