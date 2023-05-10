--[[---------------------------------------------------------------------------
  Manage cooldowns
]]-----------------------------------------------------------------------------

local NET = 'DarkRP_VendingMachine'

--[[---------------------------------------------------------------------------
  Whether vending machines are enabled
  @return {boolean} enabled
]]-----------------------------------------------------------------------------
function DarkRP.vendingMachinesEnabled()
  return not GetGlobalBool(NET)
end

if SERVER then

  util.AddNetworkString(NET)

  local vendingMachines = {}
  local cooks = 0

  -- phrases
  DarkRP.addPhrase('en', 'vm_drink', 'a drink from vending machine')
  DarkRP.addPhrase('en', 'vm_afford', 'You cannot afford a drink from this vending machine.')
  DarkRP.addPhrase('en', 'vm_wait', 'this vending machine again')
  DarkRP.addPhrase('en', 'vm_cook', 'Out of order. Purchase food from a Cook.')

  --[[---------------------------------------------------------------------------
    Spawns and registers a vending machine
    @param {Vector} position
  ]]-----------------------------------------------------------------------------
  function DarkRP.spawnVendingMachine(pos, ang)
    local vM = ents.Create('vendingmachine')
    vM:SetPos(pos)
    vM:SetAngles(ang)
    vM:Spawn() -- spawn vending machine
    table.insert(vendingMachines, vM) -- register it
  end

  --[[---------------------------------------------------------------------------
    Clears a player's vending machine cooldown
    @param {Player} player
  ]]-----------------------------------------------------------------------------
  function DarkRP.clearPlayerVendingMachineCooldown(_player)
    for _, vM in pairs(vendingMachines) do
      vM.Cooldowns[_player:EntIndex()] = nil
    end
  end

  --[[---------------------------------------------------------------------------
    Applies a certain player cooldown to a vending machine
    @param {Player} player
    @param {Entity} vending machine
  ]]-----------------------------------------------------------------------------
  function DarkRP.playerUsedVendingMachine(_player, vendingMachine)
    -- apply cooldown
    vendingMachine.Cooldowns[_player:EntIndex()] = CurTime() + GAMEMODE.Config.vendingCooldown
    -- send to activator's client
    net.Start(NET)
    net.WriteFloat(vendingMachine:EntIndex())
    net.WriteFloat(vendingMachine.Cooldowns[_player:EntIndex()])
    net.Send(_player)
  end

  -- updates the global boolean to reflect cook presence
  local function updateCookPresence()
    SetGlobalBool(NET, cooks > 0)
  end

  -- clear cooldowns if disconnect
  hook.Add('PlayerDisconnected', 'vendingmachine_disconnect', function(_player)
    DarkRP.clearPlayerVendingMachineCooldown(_player) -- clear status
    -- if cook, check again cook availability
    if _player:Team() ~= TEAM_COOK then return end
    cooks = math.max(cooks - 1, 0)
    updateCookPresence()
  end)

  -- check for new cooks
  hook.Add('PlayerChangedTeam', 'vendingmachine_cooks', function(_player, oldTeam, newTeam)
    if newTeam == TEAM_COOK then
      cooks = cooks + 1
      updateCookPresence()
    else
      if oldTeam == TEAM_COOK then
        cooks = math.max(cooks - 1, 0)
        updateCookPresence()
      end
    end
  end)

end

if CLIENT then

  local vendingMachines = {}

  --[[---------------------------------------------------------------------------
    Whether the given vending machine is on cooldown
    @param {number} entity index
    @return {boolean} is on cooldown
  ]]-----------------------------------------------------------------------------
  function DarkRP.isVendingMachineOnCooldown(entIndex)
    if not vendingMachines[entIndex] then return false end
    return vendingMachines[entIndex] > CurTime()
  end

  -- receive cooldowns
  net.Receive(NET, function(len)
    local ent = net.ReadFloat()
    local time = net.ReadFloat()
    vendingMachines[ent] = time
  end)

end
