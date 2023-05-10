local Player = FindMetaTable('Player')

local QUESTION = 'securityguard|%i|%i'

-- add phrases
DarkRP.addPhrase('en', 'guard_cant_hire', 'Security Guards cannot hire other Security Guards!')
DarkRP.addPhrase('en', 'not_guard', '%s is not a Security Guard!')
DarkRP.addPhrase('en', 'guards_only', 'Security Guards only.')
DarkRP.addPhrase('en', 'another_hired_guard', 'This Security Guard is already hired by someone!')
DarkRP.addPhrase('en', 'already_in_guard_contract', 'You are already in a contract.')
DarkRP.addPhrase('en', 'guard_perm', 'You have to stay in your current contract for %s seconds before ending it.')
DarkRP.addPhrase('en', 'you_already_hired_guard', 'You already hired this Security Guard.')
DarkRP.addPhrase('en', 'this_already_guard_hired_you', 'This person already hired you.')
DarkRP.addPhrase('en', 'wait_before_guard_hire', 'You have to wait %s seconds before requesting this Security Guard\'s services again.')
DarkRP.addPhrase('en', 'wait_before_offer_guard', 'You have to wait %s seconds before offering your services to this player again.')
DarkRP.addPhrase('en', 'guard_request_sent', 'Request sent.')
DarkRP.addPhrase('en', 'guard_offer_sent', 'Offer sent.')
DarkRP.addPhrase('en', 'guard_request_reject', '%s rejected your request.')
DarkRP.addPhrase('en', 'guard_offer_reject', '%s rejected your offer.')
DarkRP.addPhrase('en', 'guard_hire', 'You hired %s as your Security Guard.')
DarkRP.addPhrase('en', 'guard_hired', 'You have been hired by %s.')
DarkRP.addPhrase('en', 'not_guard_contract', 'You are not on a contract!')
DarkRP.addPhrase('en', 'guard_end_contract', 'You ended the contract.')
DarkRP.addPhrase('en', 'guard_ended_contract', '%s ended your contract.')
DarkRP.addPhrase('en', 'guard_fire', 'You fired %s.')
DarkRP.addPhrase('en', 'guard_fired', 'You have been fired by %s.')
DarkRP.addPhrase('en', 'guard_request_question', '%s wants to hire you.\nAccept?')
DarkRP.addPhrase('en', 'guard_offer_question', '%s if offering their security services.\nAccept?')

-- callbacks
local requestCallback
local offerCallback

--[[---------------------------------------------------------------------------
  Sets the current security contract related person
  @param {Player} contract related person
]]-----------------------------------------------------------------------------
function Player:setSecurityContractTarget(contract)
  self:setDarkRPVar('securityContract', contract)
  self:setDarkRPVar('securityContract', contract)
end

--[[---------------------------------------------------------------------------
  Notifies the contract request sender if they cannot hire and return whether
  the contract can happen
  @param {Player} sender
  @param {Player} receiver
  @param {boolean} whether sender is the customer
]]-----------------------------------------------------------------------------
local function canHire(sender, receiver, isCustomer)
  -- shared with both request and hiring processes
  if isCustomer then
    -- do not allow security guards hire other guards
    if sender:isSecurityGuard() then
      DarkRP.notify(sender, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_cant_hire'))
      return
    end

    -- check if contract receiver is a guard
    if not receiver:isSecurityGuard() then
      DarkRP.notify(sender, NOTIFY_ERROR, 4, DarkRP.getPhrase('not_guard', receiver:Name()))
      return
    end

    -- check if guard is already on a contract
    if receiver.SecurityGuard.contract then
      if receiver:getSecurityContractTarget() == sender then
        DarkRP.notify(sender, NOTIFY_ERROR, 4, DarkRP.getPhrase('you_already_hired_guard'))
      else
        DarkRP.notify(sender, NOTIFY_ERROR, 4, DarkRP.getPhrase('another_hired_guard'))
      end
      return
    end
  end

  -- check if sender is already on a contract
  if sender.SecurityGuard.contract then
    DarkRP.notify(sender, NOTIFY_ERROR, 4, DarkRP.getPhrase('already_in_guard_contract'))
    return
  end

  -- check delay
  if sender.SecurityGuard.delay[receiver] and sender.SecurityGuard.delay[receiver] > CurTime() then
    local phrase = 'wait_before_guard_hire'
    if not isCustomer then phrase = 'wait_before_offer_guard' end
    DarkRP.notify(sender, NOTIFY_ERROR, 6, DarkRP.getPhrase(phrase, math.ceil(sender.SecurityGuard.delay[receiver] - CurTime())))
    return
  end

  return true
end

--[[---------------------------------------------------------------------------
  Requests security services to a Security Guard
  @param {Player} guard
]]-----------------------------------------------------------------------------
function Player:requestSecurity(guard)
  if not canHire(self, guard, true) then return end

  -- create question
  DarkRP.createQuestion(
    DarkRP.getPhrase('guard_request_question', self:Name()),
    string.format(QUESTION, self:EntIndex(), guard:EntIndex()),
    guard,
    GAMEMODE.Config.guardQuestionTime,
    requestCallback,
    self,
    guard
  )

  -- confirm
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('guard_request_sent'))
end

