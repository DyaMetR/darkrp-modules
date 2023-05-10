--[[---------------------------------------------------------------------------
  Define chat commands
]]-----------------------------------------------------------------------------

local BUYHEALTH_TIMER = 'buyhealth_%i'

-- phrases
DarkRP.addPhrase('en', 'medics_only', 'Medics only')

-- healing request command
DarkRP.defineChatCommand('requestheal', function(_player, args)
  local trace = _player:GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() then
    DarkRP.notify( _player, 1, 4, DarkRP.getPhrase( 'must_be_looking_at', DarkRP.getPhrase( 'player' ) ) )
    return ''
  end
  _player:requestTreatment(trace.Entity)
  return ''
end)

-- healing offer command
DarkRP.defineChatCommand('offerheal', function(_player, args)
  local trace = _player:GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() then
    DarkRP.notify( _player, 1, 4, DarkRP.getPhrase( 'must_be_looking_at', DarkRP.getPhrase( 'player' ) ) )
    return ''
  end
  _player:offerTreatment(trace.Entity)
  return ''
end)

-- set the base fee for a treatment
DarkRP.defineChatCommand('setbasefee', function(_player, args)
  if not args or string.Trim( args ) == '' then
    DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase( 'arguments' ), ''))
    return ''
  end
  _player:setHealFee(tonumber(args))
  return ''
end)

-- set the healing price
DarkRP.defineChatCommand('sethealprice', function(_player, args)
  if not args or string.Trim( args ) == '' then
    DarkRP.notify(_player, 1, 4, DarkRP.getPhrase('invalid_x', DarkRP.getPhrase( 'arguments' ), ''))
    return ''
  end
  _player:setHealPrice(tonumber(args))
  return ''
end)

-- buys health regeneration
DarkRP.defineChatCommand('buyhealth', function(_player, args)
  if not _player:isMedic() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('medics_only'))
    return ''
  end

  if _player:Health() >= GAMEMODE.Config.startinghealth then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_optimal'))
    return ''
  end

  if _player:getDarkRPVar('money') < GAMEMODE.Config.buyhealthPrice then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', 'buyhealth'))
    return ''
  end

  if _player.buyhealthDelay and _player.buyhealthDelay > CurTime() then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('have_to_wait', math.ceil(_player.buyhealthDelay - CurTime()), 'buyhealth'))
    return ''
  end

  local _timer = string.format(BUYHEALTH_TIMER, _player:EntIndex())
  timer.Create(_timer, GAMEMODE.Config.buyhealthRegenRate, GAMEMODE.Config.startinghealth - _player:Health(), function()
    if not IsValid(_player) then timer.Remove(_timer) end
    _player:SetHealth(_player:Health() + 1)
    if _player:Health() >= GAMEMODE.Config.startinghealth then timer.Remove(_timer) end
  end)

  DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('you_bought', 'buyhealth', DarkRP.formatMoney(GAMEMODE.Config.buyhealthPrice)))
  _player:setSelfDarkRPVar('money', _player:getDarkRPVar('money') - GAMEMODE.Config.buyhealthPrice)
  _player.buyhealthDelay = CurTime() + GAMEMODE.Config.buyhealthDelay
  return ''
end)
