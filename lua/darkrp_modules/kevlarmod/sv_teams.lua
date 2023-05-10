--[[---------------------------------------------------------------------------
  Add kevlar on spawn for teams
]]-----------------------------------------------------------------------------

local team_kevlar = {}

--[[---------------------------------------------------------------------------
  Makes a team spawn with a kevlar type and removes it if they leave that team
  @param {number} kevlar type identifier
  @param {boolean} remove after leaving any of the said jobs
  @param {varargs} teams
]]-----------------------------------------------------------------------------
function DarkRP.addTeamKevlar( kevlar_type, remove, ... )
  local teams = { ... }
  for _, _team in pairs( teams ) do
    team_kevlar[ _team ] = { kevlar_type = kevlar_type, remove = remove }
  end
end

--[[---------------------------------------------------------------------------
  Gets the kevlar type assigned to the given team
  @param {number} team identifier
  @return {table} kevlar data
]]-----------------------------------------------------------------------------
function DarkRP.getTeamKevlar( _team )
  return team_kevlar[_team]
end

--[[---------------------------------------------------------------------------
  Whether the given team has a kevlar type
  @param {number} team identifier
  @return {boolean} has a kevlar type assigned
]]-----------------------------------------------------------------------------
function DarkRP.hasTeamKevlar( _team )
  return team_kevlar[_team] ~= nil
end

-- add team restrictions
DarkRP.DARKRP_LOADING = true

DarkRP.addTeamKevlar( KEVLAR_POLICE, true, TEAM_POLICE, TEAM_CHIEF, TEAM_UNDERCOVER )
DarkRP.addTeamKevlar( KEVLAR_CIVILIAN, true, TEAM_GUARD )

DarkRP.DARKRP_LOADING = nil
