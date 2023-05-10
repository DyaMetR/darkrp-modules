--[[---------------------------------------------------------------------------
  Maps that can be voted
]]-----------------------------------------------------------------------------

local maps = {}

--[[---------------------------------------------------------------------------
  Adds a map to the pool
  @param {string} map
  @param {string} pretty name
]]-----------------------------------------------------------------------------
function DarkRP.addMapToVote(map, name)
  name = name or map
  maps[map] = name
end

--[[---------------------------------------------------------------------------
  Whether the given map can be voted
  @param {string} map
  @return {boolean} can be voted
]]-----------------------------------------------------------------------------
function DarkRP.hasMapToVote(map)
  return maps[map] ~= nil
end

--[[---------------------------------------------------------------------------
  Gets all of the available maps to vote
]]-----------------------------------------------------------------------------
function DarkRP.getMapsToVote()
  return maps
end

--[[---------------------------------------------------------------------------
  Server maps
]]-----------------------------------------------------------------------------
--DarkRP.addMapToVote( 'gm_flatgrass', 'Flatgrass' )
DarkRP.addMapToVote( 'gm_construct', 'Construct' )
DarkRP.addMapToVote( 'rp_downtown_v2', 'Downtown v2' )
DarkRP.addMapToVote( 'rp_construct_v1', 'Construct city' )
DarkRP.addMapToVote( 'rp_cscdesert_v2-1', 'CSC Desert' )
DarkRP.addMapToVote( 'rp_downtown_v2_fiend_v2b', 'Downtown v2 fiend (v2b)' )
DarkRP.addMapToVote( 'rp_eastcoast_v4c', 'East coast' )
DarkRP.addMapToVote( 'rp_locality', 'Locality' )
DarkRP.addMapToVote( 'rp_tb_city45_v02n', 'City 45' )
DarkRP.addMapToVote( 'rp_city19', 'City 19' )
DarkRP.addMapToVote( 'rp_bloc42_v2', 'Block 42' )
DarkRP.addMapToVote( 'rp_bangclaw', 'Bangclaw' )
DarkRP.addMapToVote( 'rp_downtown_v4c_v2', 'Downtown v4c (v2)' )
