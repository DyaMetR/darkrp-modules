local TYPE_BOOLEAN = 'boolean'
local TYPE_NUMBER = 'number'

local Player = FindMetaTable('Player')

-- add phrases
DarkRP.addPhrase('en', 'starved', 'You starved to death.')

--[[---------------------------------------------------------------------------
  Restores the player's energy by the given amount
  @param {number} energy
  @param {boolean|nil} suppress eating sound
]]-----------------------------------------------------------------------------
function Player:eat(energy, suppress_sound)
  local override = hook.Run('playerEatFood', energy)
  if override then
    if type(override) == TYPE_BOOLEAN and override == false then
      return
    elseif type(override) == TYPE_NUMBER then
      energy = override
    end
  end

  self:setDarkRPVar('Energy', math.min(self:getDarkRPVar('Energy') + energy, 100))
  if suppress_sound then return end
  self:EmitSound('vo/sandwicheat09.mp3', 100, 100)
end

--[[---------------------------------------------------------------------------
  Damages the player and kills them of starvation
]]-----------------------------------------------------------------------------
function Player:starve()
  local starveSpeed = GAMEMODE.Config.starveSpeed
  local override = hook.Run('playerStarving', self:Health(), GAMEMODE.Config.starveSpeed)
  if override then
    if type(override) == TYPE_BOOLEAN and override == false then
      return
    elseif type(override) == TYPE_NUMBER then
      starveSpeed = override
    end
  end

  -- deduct health
  self:SetHealth(self:Health() - starveSpeed)

  -- kill player
  if self:Health() <= 0 then
    self:Kill()
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('starved'))
  end

end

--[[---------------------------------------------------------------------------
  Regenerates the player's health up to the maximum value if they are well fed
]]-----------------------------------------------------------------------------
function Player:regenerate()

  if self:Health() >= GAMEMODE.Config.regenMaxHealth or self:getDarkRPVar('Energy') <= GAMEMODE.Config.regenThreshold then return end

  self:SetHealth(math.min(self:Health() + (GAMEMODE.Config.maxRegeneration - ((GAMEMODE.Config.maxRegeneration - GAMEMODE.Config.minRegeneration) * (self:Health() / GAMEMODE.Config.regenMaxHealth))), GAMEMODE.Config.regenMaxHealth))
  self:setDarkRPVar('Energy', math.max(self:getDarkRPVar('Energy') - GAMEMODE.Config.regenerationCost, 0))

end

--[[---------------------------------------------------------------------------
  Called on every hunger tick; deducts energy and damages the player if they starve
]]-----------------------------------------------------------------------------
function Player:hungerTick()
  if self:getDarkRPVar('Energy') > 0 then -- deduct energy
    local override = hook.Run('playerHunger', self, self:getDarkRPVar('Energy'), GAMEMODE.Config.hungerSpeed)
    local hungerSpeed = GAMEMODE.Config.hungerSpeed
    if override then
      if type(override) == TYPE_BOOLEAN and override == false then
        return
      elseif type(override) == TYPE_NUMBER then
        hungerSpeed = override
      end
    end
    self:regenerate()
    self:setDarkRPVar('Energy', math.max(self:getDarkRPVar('Energy') - hungerSpeed, 0))
  else -- deduct health if they starve
    self:starve()
  end
end
