
local Player = FindMetaTable('Player')

-- declare variables
DarkRP.DARKRP_LOADING = true
  DarkRP.registerDarkRPVar('loan', net.WriteFloat, net.ReadFloat)
  DarkRP.registerDarkRPVar('loanshark', net.WriteEntity, net.ReadEntity)
  DarkRP.registerDarkRPVar('loantime', net.WriteFloat, net.ReadFloat)
DarkRP.DARKRP_LOADING = nil

--[[---------------------------------------------------------------------------
  Whether players from the given team can loan money
  @return {boolean} can loan money
]]-----------------------------------------------------------------------------
function DarkRP.canTeamLoanMoney(_team)
  return GAMEMODE.Config.loanJobs[_team]
end

--[[---------------------------------------------------------------------------
  Whether the given player can loan money
  @return {boolean} can loan money
]]-----------------------------------------------------------------------------
function Player:canLoanMoney()
  return DarkRP.canTeamLoanMoney(self:Team())
end

--[[---------------------------------------------------------------------------
  Calculates the current loan interest rate
  @return {number} interest rate
]]-----------------------------------------------------------------------------
function Player:getLoanInterest()
  return math.min((1 - ((self:getDarkRPVar('loantime') - CurTime()) / GAMEMODE.Config.loanTime)) * GAMEMODE.Config.maxLoanDebt, GAMEMODE.Config.maxLoanDebt)
end

--[[---------------------------------------------------------------------------
  Gets the total amount to return to the loan shark
  @return {number} debt
]]-----------------------------------------------------------------------------
function Player:getDebt()
  return self:getDarkRPVar('loan') * (1 + (math.floor(self:getLoanInterest() * 100) * .01))
end

--[[---------------------------------------------------------------------------
  Whether this player has ran out their return time of their current loan
  @param {boolean} is debtor
]]-----------------------------------------------------------------------------
function Player:isDebtor()
  local loanShark = self:getDarkRPVar('loanshark')
  return loanShark and IsValid(loanShark) and self:getDarkRPVar('loantime') < CurTime()
end
