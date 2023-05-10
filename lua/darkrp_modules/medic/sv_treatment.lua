local Player = FindMetaTable('Player')

-- network strings
util.AddNetworkString('medic_openmenu')
util.AddNetworkString('medic_pricechange')
util.AddNetworkString('medic_request')

-- constants
local QUESTION = 'medic|%i|%i'
local PRICE_INVALID = -1

-- notifications
DarkRP.addPhrase('en', 'medic_disconnect', 'Medic %s\'s treatment has been cancelled because they left the game.')
DarkRP.addPhrase('en', 'medic_changeteam', 'Medic %s\'s treatment has been cancelled because they changed jobs.')
DarkRP.addPhrase('en', 'medic_death', 'Medic %s\'s treatment has been cancelled because they died.')
DarkRP.addPhrase('en', 'medic_patient_death', '%s\'s treatment has been cancelled because they died.')
DarkRP.addPhrase('en', 'medic_pricechange', 'Medic %s has changed their prices. Please try again.')
DarkRP.addPhrase('en', 'medic_pricechanged', 'You have set your healing price to %i.')
DarkRP.addPhrase('en', 'medic_feechanged', 'You have set your base fee to %i.')
DarkRP.addPhrase('en', 'medic_offer_question', 'Accept %s\'s medical treatment offer for %s?')
DarkRP.addPhrase('en', 'medic_request_question', 'Treat %s for %s?')
DarkRP.addPhrase('en', 'medics_only', 'Medics only.')
DarkRP.addPhrase('en', 'not_medic', 'The player you\'re looking at is not a Medic!')
DarkRP.addPhrase('en', 'medic_offer_already', 'This player is already responding to an offer.')
DarkRP.addPhrase('en', 'medic_request_already', 'This player is already responding to your request.')
DarkRP.addPhrase('en', 'medic_heal_delay', 'You have to wait %i seconds before being healed by another Medic again.')
DarkRP.addPhrase('en', 'medic_patient_heal_delay', 'You have to wait %i seconds before healing this player again.')
DarkRP.addPhrase('en', 'medic_offer_delay', 'You have to wait %i seconds before offering your services to this player again.')
DarkRP.addPhrase('en', 'medic_request_delay', 'You have to wait %i seconds before requesting medical treatment to this player again.')
DarkRP.addPhrase('en', 'medic_patient_cancel', 'Patient has cancelled the treatment!')
DarkRP.addPhrase('en', 'medic_cannot_afford', 'You cannot afford this medic\'s treatment!')
DarkRP.addPhrase('en', 'medic_patient_cannot_afford', 'This player cannot afford your treatment!')
DarkRP.addPhrase('en', 'medic_optimal', 'You are already on optimal conditions.')
DarkRP.addPhrase('en', 'medic_patient_optimal', 'This player is already on optimal conditions.')
DarkRP.addPhrase('en', 'medic_requested', 'Request sent.')
DarkRP.addPhrase('en', 'medic_offered', 'Offer sent.')
DarkRP.addPhrase('en', 'medic_request_rejected', '%s has rejected your treatment request!')
DarkRP.addPhrase('en', 'medic_offer_rejected', '% has rejected your treatment offer.')
DarkRP.addPhrase('en', 'medic_pay', 'You have paid %s for %s\'s treatment.')
DarkRP.addPhrase('en', 'medic_receive', 'You have received %s for treating %s.')

-- medical bill breakdown
DarkRP.addPhrase('en', 'medic_fee_bill', 'Treatment base fee')
DarkRP.addPhrase('en', 'medic_heal_bill', 'Restore %i%% health')

-- callback functions
local requestCallback
local offerCallback

--[[---------------------------------------------------------------------------
  Adds a new patient to a doctor's watchlist
  @param {Player} patient
]]-----------------------------------------------------------------------------
function Player:addPatient(patient)
  if not self:isMedic() or patient.Medic.medic.player == patient then return end
  if patient.Medic.medic.player then
    DarkRP.notify(patient.Medic.medic.player, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_cancel'))
    patient.Medic.medic.player:removePatient(patient.Medic.medic.pos)
  end
  local pos = table.insert(self.Medic.patients, patient)
  patient.Medic.medic.player = self
  patient.Medic.medic.pos = pos
end

--[[---------------------------------------------------------------------------
  Removes a patient from the list and clears that patient's current medic
  @param {number} table position
  @param {string} optional message
]]-----------------------------------------------------------------------------
function Player:removePatient(i, message)
  if not self:isMedic() then return end
  if message and IsValid(self.Medic.patients[i]) then
    DarkRP.notify(self.Medic.patients[i], NOTIFY_ERROR, 4, message)
  end
  self.Medic.patients[i].Medic.medic.player = nil
  DarkRP.destroyQuestion(string.format(QUESTION, self:EntIndex(), self.Medic.patients[i]:EntIndex()))
  table.remove(self.Medic.patients, i)
end

--[[---------------------------------------------------------------------------
  Clears the patients table and resets those patient's current medic
  @param {string} optional message
]]-----------------------------------------------------------------------------
function Player:clearPatients(message)
  if not self:isMedic() then return end
  for i, _ in pairs(self.Medic.patients) do
    self:removePatient(i, message)
  end
end

--[[---------------------------------------------------------------------------
  Called when a medic changes its prices, cancelling all current treatments
]]-----------------------------------------------------------------------------
function Player:medicPriceChanged()
  if not self:isMedic() then return end
  -- clear current patients
  self:clearPatients(DarkRP.getPhrase('medic_pricechange', self:Name()))
  -- close any medic menus with this player
  net.Start('medic_pricechange')
  net.WriteEntity(self)
  net.Broadcast()
end

--[[---------------------------------------------------------------------------
  Sets the new healing price
  @param {number} price
]]-----------------------------------------------------------------------------
function Player:setHealPrice(price)
  self.Medic.price = math.Clamp(price, 0, GAMEMODE.Config.maxHealPrice)
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('medic_pricechanged', self.Medic.price))
  self:medicPriceChanged()
