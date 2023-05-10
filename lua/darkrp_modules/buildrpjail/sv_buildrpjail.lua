
local buildMaps = {}

--[[---------------------------------------------------------------------------
  Adds a map that allows Police Chiefs and Mayors to set the jail positions
  @param {string} map
]]-----------------------------------------------------------------------------
function DarkRP.addBuildMap(map)
  buildMaps[map] = true
end

--[[---------------------------------------------------------------------------
  If the current map is considered as 'Build', allow Police Chiefs and Mayors
  to set the jail positions
]]-----------------------------------------------------------------------------
hook.Add('Initialize', 'buildrpjail', function()
  GAMEMODE.Config.chiefjailpos = buildMaps[game.GetMap()]
end)
