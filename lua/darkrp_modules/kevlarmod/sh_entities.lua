--[[---------------------------------------------------------------------------
  Add kevlar buy options to the F4 menu
]]-----------------------------------------------------------------------------

-- add shipments
DarkRP.createCategory {
    name = 'Kevlar armour',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 80, 100, 255 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createShipment('Civilian grade kevlar vest', {
    model = 'models/props_c17/BriefCase001a.mdl',
    entity = 'armour_civilian',
    price = 1250,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Kevlar armour',
    shipmentClass = 'entity_shipment',
    sortOrder = 101
})

DarkRP.createShipment('Reinforced kevlar vest', {
    model = 'models/props_c17/SuitCase_Passenger_Physics.mdl',
    entity = 'armour_advanced',
    price = 2000,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Kevlar armour',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})
