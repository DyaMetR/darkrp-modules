--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase('en', 'loanshark_lookat', 'loan shark')
DarkRP.addPhrase('en', 'loanshark_noloan', 'This player does not have any debts to pay back to you.')

-- loan request
DarkRP.defineChatCommand('requestloan', function(_player, args)
  args = tonumber(args)

  -- invalid arguments
  if not args then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
    return ''
  end

  -- invalid loan shark
  local trace = _player:GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() or not trace.Entity:canLoanMoney() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('must_be_looking_at', DarkRP.getPhrase('loanshark_lookat')))
    return ''
  end

  -- loan shark can't afford
  if not trace.Entity:canAfford(GAMEMODE.Config.minLoan) then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('loanshark_cant_afford', trace.Entity:Name()))
    return ''
  end

  -- request loan
  DarkRP.playerRequestLoan(_player, trace.Entity, args)
  return ''
end)

-- forgive loan
DarkRP.defineChatCommand('forgiveloan', function(_player, args)
  -- valid job
  if not _player:canLoanMoney() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('incorrect_job', 'forgiveloan'))
    return ''
  end

  -- empty args
  if not args or string.len(string.Trim(args)) <= 0 then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
    return ''
  end

  -- get player
  local target = DarkRP.findPlayer(args)

  if not target then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('could_not_find', tostring(args)))
  else
    local loanShark = target:getDarkRPVar('loanshark')
    if not loanShark or loanShark ~= _player then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('loanshark_noloan'))
    else
      DarkRP.notify(_player, NOTIFY_HINT, 4, DarkRP.getPhrase('loan_forgive_self', target:Name()))
      DarkRP.notify(target, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_forgive', _player:Name()))
      _player:removeDebtor(target)
    end
  end
  return ''
end)

-- pay loan
DarkRP.defineChatCommand('payloan', function(_player, args)
  if _player:lookingAtLoanShark() then
    if _player:GetPos():Distance(_player:getDarkRPVar('loanshark'):GetPos()) > GAMEMODE.Config.minLoanDistance then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
      return
    end
    _player:payLoan()
  else
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('must_be_looking_at', DarkRP.getPhrase('loanshark_lookat')))
  end
  return ''
end)
