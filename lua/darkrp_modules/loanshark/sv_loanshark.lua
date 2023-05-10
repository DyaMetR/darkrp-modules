
-- prompt net
local NET = 'loanshark_prompt'
util.AddNetworkString(NET)

-- setup data or forgive debts
hook.Add('PlayerChangedTeam', 'loanshark_teams', function(_player, oldTeam, newTeam)
  -- setup money loaning
  if DarkRP.canTeamLoanMoney(newTeam) then
    _player.Loan = {}
  elseif DarkRP.canTeamLoanMoney(oldTeam) then
    if table.Count(_player.Loan) > 0 then -- if there are loans to collect, forgive them all
      DarkRP.notify(_player, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_jobchange_self'))
      for debtor, _ in pairs(_player.Loan) do
        debtor:removeLoan(true)
        DarkRP.notify(debtor, NOTIFY_GENERIC, 6, DarkRP.getPhrase('loanshark_jobchange', _player:Name()))
      end
      -- send debtors
      _player:syncDebtors()
    end
    _player.Loan = nil
  end
end)

-- prevent AFK if a loan is involved
hook.Add('canGoAFK', 'loanshark_afk', function(_player, isNotAFK)
  if not isNotAFK then return end
  -- if loan shark has debts to collect
  if _player.Loan and table.Count(_player.Loan) > 0 then
    DarkRP.notify(_player, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_afk'))
    return false
  end
  -- if regular player has debts to pay
  local loanShark = _player:getDarkRPVar('loanshark')
  if loanShark and IsValid(loanShark) then
    DarkRP.notify(_player, NOTIFY_ERROR, 6, DarkRP.getPhrase('loan_afk'))
    return false
  end
end)

-- if they don't do /afk and go AFK, they'll pay their debt immediately
hook.Add('playerAFKDemoted', 'loanshark_afkdemote', function(_player)
  -- if loan shark has debts to collect and goes AFK
  if _player.Loan and table.Count(_player.Loan) > 0 then
    DarkRP.notify(_player, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_afk_forgive_self'))
    for debtor, _ in pairs(_player.Loan) do
      DarkRP.notify(debtor, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_afk_forgive', _player:Name()))
      _player:removeDebtor(debtor, true)
    end
    -- send debtors
    _player:syncDebtors()
    return
  end
  -- if debtor goes AFK
  local loanShark = _player:getDarkRPVar('loanshark')
  if loanShark and IsValid(loanShark) then
    DarkRP.notify(_player, NOTIFY_ERROR, 6, DarkRP.getPhrase('loan_afk_paid_self'))
    DarkRP.notify(loanShark, NOTIFY_ERROR, 6, DarkRP.getPhrase('loan_afk_paid', _player:Name()))
    _player:payLoan(true, true)
    return
  end
end)

-- forgive or force pay any debts if any party disconnects
hook.Add('PlayerDisconnected', 'loanshark_disconnect', function(_player)
  -- as a loan shark, forgive all debts
  if _player.Loan then
    for debtor, _ in pairs(_player.Loan) do
      debtor:removeLoan(true)
      DarkRP.notify(debtor, NOTIFY_GENERIC, 6, DarkRP.getPhrase('loanshark_disconnect', _player:Name()))
    end
  else -- if it's a debtor, force to pay their debt
    local loanShark = _player:getDarkRPVar('loanshark')
    if loanShark and IsValid(loanShark) then
      _player:payLoan(true, true)
      DarkRP.notify(loanShark, NOTIFY_GENERIC, 6, DarkRP.getPhrase('loan_paid_disconnect', _player:Name()))
    end
  end
end)

-- shark vs debtor fight
hook.Add('PlayerDeath', 'loanshark_death', function(victim, inflictor, killer)
  -- loan shark
  if victim.Loan and victim.Loan[killer] and killer:isDebtor() then
    killer:removeLoan()
    DarkRP.notify(killer, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loanshark_killed'))
    DarkRP.notify(victim, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_killed_self', killer:Name()))
  elseif victim:isDebtor() and ((killer.Loan and killer.Loan[victim]) or killer:isLoanSharkAlly(victim:getDarkRPVar('loanshark'))) then -- debtor
    local loanShark = killer -- by default, guess that the loanshark is the killer
    if not loanShark.Loan then -- check if the killer was not the loanshark, but one of their allies
      loanShark = victim:getDarkRPVar('loanshark')
    end
    local loan = victim:getDarkRPVar('loan')
    loanShark:addMoney(loan)
    victim:addMoney(-loan)
    loanShark:removeDebtor(victim)
    if loanShark == killer then
      DarkRP.notify(killer, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_kill', DarkRP.formatMoney(loan), victim:Name()))
      DarkRP.notify(victim, NOTIFY_ERROR, 6, DarkRP.getPhrase('loan_kill_self', killer:Name(), DarkRP.formatMoney(loan)))
    else
      DarkRP.notify(killer, NOTIFY_GENERIC, 6, DarkRP.getPhrase('loanshark_ally_kill_self', loanShark:Name(), DarkRP.formatMoney(loan), victim:Name()))
      DarkRP.notify(loanShark, NOTIFY_HINT, 6, DarkRP.getPhrase('loanshark_ally_kill', killer:Name(), DarkRP.formatMoney(loan), victim:Name()))
      DarkRP.notify(victim, NOTIFY_ERROR, 6, DarkRP.getPhrase('loanshark_ally_killed_you', killer:Name(), loanShark:Name(), DarkRP.formatMoney(loan)))
    end
  end
end)

-- keypress
hook.Add('KeyPress', 'loanshark_keypress', function(_player, key)
  if not _player:Alive() or key ~= IN_RELOAD then return end
  if _player:lookingAtLoanShark() then -- pay loan
    if _player:GetPos():Distance(_player:getDarkRPVar('loanshark'):GetPos()) > GAMEMODE.Config.minLoanDistance then
      return
    end
    _player:payLoan()
  else -- request loan
    local trace = _player:GetEyeTrace()
    if not trace.Hit or not trace.Entity:IsPlayer() or not trace.Entity:canLoanMoney() or not trace.Entity:canAfford(GAMEMODE.Config.minLoan) or trace.Entity:GetPos():Distance(_player:GetPos()) > GAMEMODE.Config.minLoanDistance then return end
    net.Start(NET)
    net.Send(_player)
  end
end)
