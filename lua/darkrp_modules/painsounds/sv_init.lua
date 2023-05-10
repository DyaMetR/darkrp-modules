
-- how often can a player emit a pain sound
local PAIN_SOUND_DELAY = 0.4

-- damage types that do not cause a pain sound
local NO_SOUND_DMG_TYPES = { DMG_DROWN }

-- reset death sound variable
hook.Add('PlayerSpawn', 'painsounds_spawn', function(_player)
  _player.PainDeathSound = nil
end)

-- emit sound upon taking damage
hook.Add('EntityTakeDamage', 'painsounds_damage', function(_player, dmginfo)
  -- only work for players
  if not _player:IsPlayer() then return end

  -- if a damage type that shouldn't cause a sound is detected, halt process
  for _, dmgType in pairs(NO_SOUND_DMG_TYPES) do
    if dmginfo:IsDamageType(dmgType) then return end
  end

  -- select sound
  local delay = _player.NextPainSound or 0
  local model = _player:GetModel()
  local sounds = DarkRP.getPainSounds(model)

  -- death sound
  if _player:Health() <= dmginfo:GetDamage() then
    local death_sounds = DarkRP.getDeathSounds(model)
    if death_sounds then sounds = death_sounds end
    delay = 0
    _player.PainDeathSound = true
  end

  if not sounds or delay > CurTime() then return end

  _player:EmitSound(sounds[math.random(1, #sounds)], nil, nil, nil, CHAN_VOICE)
  _player.NextPainSound = CurTime() + PAIN_SOUND_DELAY
end)

-- mute beeping
hook.Add('PlayerDeathSound', 'painsounds_mute', function()
  return true
end)

-- emit generic death sound if no pain was inflicted
hook.Add('PlayerDeath', 'painsounds_death', function(_player)
  if _player.PainDeathSound then return end
  _player:EmitSound('player/pl_pain' .. math.random(5, 7) .. '.wav')
end)
