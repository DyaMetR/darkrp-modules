-- add lab category
DarkRP.createCategory {
    name = 'Laboratory',
    categorises = 'entities',
    startExpanded = true,
    color = Color(130, 130, 130),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

-- add entities
DarkRP.createEntity('Terminal', {
    ent = 'sc_terminal',
    model = 'models/props_lab/workspace002.mdl',
    price = 300,
    max = 1,
    cmd = 'buyterminal',
    allowed = TEAM_SCIENTIST,
    category = 'Laboratory'
})

DarkRP.createEntity('Chemical diluent', {
    ent = 'sc_diluent',
    model = 'models/props_c17/FurnitureWashingmachine001a.mdl',
    price = 200,
    max = 1,
    cmd = 'buydiluent',
    allowed = TEAM_SCIENTIST,
    category = 'Laboratory'
})

DarkRP.createEntity('Acetylator', {
    ent = 'sc_acetylator',
    model = 'models/props_lab/miniteleport.mdl',
    price = 300,
    max = 1,
    cmd = 'buyacetylator',
    allowed = TEAM_SCIENTIST,
    category = 'Laboratory'
})

DarkRP.createEntity('Meth lab', {
    ent = 'sc_methlab',
    model = 'models/props_lab/crematorcase.mdl',
    price = 500,
    max = 1,
    cmd = 'buymethlab',
    allowed = TEAM_SCIENTIST,
    category = 'Laboratory'
})

-- add printer category
DarkRP.createCategory {
    name = 'Experimental',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 76, 136, 162 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createEntity('Experimental money printer', {
    ent = 'science_printer',
    model = 'models/props_c17/TrapPropeller_Engine.mdl',
    price = 2000,
    max = 1,
    cmd = 'buyexperimentalprinter',
    category = 'Experimental',
    allowed = TEAM_SCIENTIST
})
