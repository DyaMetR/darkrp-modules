--[[---------------------------------------------------------------------------
  Important messages
]]-----------------------------------------------------------------------------

-- used colours
local DEFAULT_COLOUR = Color(225, 225, 200)
local VOTEKICK_COLOUR = Color(225, 0, 0)
local DEMOTE_COLOUR1 = Color(255, 255, 0)
local DEMOTE_COLOUR2 = Color(255, 180, 60)
local VOTEMAP_COLOUR = Color(66, 190, 66)
local CR_COLOUR1 = Color(255, 0, 0)
local CR_COLOUR2 = Color(30, 30, 255)
local COOK_COLOUR = Color(238, 99, 99)
local ALCOHOL_COLOUR = Color(150, 220, 120)
local HANGOVER_COLOUR = Color(220, 130, 90)
-- local SIT_COLOUR = Color(140, 100, 255) -- sit anywhere script support
local MEDIC_COLOUR = Color(47, 79, 79)
local GUARD_COLOUR = Color(103, 141, 245)
local GUN_COLOUR = Color(255, 140, 0)
local MAYOR_COLOUR = Color(150, 20, 20)
local MOB_COLOUR = Color(30, 30, 30)
local GANG_COLOUR = Color(140, 140, 140)

-- important commands
DarkRP.addTipGroup({
  {MAYOR_COLOUR, 'F1', DEFAULT_COLOUR, ' or ', MAYOR_COLOUR, '/help', DEFAULT_COLOUR, ' brings a list of the available ', MAYOR_COLOUR, 'chat commands', DEFAULT_COLOUR, '.'},
  {VOTEKICK_COLOUR, '/votekick', DEFAULT_COLOUR, ' to start a vote to kick a ', VOTEKICK_COLOUR, 'griefer', DEFAULT_COLOLUR, '.'},
  {DEMOTE_COLOUR1, '/demote', DEFAULT_COLOUR, ' to start a vote to ', DEMOTE_COLOUR2, 'demote', DEFAULT_COLOUR, ' a player which is ', DEMOTE_COLOUR2, 'abusing', DEFAULT_COLOUR, ' their job privileges.'},
  {CR_COLOUR1, '/cr', CR_COLOUR2, ' to alert the ', CR_COLOUR1, 'police', CR_COLOUR2, ' about an emergency. It will ', CR_COLOUR1, 'send your location', CR_COLOUR2, ' immediately.'},
  -- {SIT_COLOUR, 'ALT + E', DEFAULT_COLOUR, ' on a surface to ', SIT_COLOUR, 'sit', DEFAULT_COLOUR, ' on it. To stand up press ', SIT_COLOUR, 'SPACEBAR', DEFAULT_COLOUR, ' (sitting on the ground) or ', SIT_COLOUR, 'E', DEFAULT_COLOUR, ' (sitting on a prop).'},
  {VOTEMAP_COLOUR, '/votemap', DEFAULT_COLOUR, ' to start a vote to ', VOTEMAP_COLOUR, 'change maps', DEFAULT_COLOUR, '.'}
})

