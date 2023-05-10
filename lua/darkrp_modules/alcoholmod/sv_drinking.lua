--[[---------------------------------------------------------------------------
  Handle alcohol ingestion
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

local TIMER = 'alcoholmod_drink_%i_%i'
local CLUMSY_TIMER = 'alcoholmod_clumsy_%i'

local CLUMSY_TICK = 5
local CLUMSY_MINRAND, CLUMSY_MAXRAND = 2, 6
local CLUMSY_ACTION = { 'duck', 'moveleft', 'moveright', 'forward', 'back', 'right', 'left' }
local ACTION_START, ACTION_STOP = '+', '-'
local ACTION_MINTIME, ACTION_MAXTIME = 0.25, 1.25

--[[---------------------------------------------------------------------------
  Drinks an alcoholic brevage
  @param {number} alcohol amount
  @param {number|nil} hangover amount (defaults to alcohol)
  @param {number|nil} energy given by drink (defaults to 0)
]]-----------------------------------------------------------------------------
function Player:drink(alcohol, hangover, energy)
  local override = hook.Run('playerDrinkAlcohol', self, alcohol, hangover, energy)
  if override then return end

  self:EmitSound(string.format('npc/barnacle/barnacle_gulp%i.wav', math.random(1, 2)))
  self:addAlcohol(alcohol, hangover)
  self:alcoholBoost(alcohol)

  if not energy then return end
  self:setDarkRPVar('Energy', math.min(self:getDarkRPVar('Energy') + energy, 100))
end

--[[---------------------------------------------------------------------------
  Adds an alcohol debuff to the tray
  @param {number} alcohol amount
  @param {number|nil} hangover amount (defaults to alcohol)
]]-----------------------------------------------------------------------------
function Player:addAlcohol(alcohol, hangover)
  hangover = hangover or alcohol

  -- get alcohol before drink
  local _alcohol = self:getDarkRPVar('alcohol')

  -- check whether the player will become drunk
  if _alcohol + alcohol >= 100 then
    self:Kill()
    self.Slayed = true
    hook.Run('playerOverdosedOnAlcohol', self)
    DarkRP.notify( self, NOTIFY_ERROR, 4, DarkRP.getPhrase('alcoholoverdose'))
    return -- skip process
  elseif _alcohol <= GAMEMODE.Config.alcoholOverdose and _alcohol + alcohol > GAMEMODE.Config.alcoholOverdose then
    self:simulateClumsiness()
    DarkRP.notify(self, NOTIFY_ERROR, 4, DarkRP.getPhrase('drunk'))
  end

  -- warn about dangerous drinking rhythm
  if _alcohol + (alcohol * 2) >= 100 then
    DarkRP.notify(self, NOTIFY_HINT, 8, DarkRP.getPhrase('drinkdanger'))
  end

  -- add drink to tray
  local i = table.insert(self.AlcoholDrinks, { alcohol = alcohol, hangover = hangover })
  self:setDarkRPVar('alcohol', _alcohol + alcohol)

  -- create decay timer
  timer.Create( string.format( TIMER, self:EntIndex(), i ), GAMEMODE.Config.minAlcoholTime + math.min( GAMEMODE.Config.alcoholTime * alcohol, GAMEMODE.Config.maxAlcoholTime ), 1, function()
    hook.Run('playerAlcoholDrinkDecayed', self, self.AlcoholDrinks[i].alcohol, self.AlcoholDrinks[i].hangover)
    self:addHangover( self.AlcoholDrinks[i].hangover )
    self:setDarkRPVar('alcohol', self:getDarkRPVar('alcohol') - self.AlcoholDrinks[i].alcohol)
    self.AlcoholDrinks[i] = nil
  end )
end

--[[---------------------------------------------------------------------------
  Removes all drink related timers
]]-----------------------------------------------------------------------------
function Player:flushDrinkTimers()
  for i, _ in pairs( self.AlcoholDrinks ) do
    timer.Remove( string.format( TIMER, self:EntIndex(), i ) )
  end
  timer.Remove( string.format( CLUMSY_TIMER, self:EntIndex() ) )
end

--[[---------------------------------------------------------------------------
  Removes all traces of alcohol in a player
]]-----------------------------------------------------------------------------
function Player:clearAlcohol()
  self:flushDrinkTimers()
  self:removeAlcoholBoost()
  self:setDarkRPVar('alcohol', 0)
  DarkRP.notify(self, NOTIFY_CLEANUP, 4, DarkRP.getPhrase('drunkcure'))
end

--[[---------------------------------------------------------------------------
  Starts the clumsiness simulation
]]-----------------------------------------------------------------------------
function Player:simulateClumsiness()
  local _timer = string.format(CLUMSY_TIMER, self:EntIndex())
  if timer.Exists(_timer) then return end
  timer.Create(_timer, CLUMSY_TICK, 0, function()
    local alcohol = self:getDarkRPVar('alcohol') or 0
    -- remove effects if not drunk anymore
    if alcohol <= GAMEMODE.Config.alcoholOverdose then
      timer.Remove(_timer)
    end

    -- make an action
    if math.random(1, CLUMSY_MINRAND + (CLUMSY_MAXRAND * alcohol * .01)) == 1 then
      local action = CLUMSY_ACTION[math.random(1, #CLUMSY_ACTION)]
      self:ConCommand(ACTION_START .. action)

      -- stop the action after some time
      timer.Simple(ACTION_MINTIME + (ACTION_MAXTIME * alcohol * .01), function()
        if not IsValid(self) then return end
        self:ConCommand(ACTION_STOP .. action)
      end)
    end
  end)
end

-- if player dies, remove timers
hook.Add( 'PlayerDeath', 'alcoholmod_drink_death', function(_player)
  _player:flushDrinkTimers()
end)

-- if player disconnects, remove timers
hook.Add( 'PlayerDisconnected', 'alcoholmod_drink_disconnect', function(_player)
  _player:flushDrinkTimers()
  for _, action in pairs(CLUMSY_ACTION) do
    _player:ConCommand(ACTION_STOP .. action)
  end
end)
