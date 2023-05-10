local Player = FindMetaTable('Player')

local TIMER = 'oxygen_%i'
local DROWN_TIMER = 'drown_%i'
local BREATHE_TIMER = 'breathe_%i'
local TICK_RATE = 0.1

--[[---------------------------------------------------------------------------
  Starts the oxygen deduction timer
]]-----------------------------------------------------------------------------
function Player:submerge()
  timer.Create(string.format(TIMER, self:EntIndex()), TICK_RATE, 0, function()
    self:setDarkRPVar('oxygen', math.max(self:getDarkRPVar('oxygen') - (GAMEMODE.Config.maxOxygenRate - ((GAMEMODE.Config.maxOxygenRate - GAMEMODE.Config.minOxygenRate)) * self:getDarkRPVar('stamina') * .01), 0))
    if self:getDarkRPVar('oxygen') <= 0 then
      self:drown()
    end
  end)
end

--[[---------------------------------------------------------------------------
  Starts the drowning timer
]]-----------------------------------------------------------------------------
function Player:drown()
  local _timer = string.format(DROWN_TIMER, self:EntIndex())
  if timer.Exists(_timer) then return end
  timer.Create(_timer, GAMEMODE.Config.drownRate, 0, function()
    local damage = DamageInfo()
    damage:SetAttacker(self)
    damage:SetInflictor(self)
    damage:SetDamage(GAMEMODE.Config.drownDamage)
    damage:SetDamageType( DMG_DROWN )
    self:TakeDamageInfo(damage)
    self.DrownRecovery = self.DrownRecovery + GAMEMODE.Config.drownDamage
  end)
end

--[[---------------------------------------------------------------------------
  Starts the oxygen recovery timer
]]-----------------------------------------------------------------------------
function Player:surface()
  self:breathe()
  local _timer = string.format(TIMER, self:EntIndex())
  timer.Create(_timer, TICK_RATE, 0, function()
    if self:getDarkRPVar('oxygen') >= 100 then timer.Remove(_timer) end
    self:setDarkRPVar('oxygen', math.min(self:getDarkRPVar('oxygen') + (GAMEMODE.Config.minOxygenRate + ((GAMEMODE.Config.maxOxygenRate - GAMEMODE.Config.minOxygenRate)) * self:getDarkRPVar('stamina') * .01), 100))
  end)
end

--[[---------------------------------------------------------------------------
  Starts the breathe timer
]]-----------------------------------------------------------------------------
function Player:breathe()
  if self.DrownRecovery <= 0 then return end
  local _timer = string.format(BREATHE_TIMER, self:EntIndex())
  timer.Remove(string.format(DROWN_TIMER, self:EntIndex()))
  timer.Create(_timer, GAMEMODE.Config.breatheRate, 0, function()
    if self:WaterLevel() >= 3 then return end
    if self.DrownRecovery > 0 then
      if self:Health() < GAMEMODE.Config.startinghealth then
        self:SetHealth(math.min(self:Health() + math.min(self.DrownRecovery, GAMEMODE.Config.breatheHealth), GAMEMODE.Config.startinghealth))
      end
      self.DrownRecovery = math.max(self.DrownRecovery - GAMEMODE.Config.breatheHealth, 0)
    else
      timer.Remove(_timer)
    end
  end)
end

--[[---------------------------------------------------------------------------
  Removes all oxygen timers
]]-----------------------------------------------------------------------------
function Player:flushOxygenTimers()
  timer.Remove(string.format(TIMER, self:EntIndex()))
  timer.Remove(string.format(DROWN_TIMER, self:EntIndex()))
  timer.Remove(string.format(BREATHE_TIMER, self:EntIndex()))
end