-- generic tips
DarkRP.addTipGroup({
  {COOK_COLOUR, 'Hunger', DEFAULT_COLOUR, ' slowly negatively impacts stamina. Purchase ', COOK_COLOUR, 'food and/or drinks', DEFAULT_COLOUR, ' from a ', COOK_COLOUR, 'Cook', DEFAULT_COLOUR, ' or from a ', COOK_COLOUR, 'vending machine', DEFAULT_COLOUR, ' if none are present.'},
  {ALCOHOL_COLOUR, 'Alcohol', DEFAULT_COLOUR, ' grants ', ALCOHOL_COLOUR, 'damage resistance', DEFAULT_COLOUR, ', but it will also impair your senses.'},
  {HANGOVER_COLOUR, 'Hangover', DEFAULT_COLOUR, ' occurs when you ', HANGOVER_COLOUR, 'abuse alcohol', DEFAULT_COLOUR, ' and it will ', HANGOVER_COLOUR, 'dehydrate', DEFAULT_COLOUR, ' you.'},
  {MEDIC_COLOUR, 'Medics', DEFAULT_COLOUR, ' can not only restore your health back to 100%, but also cure ', ALCOHOL_COLOUR, 'alcohol intoxication', DEFAULT_COLOUR, ' and ', HANGOVER_COLOUR, 'hangover', DEFAULT_COLOUR, '.'},
  {DEMOTE_COLOUR1, '/advert', DEFAULT_COLOUR, ' to print an advert on the chat. ', DEMOTE_COLOUR1, '/billboard', DEFAULT_COLOUR, ' to create an advertisement billboard.'},
  {GUARD_COLOUR, '/requestsecurity', DEFAULT_COLOUR, ' to request a ', GUARD_COLOUR, 'Security Guard\'s services', DEFAULT_COLOUR, '.'},
  {GUN_COLOUR, 'Fire in short controlled bursts', DEFAULT_COLOUR, ' to control a weapon\'s recoil.'},
  {MOB_COLOUR, 'Loan sharks', DEFAULT_COLOUR, ' can lend you money at the cost of interest over time. However, try to pay it back ', VOTEKICK_COLOUR, 'before your interest reaches tops', DEFAULT_COLOUR, '.'}
})

-- mob boss
DarkRP.addJobReminders(TEAM_MOB, {
  {DEFAULT_COLOUR, 'As a ', MOB_COLOUR, 'loan shark', DEFAULT_COLOUR, ' you can lend money to people and generate ', MOB_COLOUR, 'interest', DEFAULT_COLOUR, '.'},
  {MOB_COLOUR, 'Disconnecting', DEFAULT_COLOUR, ' or ', MOB_COLOUR, 'changing jobs', DEFAULT_COLOUR, ' will make you forgive all debts. ', VOTEKICK_COLOUR, 'Getting killed', DEFAULT_COLOUR, ' by a ', MOB_COLOUR, 'debtor', DEFAULT_COLOUR, ' when they reach ', MOB_COLOUR, 'maximum interest', DEFAULT_COLOUR, ' will make you forgive only their debt.'},
  {DEFAULT_COLOUR, 'If a ', MOB_COLOUR, 'debtor', DEFAULT_COLOUR, ' reaches ', MOB_COLOUR, 'maximum interest', DEFAULT_COLOUR, ' and they refuse to pay, you can ', VOTEKICK_COLOUR, 'kill', DEFAULT_COLOUR, ' them and recover the ', MOB_COLOUR, 'initial investment', DEFAULT_COLOUR, '.'},
  {GANG_COLOUR, 'Gangsters', DEFAULT_COLOUR, ' can see who are your debtors and whether they reached maximum interest or not. ', GANG_COLOUR, 'Coordinate', DEFAULT_COLOUR, ' with them to effectively ', GANG_COLOUR, 'collect debts', DEFAULT_COLOUR, '.'},
  {DEFAULT_COLOUR, 'It\'s better to ', VOTEKICK_COLOUR, 'intimidate', DEFAULT_COLOUR, ' a debtor first since ', VOTEKICK_COLOUR, 'killing', DEFAULT_COLOUR, ' them will only make you recover the ', MOB_COLOUR, 'initial investment', DEFAULT_COLOUR, ' without the ', MOB_COLOUR, 'generated interest', DEFAULT_COLOUR, '.'},
  {DEFAULT_COLOUR, 'When ', VOTEKICK_COLOUR, 'killing', DEFAULT_COLOUR, ' a ', MOB_COLOUR, 'debtor', DEFAULT_COLOUR, ', try ', VOTEKICK_COLOUR, 'causing them a loss', DEFAULT_COLOUR, ', like killing them after shopping, raiding their home, etc.'}
})

-- cook tips
DarkRP.addJobReminders(TEAM_COOK, {
  {COOK_COLOUR, '/menucard', DEFAULT_COLOUR, ' to spawn a menu card listing your Stove food prices and properties.'},
  {COOK_COLOUR, '/removemenucard', DEFAULT_COLOUR, ' to remove the menu card you\'re looking at. ', COOK_COLOUR, '/removeallmenucards', DEFAULT_COLOUR, ' to remove all of them at once.'},
  {DEFAULT_COLOUR, 'Use your ', COOK_COLOUR, 'menu card', DEFAULT_COLOUR, ' to edit its title and your prices.'}
})

