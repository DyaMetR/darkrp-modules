
local Player = FindMetaTable('Player')

-- register DarkRPVar
DarkRP.registerDarkRPVar('securityContract', net.WriteEntity, net.ReadEntity)

--[[---------------------------------------------------------------------------
  Gets the current security contract related person
  @return {Player} contract related person
]]-----------------------------------------------------------------------------
function Player:getSecurityContractTarget()
  return self:getDarkRPVar('securityContract')
end