end

--[[---------------------------------------------------------------------------
  Sets the new entry fee for healing
]]-----------------------------------------------------------------------------
function Player:setHealFee(fee)
  self.Medic.fee = math.Clamp(fee, GAMEMODE.Config.healCost, GAMEMODE.Config.maxHealFee)
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('medic_feechanged', self.Medic.fee))
  self:medicPriceChanged()
end

--[[---------------------------------------------------------------------------
  Calculates how much it would cost to a player get your medical services
]]-----------------------------------------------------------------------------
function Player:calculateHealBill(patient)
  local price = 0
  local breakdown = hook.Run('medicalBillCalc', self, patient, {}) or {}

  -- add healing fee
  if patient:Health() < GAMEMODE.Config.startinghealth then
    local health = GAMEMODE.Config.startinghealth - math.max(patient.Medic.health, patient:Health())
    local heal = {
      name = DarkRP.getPhrase('medic_heal_bill', health),
      price = math.min(self.Medic.price * health * .01, GAMEMODE.Config.maxHealPrice)
    }
    table.insert(breakdown, heal)
  end

  -- if there's nothing to heal, don't pay
  if table.Count(breakdown) <= 0 then
    return PRICE_INVALID, {}
  end

  -- add base fee
  local base = {
    name = DarkRP.getPhrase('medic_fee_bill'),
    price = math.min(self.Medic.fee, GAMEMODE.Config.maxHealFee)
  }
  table.insert(breakdown, base)

  -- calculate total price
  for _, fee in pairs(breakdown) do
    price = price + fee.price
  end

  return price, breakdown
end

--[[---------------------------------------------------------------------------
  Requests medical treatment to the given medic
  @param {Player} medic
]]-----------------------------------------------------------------------------
function Player:requestTreatment(medic)
  -- is medic actually a Medic?
  if not medic:isMedic() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('not_medic'))
    return
  end

  -- is the medic too far away?
  if self:GetPos():Distance(medic:GetPos()) > GAMEMODE.Config.minHealDistance then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
    return
  end

  -- have you already requested to this medic?
  if self.Medic.medic.player and self.Medic.medic.player == medic then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_request_already'))
    return
  end

  -- do you have to wait for another treatment?
  if self.Medic.delay.heal > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_heal_delay', math.ceil(self.Medic.delay.heal - CurTime())))
    return
  end

  -- were you rejected and need to wait?
  if medic.Medic.delay.requests[self] and medic.Medic.delay.requests[self] > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_request_delay', math.ceil(medic.Medic.delay.requests[self] - CurTime())))
    return
  end

  -- freeze health
  self.Medic.health = self:Health()

  -- calculate price
  local price, breakdown = medic:calculateHealBill(self)

  -- check if there's anything to heal
  if price <= PRICE_INVALID then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_optimal'))
    return
  end

  -- check if player can afford the treatment
  if price > self:getDarkRPVar('money') then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_cannot_afford'))
    return
  end

  -- make question
  DarkRP.createQuestion(
    DarkRP.getPhrase('medic_request_question', self:Name(), DarkRP.formatMoney(price - GAMEMODE.Config.healCost)),
    string.format(QUESTION, medic:EntIndex(), self:EntIndex()),
    medic,
    GAMEMODE.Config.healQuestionTime,
    requestCallback,
    self,
    medic
  )

  -- notify as the question has been made
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('medic_requested'))

  -- add patient
  medic:addPatient(self)

  -- apply delay
  medic.Medic.delay.requests[self] = CurTime() + GAMEMODE.Config.healRequestDelay

end

