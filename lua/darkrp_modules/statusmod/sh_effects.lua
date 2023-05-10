--[[---------------------------------------------------------------------------
  Status effects declaration
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase('en', 'regeneration', 'Regeneration')
DarkRP.addPhrase('en', 'overheal', 'Overheal')
DarkRP.addPhrase('en', 'speed', 'Speed increase')
DarkRP.addPhrase('en', 'defense', 'Damage reduction')

local Player = FindMetaTable('Player')

local effects = {}

--[[---------------------------------------------------------------------------
  Declares a status effect
  @param {number|string} identifier
  @param {table} effect data
  - name
  - compare (clientside comparison function to warn the player of overlapping effects)
  - unstackable (whether the effect cannot be stacked, 'compare' is ignored if this is not true)
  - on_add (function called when the effect is applied to a player)
    > player (Player to apply the status to)
    > instance (effect instance identifier)
    > varargs
  - on_expire (function called when the effect is removed)
    > player (Player to apply the status to)
    > instance (effect instance identifier)
  @return {number} table position
]]-----------------------------------------------------------------------------
function DarkRP.addStatusEffect(id, effect_data)
  if CLIENT then
    local compare = nil
    if effect_data.unstackable then
      compare = effect_data.compare or function(a, b) return a[1] > b[1] end
    end
    effects[id] = { name = effect_data.name, compare = compare, unstackable = effect_data.unstackable }
  end

  if SERVER then
    effects[id] = { on_add = effect_data.on_add, on_expire = effect_data.on_expire }
  end

  return id
end

--[[---------------------------------------------------------------------------
  Gets a status effects's data
  @param {number|string} identifier
  @return {table} status type data
]]-----------------------------------------------------------------------------
function DarkRP.getStatusEffect(effect)
  return effects[effect]
end

if SERVER then

  --[[---------------------------------------------------------------------------
    Applies an effect to the player
    @param {number|string} effect identifier
    @param {number|string} instance identifier
    @param {number|string} parent status identifier
    @param {varargs}
  ]]-----------------------------------------------------------------------------
  function Player:addStatusEffect(effect, instance, status, ...)
    DarkRP.getStatusEffect(effect).on_add(self, instance, ...)
    self.StatusMod.effects[instance] = {effect = effect, parent = status }
  end

  --[[---------------------------------------------------------------------------
    Removes an effect from the player
    @param {number|string} instance
  ]]-----------------------------------------------------------------------------
  function Player:removeStatusEffect( instance )
    local effect = self.StatusMod.effects[instance]
    if not effect then return end
    local on_expire = DarkRP.getStatusEffect(effect.effect).on_expire
    if on_expire then on_expire(self, instance) end
    hook.Run('playerStatusEffectRemoved', self, instance, effect.effect, effect.parent)
    if effect.parent and self.StatusMod.statuses[effect.parent] then -- remove status if all effects are gone
      self.StatusMod.statuses[effect.parent].effects[instance] = nil
      if table.Count(self.StatusMod.statuses[effect.parent].effects) <= 0 then
        self:removeStatus(effect.parent)
      end
    end
    self.StatusMod.effects[instance] = nil
  end

  --[[---------------------------------------------------------------------------
    Removes all status effects
  ]]-----------------------------------------------------------------------------
  function Player:flushStatusEffects()
    for effect, _ in pairs(self.StatusMod.effects) do
      self:removeStatusEffect(effect)
    end
  end

end

--[[---------------------------------------------------------------------------
  Default effects
]]-----------------------------------------------------------------------------
local TIMER = 'status_effect_%i_%s'

-- generic timer effect
DarkRP.addStatusEffect('timer', {
  -- TODO: add name if necessary?
  on_add = function(_player, instance, time)
    timer.Create(string.format(TIMER, _player:EntIndex(), instance), time, 1, function()
      if not _player or not IsValid(_player) then return end
      _player:removeStatusEffect(instance)
    end)
  end,
  on_expire = function(_player, instance)
    timer.Remove(string.format(TIMER, _player:EntIndex(), instance))
  end
})

-- overhealing effect
DarkRP.addStatusEffect('overheal', {
  name = DarkRP.getPhrase('overheal'),
  on_add = function( _player, instance, rate, health, max_health )
    local _timer = string.format( TIMER, _player:EntIndex(), instance )
    local _health = _player:Health() + math.min( health, max_health )

    -- check if this instance was already running
    if timer.Exists( _timer ) then
      health = timer.RepsLeft( _timer ) + health
      _health = _player:Health() - timer.RepsLeft( _timer ) + math.min( health, max_health )
    end

    -- apply overheal
    _player:SetHealth( _health )

    -- deduct overheal
    timer.Create(_timer, rate, math.min( health, max_health), function()
      if not _player or not IsValid(_player) then return end
      _player:SetHealth(math.max(_player:Health() - 1, 1))
      if timer.RepsLeft(_timer) <= 0 then
        _player:removeStatusEffect(instance)
      end
    end )
  end,

  on_expire = function(_player, instance)
    timer.Remove(string.format(TIMER, _player:EntIndex(), instance))
  end
} )

-- health regeneration
DarkRP.addStatusEffect('regeneration', {
  name = DarkRP.getPhrase('regeneration'),
  on_add = function(_player, instance, health, rate, stopOnFull)
    local _timer = string.format( TIMER, _player:EntIndex(), instance)

    -- add to the previous effect instance
    if timer.Exists(_timer) then
      health = health + timer.RepsLeft(_timer)
    end

    timer.Create( _timer, rate, health, function()
      if not _player or not IsValid(_player) then return end
      -- do not override overheal
      if _player:Health() < _player:GetMaxHealth() then
        _player:SetHealth(math.min( _player:Health() + 1, 100))
      end

      if timer.RepsLeft(_timer) <= 0 or (_player:Health() >= _player:GetMaxHealth() and stopOnFull) then
        _player:removeStatusEffect(instance)
        timer.Remove(_timer)
      end
    end)
  end,

  on_expire = function(_player, instance)
    timer.Remove(string.format( TIMER, _player:EntIndex(), instance))
  end
})

-- update the walk and run speeds
local function updateSpeed(_player)
  if not DarkRP.isStaminaModInstalled or _player:getDarkRPVar('stamina') > 0 then
    local run_speed = GAMEMODE.Config.runspeed
    if _player:isCP() then run_speed = GAMEMODE.Config.runspeedcp end
    _player:SetRunSpeed(run_speed * _player.SpeedBuff.total)
  end
  _player:SetWalkSpeed(GAMEMODE.Config.walkspeed * _player.SpeedBuff.total)
end

-- speed
DarkRP.addStatusEffect('speed', {
  name = DarkRP.getPhrase('speed'),
  unstackable = true,
  on_add = function(_player, instance, speed, duration)
    speed = 1 + ( speed * .01 ) -- convert to decimal
    if not _player.SpeedBuff then
      _player.SpeedBuff = {
        total = 1,
        instances = {}
      }
    end

    local _timer = string.format(TIMER, _player:EntIndex(), instance)
    if not timer.Exists(_timer) then
      if speed > _player.SpeedBuff.total then
        _player.SpeedBuff.total = speed
      end
      _player.SpeedBuff.instances[instance] = speed
      updateSpeed(_player)
    end

    if not duration or duration < 0 then return end
    timer.Create(_timer, duration, 1, function()
      if not _player or not IsValid(_player) then return end
      _player:removeStatusEffect(instance)
    end )
  end,

  on_expire = function(_player, instance)
    if _player.SpeedBuff.instances[instance] >= _player.SpeedBuff.total then
      local total = 1
      for i, speed in pairs( _player.SpeedBuff.instances ) do
        if speed < total or i == instance then continue end
        total = speed
      end
      _player.SpeedBuff.total = total
    end
    _player.SpeedBuff.instances[instance] = nil
    timer.Remove( string.format( TIMER, _player:EntIndex(), instance ) )
    updateSpeed( _player )
  end

} )

-- speed
DarkRP.addStatusEffect('defense', {
  name = DarkRP.getPhrase('defense'),
  on_add = function(_player, instance, mul, duration)
    -- setup table
    if not _player.DefenseBuff then
      _player.DefenseBuff = {}
    end

    -- initialize buff
    if not _player.DefenseBuff[instance] then
      _player.DefenseBuff[instance] = { count = 0, mul = mul }
    end

    -- add buff
    _player.DefenseBuff[instance].count = _player.DefenseBuff[instance].count + 1

    -- remove after time
    if not duration or duration < 0 then return end
    timer.Create(string.format(TIMER, _player:EntIndex(), instance), duration, 1, function()
      if not _player or not IsValid(_player) then return end
      _player:removeStatusEffect(instance)
    end)
  end,
  on_expire = function(_player, instance)
    -- remove one instance
    _player.DefenseBuff[instance].count = _player.DefenseBuff[instance].count - 1

    -- remove category if it's over
    if _player.DefenseBuff[instance].count <= 0 then
      _player.DefenseBuff[instance] = nil
    end
  end
} )

if SERVER then
  -- speed effect StaminaMod support
  hook.Add( 'playerRunSpeedUpdate', 'statusmod_staminamod_speed', function(_player, speed)
    if not _player.SpeedBuff then return speed end
    return speed * _player.SpeedBuff.total
  end )

  -- reduce damage input
  hook.Add('EntityTakeDamage', 'statusmod_defense', function(_player, dmginfo)
    if not _player:IsPlayer() or not _player.DefenseBuff then return end
    local mul = 1
    for _, buff in pairs(_player.DefenseBuff) do
      mul = mul * buff.mul
    end
    dmginfo:ScaleDamage(mul)
  end)
end
