--[[---------------------------------------------------------------------------
  Player related functions
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

local MESSAGE = '/cr %s'
local TIMER = 'publicenemy_%i'

-- add phrase
DarkRP.addPhrase('en', 'autowantmassrdm', 'Mass murder')
DarkRP.addPhrase('en', 'massrdmcr', 'There\'s a mass murderer! Help!')

--[[---------------------------------------------------------------------------
  Adds a kill to the counter and starts the cooldown timer
  @param {Player} last player killed
]]-----------------------------------------------------------------------------
function Player:addAutoWantKill(victim)
  if self:isCP() then return end -- do not punish police force
  self.AutoWantKills = self.AutoWantKills + 1

  -- make player wanted if the kills exceeds the limit
  if not self:isWanted() and self.AutoWantKills >= GAMEMODE.Config.autoWantKills then
    victim:Say(string.format( MESSAGE, DarkRP.getPhrase( 'massrdmcr' )))
    self:wanted(nil, DarkRP.getPhrase('autowantmassrdm'), GAMEMODE.Config.killWantTime)
  end

  -- create timer
  local _timer = string.format(TIMER, self:EntIndex())
  if not timer.Exists(_timer) then
    timer.Create(_timer, GAMEMODE.Config.killCooldown, 1, function()
      self:resetAutoWantKills()
    end)
  end
end

--[[---------------------------------------------------------------------------
  Resets the kill counter
]]-----------------------------------------------------------------------------
function Player:resetAutoWantKills()
  self.AutoWantKills = 0
  timer.Remove(string.format(TIMER, self:EntIndex()))
end