--[[---------------------------------------------------------------------------
  Offers medical treatment to the given player
  @param {Player} patient
]]-----------------------------------------------------------------------------
function Player:offerTreatment(patient)
  -- is medic actually a Medic?
  if not self:isMedic() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medics_only'))
    return
  end

  -- is the medic too far away?
  if self:GetPos():Distance(patient:GetPos()) > GAMEMODE.Config.minHealDistance then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
    return
  end

  -- have you already requested to this medic?
  if patient.Medic.medic.player then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_request_already'))
    return
  end

  -- do you have to wait for another treatment?
  if patient.Medic.delay.heal > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_heal_delay', math.ceil(patient.Medic.delay.heal - CurTime())))
    return
  end

  -- were you rejected and need to wait?
  if self.Medic.delay.offers[patient] and self.Medic.delay.offers[patient] > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_offer_delay', math.ceil(self.Medic.delay.offers[patient] - CurTime())))
    return
  end

  -- freeze health
  patient.Medic.health = patient:Health()

  -- calculate price
  local price, breakdown = self:calculateHealBill(patient)

  -- check if there's anything to heal
  if price <= PRICE_INVALID then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_optimal'))
    return
  end

  -- check if player can afford the treatment
  if price > patient:getDarkRPVar('money') then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_cannot_afford'))
    return
  end

  -- make question
  DarkRP.createQuestion(
    DarkRP.getPhrase('medic_offer_question', self:Name(), DarkRP.formatMoney(price)),
    string.format(QUESTION, self:EntIndex(), patient:EntIndex()),
    patient,
    GAMEMODE.Config.healQuestionTime,
    offerCallback,
    patient,
    self
  )

  -- add patient
  self:addPatient(patient)

  -- apply offer delay
  self.Medic.offers[patient] = CurTime() + GAMEMODE.Config.healOfferDelay
end

--[[---------------------------------------------------------------------------
  Heals the given player
  @param {Player} patient
]]-----------------------------------------------------------------------------
function Player:healPlayer(patient)
  -- is medic actually a Medic?
  if not self:isMedic() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medics_only'))
    return
  end

  -- is the medic too far away?
  if self:GetPos():Distance(patient:GetPos()) > GAMEMODE.Config.minHealDistance then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
    return
  end

  if patient.Medic.medic.player ~= self then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_cancel'))
    return
  end

  local price, breakdown = self:calculateHealBill(patient)

  -- check if there's anything to heal
  if price <= PRICE_INVALID then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_optimal'))
    DarkRP.notify(patient, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_optimal'))
    return
  end

  -- check if player can afford the treatment
  if price > patient:getDarkRPVar('money') then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_patient_cannot_afford'))
    DarkRP.notify(patient, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_cannot_afford'))
    return
  end

  -- pay for treatment
  patient:addMoney(-price)
  DarkRP.notify(patient, NOTIFY_GENERIC, 4, DarkRP.getPhrase('medic_pay', DarkRP.formatMoney(price), self:Name()))

  -- receive money for treatment
  self:addMoney(price - GAMEMODE.Config.healCost)
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('medic_receive', DarkRP.formatMoney(price - GAMEMODE.Config.healCost), patient:Name()))

  -- treat player
  if patient:Health() < GAMEMODE.Config.startinghealth then
    patient:SetHealth(math.min(patient:Health() + (GAMEMODE.Config.startinghealth - patient.Medic.health), GAMEMODE.Config.startinghealth))
  end
  hook.Run('playerHealed', patient, self, price, breakdown)

  -- remove patient
  self:removePatient(patient.Medic.medic.pos)

  -- apply heal delay
  patient.Medic.delay.heal = CurTime() + GAMEMODE.Config.healDelay
end

--[[---------------------------------------------------------------------------
  Called when a medic answers a healing request
  @param {string} answer
  @param {Player} medic
  @param {Player} patient
]]-----------------------------------------------------------------------------
requestCallback = function(answer, medic, patient)
  if not IsValid(medic) or not IsValid(patient) then return end
  if not tobool(answer) then
    medic:removePatient(patient.Medic.medic.pos)
    DarkRP.notify(patient, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_request_rejected', medic:Name()))
    return
  end
  medic:healPlayer(patient)
end

--[[---------------------------------------------------------------------------
  Called when a player answers a healing offer
  @param {string} answer
  @param {Player} patient
  @param {Player} medic
]]-----------------------------------------------------------------------------
offerCallback = function(answer, patient, medic)
  if not IsValid(medic) or not IsValid(patient) then return end
  if not tobool(answer) then
    medic:removePatient(patient.Medic.medic.pos)
    DarkRP.notify(medic, NOTIFY_ERROR, 4, DarkRP.getPhrase('medic_offer_rejected', patient:Name()))
    return
  end
  medic:healPlayer(patient)
end

-- receive request
net.Receive('medic_request', function(len, _player)
  if not _player:Alive() then return end
  local medic = net.ReadEntity()
  if not IsValid(medic) then return end
  _player:requestTreatment(medic)
end)
