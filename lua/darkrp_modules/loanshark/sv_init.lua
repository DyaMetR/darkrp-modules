--[[---------------------------------------------------------------------------
  Money loaning by the Mob Boss
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

-- constants
local TIMER = 'loanshark_notice_%i'
local NET = 'loanshark_debtors'

-- language
DarkRP.addPhrase('en', 'loan_paid_self', 'You paid your %s debt back to %s.')
DarkRP.addPhrase('en', 'loan_paid', '%s paid their %s debt back.')
DarkRP.addPhrase('en', 'loanshark_self', '%s has reached maximum interest without paying their debt. You may use violence if necessary to get your money back.')
DarkRP.addPhrase('en', 'loanshark', 'You reached maximum interest with %s\'s loan. Pay your debt or they may use violence.')
DarkRP.addPhrase('en', 'loan_paid_disconnect', '%s disconnected so the debt has been paid.')
DarkRP.addPhrase('en', 'loan_kill_self', '%s took back their %s by force.')
DarkRP.addPhrase('en', 'loan_kill', 'You took your %s from %s by force.')
DarkRP.addPhrase('en', 'loanshark_killed', 'You killed your loan shark. Debt is forgiven.')
DarkRP.addPhrase('en', 'loanshark_killed_self', 'Your debtor %s killed you. Their debt was forgiven.')
DarkRP.addPhrase('en', 'loan_cant_afford', 'You can\'t afford paying your debt.')
DarkRP.addPhrase('en', 'loan_already_self', 'You already have a loan. Pay that one first before requesting a new one.')
DarkRP.addPhrase('en', 'loan_already', '%s already has an active loan!')
DarkRP.addPhrase('en', 'loanshark_disconnect', '%s disconnected so the debt has been forgiven.')
DarkRP.addPhrase('en', 'loanshark_jobchange', '%s changed jobs so the debt has been forgiven.')
DarkRP.addPhrase('en', 'loanshark_jobchange_self', 'You changed jobs so all debts have been forgiven.')
DarkRP.addPhrase('en', 'loan_afk', 'You can\'t go AFK since you have a debt to pay!')
DarkRP.addPhrase('en', 'loanshark_afk', 'You can\'t go AFK since you have debts to collect!')
DarkRP.addPhrase('en', 'loanshark_cant_afford', '%s cannot afford giving a loan.')
DarkRP.addPhrase('en', 'loan_give', 'You\'ve given %s a loan of %s.')
DarkRP.addPhrase('en', 'loan_receive', 'You\'ve received a loan of %s from %s.')
DarkRP.addPhrase('en', 'loan_forgive_self', 'You\'ve forgiven %s\'s debt.')
DarkRP.addPhrase('en', 'loan_forgive', '%s has forgiven your debt.')
DarkRP.addPhrase('en', 'debt', 'debt')
DarkRP.addPhrase('en', 'loan', 'loan')
DarkRP.addPhrase('en', 'loan_afk_paid_self', 'You paid your debt since you went AFK.')
DarkRP.addPhrase('en', 'loan_afk_paid', '%s went AFK so they paid their debt.')
DarkRP.addPhrase('en', 'loanshark_afk_forgive_self', 'You went AFK so all debts have been forgiven.')
DarkRP.addPhrase('en', 'loanshark_afk_forgive', '%s went AFK so they\'ve forgiven your debt.')

-- net
util.AddNetworkString(NET)

--[[---------------------------------------------------------------------------
  Sends the player's debtors list to their clientside
]]-----------------------------------------------------------------------------
function Player:syncDebtors()
  net.Start(NET)
  net.WriteTable(self.Loan or {})
  net.Send(self)
end

--[[---------------------------------------------------------------------------
  Gives a money loan to a player
  @param {Player} player to give loan to
  @param {number} amount of money lent
]]-----------------------------------------------------------------------------
function Player:giveLoan(_player, money)
  if not self:canLoanMoney() or self == _player then return end
  if not self:canAfford(GAMEMODE.Config.minLoan) then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', DarkRP.getPhrase('loan')))
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('loanshark_cant_afford', self:Name()))
    return
  end
  -- setup shark
  self:addMoney(-money)
  self.Loan[_player] = true
  DarkRP.notify(self, NOTIFY_HINT, 4, DarkRP.getPhrase('loan_give', _player:Name(), DarkRP.formatMoney(money)))
  -- setup debtor
  _player:addMoney(money)
  _player:setDarkRPVar('loan', money)
  _player:setDarkRPVar('loanshark', self)
  _player:setDarkRPVar('loantime', CurTime() + GAMEMODE.Config.loanTime)
  DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_receive', DarkRP.formatMoney(money), self:Name()))
  -- give a hint to both parties about the time running out
  timer.Create(string.format(TIMER, _player:EntIndex()), GAMEMODE.Config.loanTime, 1, function()
    if not IsValid(_player) then return end
    DarkRP.notify(_player, NOTIFY_HINT, 6, DarkRP.getPhrase('loanshark', self:Name()))
    DarkRP.notify(self, NOTIFY_HINT, 6, DarkRP.getPhrase('loanshark_self', _player:Name()))
  end)
  -- send debtors
  self:syncDebtors()
end

--[[---------------------------------------------------------------------------
  Makes a player pay a loan back
  @param {boolean} suppress message
  @param {boolean} force pay
]]-----------------------------------------------------------------------------
function Player:payLoan(suppress, force)
  local debt = self:getDebt()
  if not force and not self:canAfford(debt) then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', DarkRP.getPhrase('debt')))
    return
  end
  -- do transaction
  local loanShark = self:getDarkRPVar('loanshark')
  self:addMoney(-debt)
  loanShark:addMoney(debt)
  self:removeLoan()
  -- notify both parties
  if suppress then return end
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_paid_self', DarkRP.formatMoney(debt), loanShark:Name()))
  DarkRP.notify(loanShark, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_paid', self:Name(), DarkRP.formatMoney(debt)))
end

--[[---------------------------------------------------------------------------
  Whether the player is looking at their loan shark
  @return {boolean} looking at loan shark
]]-----------------------------------------------------------------------------
function Player:lookingAtLoanShark()
  local loanShark = self:getDarkRPVar('loanshark')
  if not loanShark or not IsValid(loanShark) then return false end
  local trace = self:GetEyeTrace()
  return trace.Hit and trace.Entity == loanShark
end

--[[---------------------------------------------------------------------------
  Removes a loan a player has
  @param {boolean} skip synchronize
]]-----------------------------------------------------------------------------
function Player:removeLoan(skipSync)
  local loanShark = self:getDarkRPVar('loanshark')
  loanShark.Loan[self] = nil
  self:setDarkRPVar('loanshark', NULL)
  self:setDarkRPVar('loan', 0)
  timer.Remove(string.format(TIMER, self:EntIndex()))
  -- send debtors
  if skipSync then return end
  loanShark:syncDebtors()
end

--[[---------------------------------------------------------------------------
  Removes a debtor from a loan shark's list
  @param {Player} debtor
  @param {boolean} skip synchronize
]]-----------------------------------------------------------------------------
function Player:removeDebtor(_player, skipSync)
  if _player:getDarkRPVar('loanshark') ~= self then return end
  _player:removeLoan(skipSync)
end
