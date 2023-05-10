--[[---------------------------------------------------------------------------
  Blocked entities
]]-----------------------------------------------------------------------------

if SERVER then
  local blockTypes = {'Physgun1', 'Spawning1', 'Toolgun1'}

  FPP.AddDefaultBlocked(blockTypes, 'entity_shipment')
  FPP.AddDefaultBlocked(blockTypes, 'mob_printer')
  FPP.AddDefaultBlocked(blockTypes, 'home_printer')
  FPP.AddDefaultBlocked(blockTypes, 'modern_printer')
  FPP.AddDefaultBlocked(blockTypes, 'science_printer')
  FPP.AddDefaultBlocked(blockTypes, 'counterfeit_printer')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_357')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_ar2')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_buckshot')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_crossbow')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_pistol')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_smg1')
  FPP.AddDefaultBlocked(blockTypes, 'ammo_sniper')
end

--[[---------------------------------------------------------------------------
  Mob Boss entities
]]-----------------------------------------------------------------------------

-- add category
DarkRP.createCategory {
    name = 'Mob manufactury',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 25, 25, 25 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

-- add entities
DarkRP.createEntity('Mob money printer', {
    ent = 'mob_printer',
    model = 'models/props_c17/consolebox03a.mdl',
    price = 2000,
    max = 2,
    cmd = 'buymobmoneyprinter',
    allowed = TEAM_MOB,
    category = 'Mob manufactury'
})


-- add drugs category
DarkRP.createCategory {
    name = 'Drugs',
    categorises = 'entities',
    startExpanded = true,
    color = Color( 140, 120, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 102,
}

DarkRP.createEntity('Weed pot', {
    ent = 'pot_weed',
    model = 'models/props_junk/terracotta01.mdl',
    price = 350,
    max = 2,
    cmd = 'buyweedpot',
    category = 'Drugs',
    allowed = TEAM_MOB
})

--[[DarkRP.createEntity('Mushroom pot', {
    ent = 'pot_shroom',
    model = 'models/props_junk/terracotta01.mdl',
    price = 250,
    max = 2,
    cmd = 'buyshroompot',
    category = 'Drugs',
    allowed = TEAM_MOB
})]]

--[[---------------------------------------------------------------------------
  Money printers
]]-----------------------------------------------------------------------------

-- home made printer
DarkRP.createEntity('Home-made money printer', {
    ent = 'home_printer',
    model = 'models/props_lab/harddrive01.mdl',
    price = 500,
    max = 2,
    cmd = 'buyhomemadeprinter',
    sortOrder = 98,
    category = 'Other'
})

-- regular money printer
DarkRP.createEntity('Money printer', {
    ent = 'money_printer',
    model = 'models/props_c17/consolebox01a.mdl',
    price = 1000,
    max = 2,
    cmd = 'buymoneyprinter',
    sortOrder = 99,
    category = 'Other'
})

-- modern money printer
DarkRP.createEntity('Modern money printer', {
    ent = 'modern_printer',
    model = 'models/props_lab/reciever01b.mdl',
    price = 2500,
    max = 1,
    cmd = 'buymodernprinter',
    sortOrder = 100,
    category = 'Other'
})

--[[---------------------------------------------------------------------------
  Ammunition shipments
]]-----------------------------------------------------------------------------

if CLIENT then

  language.Add( 'Pistol_ammo', 'Pistol Rounds' )
  language.Add( '357_ammo', 'Heavy Pistol Rounds' )
  language.Add( 'SMG1_ammo', 'Submachine Gun Rounds' )
  language.Add( 'AR2_ammo', 'Rifle Rounds' )
  language.Add( 'Buckshot_ammo', 'Shotgun Rounds' )
  language.Add( 'SniperRound_ammo', 'Sniper Rifle Rounds' )

end

-- add category
DarkRP.createCategory {
    name = 'Ammunition',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 140, 140, 100 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 101,
}

-- add shipments
DarkRP.createShipment('30 pistol rounds', {
    model = 'models/Items/BoxSRounds.mdl',
    entity = 'ammo_pistol',
    price = 400,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 100
})

DarkRP.createShipment('12 heavy pistol rounds', {
    model = 'models/Items/357ammo.mdl',
    entity = 'ammo_357',
    price = 200,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 101
})

DarkRP.createShipment('18 shotgun rounds', {
    model = 'models/Items/BoxBuckshot.mdl',
    entity = 'ammo_buckshot',
    price = 300,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 102
})

DarkRP.createShipment('50 sub-machine gun rounds', {
    model = 'models/Items/BoxMRounds.mdl',
    entity = 'ammo_smg1',
    price = 700,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 103
})

DarkRP.createShipment('60 rifle rounds', {
    model = 'models/Items/BoxMRounds.mdl',
    entity = 'ammo_ar2',
    price = 900,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 104
})

DarkRP.createShipment('20 sniper rounds', {
    model = 'models/props_junk/cardboard_box004a.mdl',
    entity = 'ammo_sniper',
    price = 500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Ammunition',
    shipmentClass = 'entity_shipment',
    sortOrder = 105
})

--[[---------------------------------------------------------------------------
  Pistol shipments
]]-----------------------------------------------------------------------------

-- add category
DarkRP.createCategory {
    name = 'Pistols',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 0, 140, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 102,
}

-- add shipments
DarkRP.createShipment('Glock 19', {
    model = 'models/weapons/w_pist_glock18.mdl',
    entity = 'igfl_glock19',
    price = 1500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 101
})

DarkRP.createShipment('Glock 17', {
    model = 'models/weapons/w_pist_glock18.mdl',
    entity = 'igfl_glock17',
    price = 1600,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 102
})

DarkRP.createShipment('P228', {
    model = 'models/weapons/w_pist_p228.mdl',
    entity = 'igfl_p228',
    price = 1700,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 103
})

DarkRP.createShipment('USP Match', {
    model = 'models/weapons/w_pistol.mdl',
    entity = 'igfl_uspmatch',
    price = 1800,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 104
})

DarkRP.createShipment('Glock 18', {
    model = 'models/weapons/w_pist_glock18.mdl',
    entity = 'igfl_glock18',
    price = 1900,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 105
})

DarkRP.createShipment('USP Tactical', {
    model = 'models/weapons/w_pist_usp.mdl',
    entity = 'igfl_usp',
    price = 2000,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 106
})

DarkRP.createShipment('Five-Seven', {
    model = 'models/weapons/w_pist_fiveseven.mdl',
    entity = 'igfl_fiveseven',
    price = 2200,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 107
})

DarkRP.createShipment('.357 Magnum', {
    model = 'models/weapons/w_357.mdl',
    entity = 'igfl_357',
    price = 2350,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 108
})

DarkRP.createShipment('Desert Eagle', {
    model = 'models/weapons/w_pist_deagle.mdl',
    entity = 'igfl_deagle',
    price = 2500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Pistols',
    sortOrder = 109
})

--[[---------------------------------------------------------------------------
  SMG shipments
]]-----------------------------------------------------------------------------

-- add category
DarkRP.createCategory {
    name = 'Submachine-guns',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 60, 140, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 103,
}

-- add shipments
DarkRP.createShipment('MAC-10', {
    model = 'models/weapons/w_smg_mac10.mdl',
    entity = 'igfl_mac10',
    price = 3500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 101
})

DarkRP.createShipment('TMP', {
    model = 'models/weapons/w_smg_tmp.mdl',
    entity = 'igfl_tmp',
    price = 3650,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 102
})

DarkRP.createShipment('MP5A5', {
    model = 'models/weapons/w_smg_mp5.mdl',
    entity = 'igfl_mp5',
    price = 3800,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 103
})

DarkRP.createShipment('UMP-45', {
    model = 'models/weapons/w_smg_ump45.mdl',
    entity = 'igfl_ump45',
    price = 3950,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 104
})

DarkRP.createShipment('MP7A1', {
    model = 'models/weapons/w_smg1.mdl',
    entity = 'igfl_mp7',
    price = 4200,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 105
})

DarkRP.createShipment('P90', {
    model = 'models/weapons/w_smg_p90.mdl',
    entity = 'igfl_p90',
    price = 4400,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Submachine-guns',
    sortOrder = 106
})

--[[---------------------------------------------------------------------------
  Shotgun shipments
]]-----------------------------------------------------------------------------

DarkRP.createCategory {
    name = 'Shotguns',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 90, 140, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 104,
}

DarkRP.createShipment('M3 Super 90', {
    model = 'models/weapons/w_shot_m3super90.mdl',
    entity = 'igfl_m3super90',
    price = 3750,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Shotguns',
    sortOrder = 101
})

DarkRP.createShipment('M1014', {
    model = 'models/weapons/w_shot_xm1014.mdl',
    entity = 'igfl_xm1014',
    price = 3900,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Shotguns',
    sortOrder = 102
})

--[[---------------------------------------------------------------------------
  Rifle shipments
]]-----------------------------------------------------------------------------

-- add category
DarkRP.createCategory {
    name = 'Rifles',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 120, 140, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 105,
}

--add shipments
DarkRP.createShipment('FAMAS F1', {
    model = 'models/weapons/w_rif_famas.mdl',
    entity = 'igfl_famas',
    price = 5000,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 101
})

DarkRP.createShipment('Galil', {
    model = 'models/weapons/w_rif_galil.mdl',
    entity = 'igfl_galil',
    price = 5150,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 102
})

DarkRP.createShipment('M4A1', {
    model = 'models/weapons/w_rif_m4a1.mdl',
    entity = 'igfl_m4a1',
    price = 5350,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 103
})

DarkRP.createShipment('AK-47', {
    model = 'models/weapons/w_rif_ak47.mdl',
    entity = 'igfl_ak47',
    price = 5500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 104
})

DarkRP.createShipment('SG 552', {
    model = 'models/weapons/w_rif_sg552.mdl',
    entity = 'igfl_sg552',
    price = 5700,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 105
})

DarkRP.createShipment('AUG A1', {
    model = 'models/weapons/w_rif_aug.mdl',
    entity = 'igfl_aug',
    price = 5850,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Rifles',
    sortOrder = 106
})

--[[---------------------------------------------------------------------------
  Sniper shipments
]]-----------------------------------------------------------------------------

DarkRP.createCategory {
    name = 'Sniper rifles',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 180, 120, 0 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 106,
}

DarkRP.createShipment('Scout', {
    model = 'models/weapons/w_snip_scout.mdl',
    entity = 'igfl_scout',
    price = 6000,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Sniper rifles',
    sortOrder = 101
})

DarkRP.createShipment('L96A1', {
    model = 'models/weapons/w_snip_awp.mdl',
    entity = 'igfl_awp',
    price = 6350,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Sniper rifles',
    sortOrder = 102
})

DarkRP.createShipment('G3SG/1', {
    model = 'models/weapons/w_snip_g3sg1.mdl',
    entity = 'igfl_g3sg1',
    price = 6500,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Sniper rifles',
    sortOrder = 103
})

DarkRP.createShipment('SG 550', {
    model = 'models/weapons/w_snip_sg550.mdl',
    entity = 'igfl_sg550',
    price = 6750,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Sniper rifles',
    sortOrder = 104
})

--[[---------------------------------------------------------------------------
  Melee shipments
]]-----------------------------------------------------------------------------

DarkRP.createCategory {
    name = 'Melee',
    categorises = 'shipments',
    startExpanded = true,
    color = Color( 140, 60, 60 ),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

DarkRP.createShipment('Crowbar', {
    model = 'models/weapons/w_crowbar.mdl',
    entity = 'igfl_crowbar',
    price = 1250,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Melee',
    sortOrder = 101
})

DarkRP.createShipment('Nightstick', {
    model = 'models/weapons/w_stunbaton.mdl',
    entity = 'igfl_nightstick',
    price = 1400,
    amount = 10,
    allowed = TEAM_GUN,
    category = 'Melee',
    sortOrder = 102
})
