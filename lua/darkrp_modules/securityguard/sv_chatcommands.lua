--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase('en', 'guard_hire_self', 'You cannot hire yourself.')
DarkRP.addPhrase('en', 'guard_offer_self', 'You cannot offer services to yourself.')
DarkRP.addPhrase('en', 'guard_invalid_offer', 'Provide a valid name or look at a player.')

-- request security services
DarkRP.defineChatCommand('requestsecurity', function(_player, args)
  if not args or string.len(string.Trim(args)) <= 0 then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase('arguments'), ''))
    return ''
  end

  local target = DarkRP.findPlayer(args)

  if not target then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('could_not_find', tostring(args)))
  else
    if target == _player then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_hire_self'))
    else
      _player:requestSecurity(target)
    end
  end

  return ''
end)

-- offer security services
DarkRP.defineChatCommand('offersecurity', function(_player, args)
  local hasName = args and string.len(string.Trim(args)) > 0
  local target = nil
  local trace = _player:GetEyeTrace()

  -- check target validity
  if not hasName and not (trace.Hit and trace.Entity:IsPlayer()) then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_invalid_offer'))
    return ''
  else
    if hasName then
      target = DarkRP.findPlayer(args)
    else
      target = trace.Entity
    end
  end

  if not target then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('could_not_find', tostring(args)))
  else
    if target == _player then
      DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_offer_self'))
    else
      _player:offerSecurity(target)
    end
  end

  return ''
end)

-- end security contract
DarkRP.defineChatCommand('endsecuritycontract', function(_player, args)
  _player:endSecurityContract()
  return ''
end)

-- buy kevlar
DarkRP.defineChatCommand('buykevlar', function(_player, args)
  if not _player:isSecurityGuard() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('guards_only'))
    return ''
  end
  if _player.buyKevlarDelay and _player.buyKevlarDelay > CurTime() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('have_to_wait', math.ceil(_player.buyKevlarDelay - CurTime()), 'buykevlar'))
    return
  end
  if _player:getDarkRPVar('money') < GAMEMODE.Config.buyKevlarPrice then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', 'buykevlar'))
    return
  end
  if _player:getDarkRPVar('kevlar') >= 100 and _player:getDarkRPVar('kevlar_type') == KEVLAR_CIVILIAN then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('kevlar_cannot_replace'))
    return
  end
  _player:addMoney(-GAMEMODE.Config.buyKevlarPrice)
  _player:setKevlar(KEVLAR_CIVILIAN)
  _player.buyKevlarDelay = CurTime() + GAMEMODE.Config.buyKevlarDelay
  DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('you_bought', 'buykevlar', DarkRP.formatMoney(GAMEMODE.Config.buyKevlarPrice)))
  return ''
end)