-- security guard
DarkRP.addJobReminders(TEAM_SECURITYGUARD, {
  {GUARD_COLOUR, 'Motion sensors', DEFAULT_COLOUR, ' will make an icon flash on your screen if someone moves nearby.'},
  {GUARD_COLOUR, '/buykevlar', DEFAULT_COLOUR, ' to purchase a kevlar vest for ' .. DarkRP.formatMoney(GAMEMODE.Config.buyKevlarPrice) .. '.'},
  {GUARD_COLOUR, 'Motion sensors', DEFAULT_COLOUR, ' can be ', GUARD_COLOUR, 'fooled', DEFAULT_COLOUR, ' by standing still, so set up cameras alongside the sensors.'},
  {GUARD_COLOUR, '/offersecurity', DEFAULT_COLOUR, ' to offer your services to a player.'}
})

-- medic
DarkRP.addJobReminders(TEAM_MEDIC, {
  {DEFAULT_COLOUR, 'Players can press ', MEDIC_COLOUR, string.upper(input.LookupBinding('use')), DEFAULT_COLOUR, ' on you to request a treatment.'},
  {MEDIC_COLOUR, '/buyhealth', DEFAULT_COLOUR, ' to restore your health for 150$.'},
  {MEDIC_COLOUR, '/setbasefee', DEFAULT_COLOUR, ' to set the minimum price for your services.'},
  {MEDIC_COLOUR, '/sethealprice', DEFAULT_COLOUR, ' to set the maximum price for your services.'},
  {MEDIC_COLOUR, '/offerheal', DEFAULT_COLOUR, ' when looking at a player to offer a treatment.'}
})

-- police
DarkRP.addJobReminders({TEAM_POLICE, TEAM_CHIEF}, {
  {DEFAULT_COLOUR, 'Your ', CR_COLOUR2, 'kevlar armour', DEFAULT_COLOUR, ' includes a helmet that reduces damage from ', CR_COLOUR2, 'headshots', DEFAULT_COLOUR, '.'},
  {DEFAULT_COLOUR, 'You will be supplied with an ', CR_COLOUR2, 'MP7A1', DEFAULT_COLOUR, ' if there are citizens wielding weapons bigger than pistols.'},
  {DEFAULT_COLOUR, 'During a ', CR_COLOUR2, 'lockdown', DEFAULT_COLOUR, ' you will be granted ', CR_COLOUR2, 'higher tier weaponry', DEFAULT_COLOUR, '.'},
  {DEFAULT_COLOUR, 'Some maps will allow you to ', CR_COLOUR2, 'open combine doors', DEFAULT_COLOUR, ' to access the ', CR_COLOUR2, 'Combine Nexus', DEFAULT_COLOUR, '.'}
})

-- mayor
DarkRP.addJobReminders(TEAM_MAYOR, {
  {MAYOR_COLOUR, 'Starting a ', MAYOR_COLOUR, 'lockdown', DEFAULT_COLOUR, ' will grant the police force ', MAYOR_COLOUR, 'higher tier weaponry', DEFAULT_COLOUR, '.'},
  {MAYOR_COLOUR, 'Dying', DEFAULT_COLOUR, ' as the ', MAYOR_COLOUR, 'Mayor', DEFAULT_COLOUR, ' will get you ', MAYOR_COLOUR, 'demoted', DEFAULT_COLOUR, '.'},
  {MAYOR_COLOUR, '/addlaw', DEFAULT_COLOUR, ' to add a law, ', MAYOR_COLOUR, '/removelaw', DEFAULT_COLOUR, ' to remove a certain law, and ', MAYOR_COLOUR, '/resetlaws', DEFAULT_COLOUR, ' to reset all custom laws.'},
  {MAYOR_COLOUR, '/placelaws', DEFAULT_COLOUR, ' to place a board with the laws you have set.'}
})
