--[[---------------------------------------------------------------------------
  Security guard job
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

-- add isSecurityGuard function
function Player:isSecurityGuard()
  return self:getJobTable() and self:getJobTable().securityguard
end

-- add job
TEAM_SECURITYGUARD = DarkRP.createJob('Security Guard', {
    color = Color(103, 141, 245), -- 84, 140, 238
    model = {'models/player/odessa.mdl', 'models/player/alyx.mdl'},
    description = [[As a security guard you can be hired by other people to protect either themselves or their property.

You can be hired by either having someone press USE on you or by offering your services with:
  /securityoffer <player>

On your screen the status of your contractor and their entities will appear.

If either your contractor or any of their entities are damaged, its position will briefly appear on the screen.

You can buy motion sensors to detect anyone nearby with:
  /buymotionsensor

You can replace your current kevlar vest with:
  /buykevlar

Your initial salary will be cut unless you get hired.

If your contractor is killed by another person you'll lose their contract.

If you kill your contractor you'll get demoted.]],
    weapons = {'guard_stick', 'weaponchecker_guard'},
    command = 'securityguard',
    max = 3,
    salary = GAMEMODE.Config.normalsalary * 0.67,
    admin = 0,
    vote = false,
    hasLicense = true,
    securityguard = true,
    category = 'Citizens'
})

-- add phrases
DarkRP.addPhrase('en', 'guard_sensors_contract_only', 'You can only purchase Motion Sensors when hired!')

-- add category
DarkRP.createCategory {
    name = 'Security equipment',
    categorises = 'entities',
    startExpanded = true,
    color = Color(84, 140, 238),
    canSee = fp{ fn.Id, true },
    sortOrder = 100,
}

-- add entities
DarkRP.createEntity('Motion sensor', {
    ent = 'sg_sensor',
    model = 'models/props_lab/reciever01d.mdl',
    price = 30,
    max = 4,
    cmd = 'buymotionsensor',
    allowed = TEAM_SECURITYGUARD,
    category = 'Security equipment',
    customCheck = function(_player) return _player:getSecurityContractTarget() end,
    CustomCheckFailMsg = function(_player, tbl) return DarkRP.getPhrase('guard_sensors_contract_only') end,
})
