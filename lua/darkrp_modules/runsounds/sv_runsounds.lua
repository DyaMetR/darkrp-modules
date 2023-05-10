
local Player = FindMetaTable('Player')

local TABLE_TYPE = 'table'
local SNDLVL = 60
local VOLUME = .4

local sounds = {} -- sound groups
local models = {} -- what sound groups follow each model

--[[---------------------------------------------------------------------------
  Adds a set of sprinting sounds
  @param {table} sound list
  @return {number} sound group identifier
]]-----------------------------------------------------------------------------
function DarkRP.addSprintSounds(soundList)
  return table.insert(sounds, soundList)
end

--[[---------------------------------------------------------------------------
  Ties a model (or group of models) to a sprinting group
  @param {string|table} model
  @param {number} sound group identifier
]]-----------------------------------------------------------------------------
function DarkRP.setSprintSoundToModel(model, soundList)
  if type(model) == TABLE_TYPE then
    for _, mdl in pairs(model) do
      models[mdl] = soundList
    end
  else
    models[model] = soundList
  end
end

--[[---------------------------------------------------------------------------
  Emits a footstep sound by the player
]]-----------------------------------------------------------------------------
function Player:emitFootStepSound()
  local sound = sounds[models[self:GetModel()]]
  self:EmitSound(sound[math.random(1, #sound)], SNDLVL, nil, VOLUME, CHAN_BODY)
end

--[[---------------------------------------------------------------------------
  Do sounds
]]-----------------------------------------------------------------------------
hook.Add('PlayerFootstep', 'runsounds_footsteps', function(_player, pos, foot, sound, volume, rf)
  if (not _player:IsSprinting() or _player:GetVelocity():Length() <= _player:GetWalkSpeed()) or not models[_player:GetModel()] then return end
  _player:emitFootStepSound()
end)

-- jump sound
hook.Add('KeyPress', 'runsounds_jump', function(_player, key)
  if key ~= IN_JUMP or _player:GetJumpPower() <= 0 or not _player:OnGround() or (_player:IsSprinting() and _player:GetVelocity():Length() > _player:GetWalkSpeed()) or not models[_player:GetModel()] then return end
  _player:emitFootStepSound()
end)

-- hitting the ground
hook.Add('OnPlayerHitGround', 'runsounds_fall', function(_player, inWater, onFloater, speed)
  if speed <= 300 or not models[_player:GetModel()] then return end
  _player:emitFootStepSound()
end)

--[[---------------------------------------------------------------------------
  Default sounds
]]-----------------------------------------------------------------------------
-- sounds
local SOUND_COMBINE = DarkRP.addSprintSounds({
  'npc/combine_soldier/gear1.wav',
  'npc/combine_soldier/gear2.wav',
  'npc/combine_soldier/gear3.wav',
  'npc/combine_soldier/gear4.wav',
  'npc/combine_soldier/gear5.wav',
  'npc/combine_soldier/gear6.wav',
})

-- models
DarkRP.setSprintSoundToModel('models/player/combine_soldier.mdl', SOUND_COMBINE)
DarkRP.setSprintSoundToModel('models/player/combine_soldier_prisonguard.mdl', SOUND_COMBINE)
DarkRP.setSprintSoundToModel('models/player/police.mdl', SOUND_COMBINE)
DarkRP.setSprintSoundToModel('models/player/police_fem.mdl', SOUND_COMBINE)
