
-- initialize medic data
hook.Add('PlayerInitialSpawn', 'medic_init', function(_player)
  _player.Medic = {
    fee = GAMEMODE.Config.healCost, -- entry fee
    price = GAMEMODE.Config.defaultHealPrice, -- healing price
    health = GAMEMODE.Config.startinghealth, -- health amount to pay for (and get healed)
    patients = {},
    medic = {player = nil, pos = 0},
    delay = {
      offers = {},
      requests = {},
      heal = 0
    }
  }
end)

-- medic changes job
hook.Add('PlayerChangedTeam', 'medic_changeteam', function(_player, oldTeam, newTeam)
  if oldTeam ~= TEAM_MEDIC then return end
  _player:clearPatients(DarkRP.getPhrase('medic_changeteam', _player:Name()))
  table.Empty(_player.Medic.delay.offers)
  table.Empty(_player.Medic.delay.requests)
end)

-- medic disconnected
hook.Add('PlayerDisconnected', 'medic_disconnect', function(_player)
  if _player:isMedic() then
    _player:clearPatients(DarkRP.getPhrase('medic_disconnect', _player:Name()))
  else
    if _player.Medic.medic.player then
      _player.Medic.medic.player:removePatient(_player.Medic.medic.pos)
    end
    -- remove their reference from anyone's request delay list
    for _, medic in pairs(player.GetAll()) do
      if medic.Medic.delay.requests[_player] then
        medic.Medic.delay.requests[_player] = nil
      end
    end
  end
end)

-- medic or patient dies
hook.Add('PlayerDeath', 'medic_death', function(_player)
  if _player:isMedic() then
    _player:clearPatients(DarkRP.getPhrase('medic_death', _player:Name()))
  else
    if _player.Medic.medic.player then
      DarkRP.notify(_player.Medic.medic.player, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_death', _player:Name()))
      _player.Medic.medic.player:removePatient(_player.Medic.medic.pos)
    end
  end
end)

-- open menu when pressing E on a medic
hook.Add('KeyPress', 'medic_use', function(_player, key)
  if not _player:Alive() or key ~= IN_USE then return end

  -- check validity of entity
  local trace = _player:GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() or not trace.Entity:isMedic() then return end

  -- if the medic too far away?
  if _player:GetPos():Distance(trace.Entity:GetPos()) > GAMEMODE.Config.minHealDistance then return end

  _player.Medic.health = _player:Health()

  -- calculate price
  local price, breakdown = trace.Entity:calculateHealBill(_player)

  -- can the player be healed?
  if price <= -1 then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_optimal'))
    return
  end

  -- open menu
  net.Start('medic_openmenu')
  net.WriteEntity(trace.Entity)
  net.WriteFloat(price)
  net.WriteTable(breakdown)
  net.Send(_player)
end)