--[[---------------------------------------------------------------------------
  Offers security services to a player
  @param {Player} customer
]]-----------------------------------------------------------------------------
function Player:offerSecurity(client)
  -- only guards can offer
  if not self:isSecurityGuard() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('guards_only'))
    return
  end

  -- do not allow security guards hire other guards
  if client:isSecurityGuard() then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_cant_hire'))
    return
  end

  if not canHire(self, client, false) then return end

  -- create question
  DarkRP.createQuestion(
    DarkRP.getPhrase('guard_offer_question', self:Name()),
    string.format(QUESTION, client:EntIndex(), self:EntIndex()),
    client,
    GAMEMODE.Config.guardQuestionTime,
    offerCallback,
    self,
    client
  )

  -- confirm
  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('guard_offer_sent'))
end

--[[---------------------------------------------------------------------------
  Hires a Security Guard
  @param {Player} guard
]]-----------------------------------------------------------------------------
function Player:hireGuard(guard)
  if not canHire(self, guard, true) then return end

  DarkRP.addSecurityContract(self, guard)

  DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('guard_hire', guard:Name()))
  DarkRP.notify(guard, NOTIFY_GENERIC, 4, DarkRP.getPhrase('guard_hired', self:Name()))
end

--[[---------------------------------------------------------------------------
  Ends the current security guard contract
]]-----------------------------------------------------------------------------
function Player:endSecurityContract()
  -- check if player is on any contract
  if not self.SecurityGuard.contract then
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('not_guard_contract'))
    return
  end

  -- get contract
  local contract = DarkRP.getSecurityContract(self.SecurityGuard.contract)

  -- check permanency
  if contract.time > CurTime() then
    DarkRP.notify(self, NOTIFY_ERROR, 6, DarkRP.getPhrase('guard_perm', math.ceil(contract.time - CurTime())))
    return
  end

  -- notify parties and apply delay
  if contract.client == self then
    self.SecurityGuard.delay[contract.guard] = CurTime() + GAMEMODE.Config.guardDelay
    DarkRP.notify(self, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('guard_fire', contract.guard:Name()))
    DarkRP.notify(contract.guard, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('guard_fired', self:Name()))
  else
    self.SecurityGuard.delay[contract.client] = CurTime() + GAMEMODE.Config.guardDelay
    DarkRP.notify(self, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('guard_end_contract'))
    DarkRP.notify(contract.client, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('guard_ended_contract', self:Name()))
  end

  -- end contract
  DarkRP.removeSecurityContract(self.SecurityGuard.contract)
end

--[[---------------------------------------------------------------------------
  Called when a Security Guard answers to a request
  @param {string} answer
  @param {Player} guard
  @param {Player} client
]]-----------------------------------------------------------------------------
requestCallback = function(answer, guard, client)
  if not tobool(answer) then
    guard.SecurityGuard.delay[client] = CurTime() + GAMEMODE.Config.guardRejectDelay
    DarkRP.notify(client, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_request_reject', guard:Name()))
    return
  end
  client:hireGuard(guard)
end

--[[---------------------------------------------------------------------------
  Called when a player answers to an offer
  @param {string} answer
  @param {Player} client
  @param {Player} guard
]]-----------------------------------------------------------------------------
offerCallback = function(answer, client, guard)
  if not tobool(answer) then
    client.SecurityGuard.delay[guard] = CurTime() + GAMEMODE.Config.guardRejectDelay
    DarkRP.notify(guard, NOTIFY_ERROR, 4, DarkRP.getPhrase('guard_offer_reject', client:Name()))
    return
  end
  client:hireGuard(guard)
end
