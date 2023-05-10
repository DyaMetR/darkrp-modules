--[[---------------------------------------------------------------------------
  Health boosting
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

local TIMER = 'alcoholmod_boost_%i'

--[[---------------------------------------------------------------------------
  Applies a temporal health boost
  @param {number} health to add
]]-----------------------------------------------------------------------------
function Player:alcoholBoost(health)
  local override = hook.Run('playerHealthBoostedByAlcohol', self, health)
  if override then return end

  -- add health
  local _health = self:Health() - self.AlcoholBoost -- health without boost
  self.AlcoholBoost = math.min(self.AlcoholBoost + health, GAMEMODE.Config.alcoholMaxBoost)
  self:SetHealth(_health + self.AlcoholBoost)

  -- get timer name
  local timer_name = string.format(TIMER, self:EntIndex())

  -- if timer already exists skip
  if timer.Exists(timer_name) then return end

  -- create timer
  timer.Create(timer_name, GAMEMODE.Config.alcoholBoostDecay, 0, function()
    self.AlcoholBoost = self.AlcoholBoost - 1
    self:SetHealth(math.max(self:Health() - 1, 1))
    if self.AlcoholBoost <= 0 then timer.Remove(timer_name) end
  end)
end

--[[---------------------------------------------------------------------------
  Removes the alcohol health boost at once
]]-----------------------------------------------------------------------------
function Player:removeAlcoholBoost()
  self:SetHealth(math.max(self:Health() - self.AlcoholBoost, 1))
  self.AlcoholBoost = 0
  timer.Remove(string.format( TIMER, self:EntIndex()))
end

-- if player dies, remove timer
hook.Add( 'PlayerDeath', 'alcoholmod_boost_death', function(_player)
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end)

-- if player disconnects, remove timer
hook.Add( 'PlayerDisconnected', 'alcoholmod_boost_disconnect', function(_player)
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end)
