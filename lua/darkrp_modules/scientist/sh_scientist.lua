--[[---------------------------------------------------------------------------
  Scientist job
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

-- add isScientist function
function Player:isScientist()
  return self:getJobTable() and self:getJobTable().scientist
end

-- add job
TEAM_SCIENTIST = DarkRP.createJob('Scientist', {
    color = Color(130, 130, 130),
    model = {'models/player/magnusson.mdl'},
    description = [[As a scientist, you can use your knowledge to set up a laboratory.
Said laboratory can be used to make strong drugs.

These drugs grant temporary buffs to give players an advantage, but will leave them on a poor health condition once the effect goes away.

Drug making is a costly process, it requires expensive machinery and ingredients.

For starters, you will need a Terminal to contact the black market and buy your ingredients with:
  /buyterminal

You can buy a chemical diluent to make drugs such as LSD and Cocaine with:
  /buydiluent

You can buy an acetylator to make drugs such as Heroin with:
  /buyacetylator

At last but not least, you can buy a meth lab with:
  /buymethlab]],
    weapons = {},
    command = 'scientist',
    max = 2,
    salary = GAMEMODE.Config.normalsalary * 0.67,
    admin = 0,
    vote = false,
    hasLicense = false,
    scientist = true,
    category = 'Citizens'
})
