
local TIMER = 'status_effect_%i_%s'

DarkRP.addPhrase('en', 'stamina', 'Stamina increase')

DarkRP.DARKRP_LOADING = true

-- stamina buff effect
DarkRP.addStatusEffect('stamina', {
  name = DarkRP.getPhrase('stamina'),
  unstackable = true,
  on_add = function( _player, instance, stamina, time )
    local _timer = string.format( TIMER, _player:EntIndex(), instance )

    -- create table if not existant
    if not _player.StaminaBuff then
      _player.StaminaBuff = {
        total = 0,
        greater = '',
        instances = {}
      }
    end

    -- add
    _player.StaminaBuff.instances[instance] = stamina
    if stamina > _player.StaminaBuff.total then
      _player.StaminaBuff.total = stamina
      _player.StaminaBuff.greater = instance
    end

    -- expire over time
    timer.Create(_timer, time, 1, function()
      _player:removeStatusEffect(instance)
    end )
  end,

  on_expire = function(_player, instance)
    timer.Remove(string.format(TIMER, _player:EntIndex(), instance))
    _player.StaminaBuff.instances[instance] = nil

    -- find new greatest stamina buff
    if _player.StaminaBuff.greater == instance then
      _player.StaminaBuff.total = 0
      for i, stamina in pairs(_player.StaminaBuff.instances) do
        if i ~= instance and stamina > _player.StaminaBuff.total then
          _player.StaminaBuff.total = stamina
          _player.StaminaBuff.greater = i
        end
      end
    end
  end
} )

DarkRP.DARKRP_LOADING = nil

if SERVER then

  hook.Add('playerFatigue', 'staminamod_statusmod', function(_player, stamina, oxygen)
    if not _player.StaminaBuff then return end
    _player.Fatigue = math.min(_player.Fatigue * (100 + _player.StaminaBuff.total) * .01, 1)
  end)

end
