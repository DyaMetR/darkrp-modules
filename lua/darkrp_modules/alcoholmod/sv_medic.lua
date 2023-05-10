--[[---------------------------------------------------------------------------
  Medic system support
]]-----------------------------------------------------------------------------

-- alcoholCurePrice - How much it costs for alcohol to be cured
GM.Config.alcoholCurePrice    = 40

-- hangoverCurePrice - How much it costs for hangover to be cured
GM.Config.hangoverCurePrice    = 60

-- add alcohol and hangover pricing
hook.Add('medicalBillCalc', 'alcoholmod_medic_price', function(doctor, patient, breakdown)
  -- alcohol curing price
  if patient:getDarkRPVar('alcohol') > GAMEMODE.Config.alcoholOverdose then
    table.insert(breakdown, {name = 'Alcohol detox', price = GAMEMODE.Config.alcoholCurePrice})
  end

  -- hangover curing price
  if patient:getDarkRPVar('hangover') > GAMEMODE.Config.alcoholOverdose then
    table.insert(breakdown, {name = 'Dehydration treatment', price = GAMEMODE.Config.hangoverCurePrice})
  end

  return breakdown
end)

-- cure alcohol and hangover
hook.Add('playerHealed', 'alcoholmod_medic_heal', function(patient, doctor, price, breakdown)
  -- cure alcohol
  if patient:getDarkRPVar('alcohol') > GAMEMODE.Config.alcoholOverdose then
    patient:clearAlcohol()
  end

  -- cure hangover
  if patient:getDarkRPVar('hangover') > GAMEMODE.Config.alcoholOverdose then
    patient:cureHangover()
  end
end)
