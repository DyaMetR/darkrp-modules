--[[---------------------------------------------------------------------------
  Handle dehydration by alcohol overdose
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

local DANGER_WARNING = 0.75 -- at which percentage of hangover to kill the player should it throw the warning
local TIMER = 'alcoholmod_hangover_%i'

--[[---------------------------------------------------------------------------
  Adds a hangover amount
  @param {number} hangover
]]-----------------------------------------------------------------------------
function Player:addHangover(hangover)
  local override = hook.Run('playerHangoverIncrease', self, hangover)
  if override then return end

  local _hangover = self:getDarkRPVar('hangover')

  -- warn player about hangover
  if _hangover <= GAMEMODE.Config.alcoholOverdose and _hangover + hangover > GAMEMODE.Config.alcoholOverdose then
    if not self.HangoverNotice then
      DarkRP.notify( self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'hangover' ) )
      self.HangoverNotice = true
    else
      DarkRP.notify( self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'hangoverresume' ) )
    end
  end

  -- warn player about severe dehydration
  if not self.HangoverWarning and _hangover + hangover >= math.min(GAMEMODE.Config.alcoholOverdose + (((self:healthWithoutAlcohol() / GAMEMODE.Config.overdosePenalty) * GAMEMODE.Config.hangoverRate) * DANGER_WARNING), 100) then
    DarkRP.notify(self, NOTIFY_HINT, 8, DarkRP.getPhrase('hangoverdanger'))
    self.HangoverWarning = true
  end

  -- add hangover
  self:setDarkRPVar('hangover', math.min(self:getDarkRPVar('hangover') + hangover, 100))

  -- create timer
  timer.Create(string.format(TIMER, self:EntIndex()), GAMEMODE.Config.hangoverSpeed, 0, function()
    self:hangoverCycle()
  end)

end

--[[---------------------------------------------------------------------------
  Gets the health before the health boost
  @return {number} health without the alcohol boost
]]-----------------------------------------------------------------------------
function Player:healthWithoutAlcohol()
  if DarkRP.isStatsBuffInstalled then
    return math.max( self:Health() - ( self:getHealthStatBuff( 'alcohol' ) or 0 ), 0 )
  else
    return math.max( self:Health() - self.AlcoholBoost, 0 )
  end
end

--[[---------------------------------------------------------------------------
  Deducts hangover and damages the player if needed
]]-----------------------------------------------------------------------------
function Player:hangoverCycle()
  local override = hook.Run( 'playerHangoverReduced', self, GAMEMODE.Config.hangoverRate )
  if override then return end

  local _hangover = self:getDarkRPVar( 'hangover' )
  local hangover = _hangover - GAMEMODE.Config.hangoverRate

  -- reduce hangover
  self:setDarkRPVar( 'hangover', hangover )

  -- damage player if dehydrated
  if hangover > GAMEMODE.Config.alcoholOverdose then
    self:SetHealth( self:Health() - GAMEMODE.Config.overdosePenalty )
    if self:healthWithoutAlcohol() <= 0 then -- fatal dehydration
      self:Kill()
      self.Slayed = true
      hook.Run( 'playerDehydrated', self )
      DarkRP.notify( self, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'dehydration' ) )
      return
    end
  end

  -- notify player if hangover has gone under acceptable limits
  if hangover <= GAMEMODE.Config.alcoholOverdose and _hangover > GAMEMODE.Config.alcoholOverdose then
    DarkRP.notify(self, NOTIFY_GENERIC, 4, DarkRP.getPhrase('hangovercuring'))
    self.HangoverWarning = false
  end

  -- if hangover completely cures, remove timers and notify player
  if hangover <= 0 then
    self:cureHangover()
  end
end

--[[---------------------------------------------------------------------------
  Removes hangover from a player
]]-----------------------------------------------------------------------------
function Player:cureHangover()
  self:setDarkRPVar('hangover', 0)

  if self.HangoverNotice then -- if they previously had a hangover, indicate that it totally cured
    DarkRP.notify(self, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('hangovercured'))
  end

  self.HangoverNotice = false
  self.HangoverWarning = false
  timer.Remove(string.format(TIMER, self:EntIndex()))
end

-- if player dies, remove timer
hook.Add( 'PlayerDeath', 'alcoholmod_hangover_death', function(_player)
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end)

-- if player disconnects, remove timer
hook.Add( 'PlayerDisconnected', 'alcoholmod_hangover_disconnect', function(_player)
  timer.Remove(string.format(TIMER, _player:EntIndex()))
end)
