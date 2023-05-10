--[[---------------------------------------------------------------------------
  Cook job
]]-----------------------------------------------------------------------------

local Player = FindMetaTable("Player")

-- add isCook function
Player.isCook = fn.Compose{ fn.Curry( fn.GetValue, 2 )( 'cook' ), Player.getJobTable }

-- add job
TEAM_COOK = DarkRP.createJob('Cook', {
    color = Color( 238, 99, 99 ),
    model = { 'models/player/mossman.mdl', 'models/player/hostage/hostage_02.mdl' },
    description = [[As a cook, it is your responsibility to feed the other members of your city.

To start, you can buy a microwave and sell its food with:
  /buymicrowave

Then you can buy a stove to cook more refined food with:
  /buystove

Additionally, you can spawn a menu card to inform people of your prices with:
  /menucard

Set a title to your restaurant:
  /menucardtitle <title>

Remove the menu card you're looking at with:
  /removemenucard

Or remove all menu cards:
  /removeallmenucards]],
    weapons = {},
    command = 'cook',
    max = 3,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    cook = true,
    category = 'Citizens'
})

-- add entities
DarkRP.createCategory {
    name = 'Cook',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 238, 99, 99 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createEntity('Microwave', {
    ent = 'microwave',
    model = 'models/props/cs_office/microwave.mdl',
    price = 400,
    max = 1,
    cmd = 'buymicrowave',
    allowed = TEAM_COOK,
    category = 'Cook'
})

DarkRP.createEntity('Stove', {
    ent = 'stove',
    model = 'models/props_c17/furnitureStove001a.mdl',
    price = 850,
    max = 1,
    cmd = 'buystove',
    allowed = TEAM_COOK,
    category = 'Cook'
})

-- add food shipments
DarkRP.createCategory {
    name = 'Food',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 238, 99, 99 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100
}

DarkRP.createShipment('Donuts', {
    model = 'models/noesis/donut.mdl',
    entity = 'spawned_donut',
    price = 400,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Food',
    shipmentClass = 'entity_shipment',
    sortOrder = 104
})

DarkRP.createShipment('Watermelon (x5)', {
    model = 'models/props_junk/watermelon01.mdl',
    entity = 'cratefood_watermelon',
    price = 210,
    amount = 5,
    allowed = TEAM_COOK,
    category = 'Food',
    shipmodel = 'models/props_junk/wood_crate001a.mdl',
    shipmentClass = 'entity_shipment',
    sortOrder = 103
})

DarkRP.createShipment('Milk (x6)', {
    model = 'models/props_junk/garbage_milkcarton002a.mdl',
    entity = 'cratefood_milk',
    price = 180,
    amount = 6,
    allowed = TEAM_COOK,
    category = 'Food',
    shipmentClass = 'entity_shipment',
    sortOrder = 102
})

DarkRP.createShipment('Banana (x10)', {
    model = 'models/props/cs_italy/bananna.mdl',
    entity = 'cratefood_banana',
    price = 170,
    amount = 10,
    allowed = TEAM_COOK,
    category = 'Food',
    shipmentClass = 'entity_shipment',
    sortOrder = 101
})

DarkRP.createShipment('Orange (x15)', {
    model = 'models/props/cs_italy/orange.mdl',
    entity = 'cratefood_orange',
    price = 130,
    amount = 15,
    allowed = TEAM_COOK,
    category = 'Food',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})
