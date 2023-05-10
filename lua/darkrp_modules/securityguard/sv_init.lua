util.AddNetworkString('securityguard_prompt')

local contracts = {}

--[[---------------------------------------------------------------------------
  Adds an active security contract
  @param {Player} client
  @param {Player} guard
  @return {number} id
]]-----------------------------------------------------------------------------
function DarkRP.addSecurityContract(client, guard)
  local contract = {
    client = client,
    guard = guard,
    time = CurTime() + GAMEMODE.Config.guardPermanency
  }
  local i = table.insert(contracts, contract)
  client.SecurityGuard.contract = i
  guard.SecurityGuard.contract = i
  client:setSecurityContractTarget(guard)
  guard:setSecurityContractTarget(client)
  guard:setDarkRPVar('salary', GAMEMODE.Config.guardSalary)
  DarkRP.syncSecurityEntities(client)
  return i
end

--[[---------------------------------------------------------------------------
  Removes an active security contract
  @param {number} id
  @param {boolean} leave salary change alone
]]-----------------------------------------------------------------------------
function DarkRP.removeSecurityContract(i, skip_salary)
  local contract = contracts[i]
  contract.guard.SecurityGuard.contract = nil
  contract.client.SecurityGuard.contract = nil
  contract.guard:setSecurityContractTarget(nil)
  contract.client:setSecurityContractTarget(nil)
  if not skip_salary then
    contract.guard:setDarkRPVar('salary', RPExtraTeams[contract.guard:Team()].salary)
  end
  contract.guard:cleanUpSensors()
  DarkRP.clearSecurityEntities(contract.guard)
  contracts[i] = nil
end

--[[---------------------------------------------------------------------------
  Removes an active security contract
  @param {number} id
  @return {table} contract
]]-----------------------------------------------------------------------------
function DarkRP.getSecurityContract(i)
  return contracts[i]
end

-- setup variables
hook.Add('PlayerInitialSpawn', 'guard_initspawn', function(_player)
  _player:setSecurityContractTarget(nil)
  _player.SecurityGuard = {
    contract = nil,
    delay = {}
  }
end)

-- flush contract on disconnect
hook.Add('PlayerDisconnected', 'guard_disconnect', function(_player)
  -- clear traces
  for _, other in pairs(player.GetAll()) do
    other.SecurityGuard.delay[_player] = nil
  end

  -- clear questions
  DarkRP.destroyQuestionsWithEnt(_player)

  -- clear contracts
  if not _player.SecurityGuard.contract then return end
  DarkRP.removeSecurityContract(_player.SecurityGuard.contract)
end)

-- flush contract if either guard changes job or the client becomes a guard
hook.Add('PlayerChangedTeam', 'guard_changeteam', function(_player, newTeam, oldTeam)
  if (newTeam ~= TEAM_SECURITYGUARD and oldTeam ~= TEAM_SECURITYGUARD) or not _player.SecurityGuard.contract then return end
  DarkRP.removeSecurityContract(_player.SecurityGuard.contract, true)
end)

-- press use on a security guard for a prompt to pop up
hook.Add('KeyPress', 'guard_use', function(_player, key)
  if key ~= IN_USE then return end
  local trace = _player:GetEyeTrace()
  -- check if there's a valid entity on sight
  if not trace.Hit or not trace.Entity:IsPlayer() then return end
  -- check if the target is a guard (and the player isn't)
  if _player:isSecurityGuard() or not trace.Entity:isSecurityGuard() then return end
  -- check if player is already on a contract
  if _player:getSecurityContractTarget() then return end
  -- check if they're too far away
  if _player:GetPos():Distance(trace.Entity:GetPos()) > GAMEMODE.Config.minGuardDistance then return end
  -- send prompt
  net.Start('securityguard_prompt')
  net.WriteString(trace.Entity:Name())
  net.Send(_player)
end)
