local Player = FindMetaTable('Player')

local TYPE_NUMBER = 'number'
local TIMER = 'stamina_%i'
local TICK_RATE = 0.1

--[[---------------------------------------------------------------------------
  Returns the desired jump power
  @return {number} jump power
]]-----------------------------------------------------------------------------
function Player:desiredJumpPower()
  local jumpPower = hook.Run('playerDesiredJumpPower') or 200
  if not jumpPower or not type(runSpeed) == TYPE_NUMBER then
    jumpPower = 200
  end
  return jumpPower
end

--[[---------------------------------------------------------------------------
  Returns the desired running speed
  @return {number} run speed
]]-----------------------------------------------------------------------------
function Player:desiredRunSpeed()
  local runSpeed = GAMEMODE.Config.runspeed
  if self:isCP() then
    runSpeed = GAMEMODE.Config.runspeedcp
  end
  return runSpeed or hook.Run('playerDesiredRunSpeed', runSpeed)
end

--[[---------------------------------------------------------------------------
  Called when the player depletes their stamina
]]-----------------------------------------------------------------------------
function Player:exhausted()
  self:setDarkRPVar('stamina', -GAMEMODE.Config.exhaustion)
  self:SetRunSpeed(self:GetWalkSpeed())
  self:SetJumpPower(0)
end

--[[---------------------------------------------------------------------------
  Adds or deducts stamina, makes the player exhausted if it goes below 0
  @param {number} stamina
]]-----------------------------------------------------------------------------
function Player:addStamina(stamina)
  local _stamina = self:getDarkRPVar('stamina')
  if stamina < 0 and _stamina + stamina <= 0 then
    self:exhausted()
  else
    if _stamina <= 0 then -- restore walking and running speeds
      self:SetRunSpeed(self:desiredRunSpeed())
      self:SetJumpPower(self:desiredJumpPower())
    end
    self:setDarkRPVar('stamina', math.min(_stamina + stamina, 100))
  end
end

--[[---------------------------------------------------------------------------
  Returns the fatigue value (0 = fatigued; 1 = not fatigued)
  @return {number} fatigue
]]-----------------------------------------------------------------------------
function Player:getFatigue()
  self.Fatigue = 1
  hook.Run('playerFatigue', self, self:getDarkRPVar('stamina'), self:getDarkRPVar('oxygen'))
  return self:getDarkRPVar('oxygen') * .01 * self.Fatigue
end

--[[---------------------------------------------------------------------------
  Function called every tick when sprinting
]]-----------------------------------------------------------------------------
function Player:sprintTick()
  if not IsValid(self) or not self:OnGround() and self:WaterLevel() <= 1 then return end -- if on air, don't spend
  self:addStamina(-(GAMEMODE.Config.maxStaminaRate - ((GAMEMODE.Config.maxStaminaRate - GAMEMODE.Config.minStaminaRate)) * self:getFatigue()))
end

--[[---------------------------------------------------------------------------
  Function called every tick when resting from sprint
]]-----------------------------------------------------------------------------
function Player:restTick()
  if not IsValid(self) or not self:OnGround() and self:WaterLevel() <= 1 then return end -- if on air, don't regenerate
  self:addStamina(GAMEMODE.Config.minStaminaRate + ((GAMEMODE.Config.maxStaminaRate - GAMEMODE.Config.minStaminaRate) * self:getFatigue()))
end

--[[---------------------------------------------------------------------------
  Called when the player starts sprinting, creates timer and applies penalty
]]-----------------------------------------------------------------------------
function Player:startSprint()
  if self.Sprinting then return end
  self.Sprinting = true
  hook.Run('playerStartedSprinting', self)
  timer.Create(string.format(TIMER, self:EntIndex()), TICK_RATE, 0, function()
    self:sprintTick()
  end)
end

--[[---------------------------------------------------------------------------
  Called when the player stops sprinting
]]-----------------------------------------------------------------------------
function Player:stopSprint()
  if not self.Sprinting then return end
  self.Sprinting = false
  hook.Run('playerStoppedSprinting', self)
  local _timer = string.format(TIMER, self:EntIndex())
  timer.Create(_timer, GAMEMODE.Config.postSprintDelay, 1, function() -- create post sprint delay
    timer.Create(_timer, TICK_RATE, 0, function() -- create actual timer
      self:restTick()
    end)
  end)
end

--[[---------------------------------------------------------------------------
  Removes the stamina tick timer
]]-----------------------------------------------------------------------------
function Player:flushStaminaTimer()
  timer.Remove(string.format(TIMER, self:EntIndex()))
end
