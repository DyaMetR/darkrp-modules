--[[---------------------------------------------------------------------------
  Lockdown gear and overwatch conversion of CPs
]]-----------------------------------------------------------------------------

local Player = FindMetaTable('Player')

-- jobs affected by the lockdown and their info
local jobs = {}

--[[---------------------------------------------------------------------------
  Registers a team to have a custom condition when a lockdown starts
  @param {number} team
  @param {string|table} model/s
  @param {number} skin
  @param {string} custom job name
  @param {table} weapons to give
  @param {table} ammunition to give
]]-----------------------------------------------------------------------------
function DarkRP.registerLockdownTeam(team, model, skin, jobname, weapons, ammo)
  jobs[team] = { model = model, skin = skin, jobname = jobname, weapons = weapons, ammo = ammo }
end

--[[---------------------------------------------------------------------------
  Returns the lockdown data of a team
  @param {number} team
  @return {table} data
]]-----------------------------------------------------------------------------
function DarkRP.getLockdownTeam(team)
  return jobs[team]
end

-- utility function that just gives the weapons/ammo part
function DarkRP.giveLockdownWeapons(_player)
  local data = jobs[_player:Team()]
  -- give weapons
  if data.weapons then
    for _, weapon_class in pairs(data.weapons) do
      _player:Give(weapon_class)
    end
  end

  -- set ammo
  if data.ammo then
    for ammo_type, amount in pairs(data.ammo) do
      if _player:GetAmmoCount(ammo_type) > amount then continue end
      _player:SetAmmo(amount, ammo_type)
    end
  end

end

--[[---------------------------------------------------------------------------
  Applies the custom lockdown conditions to the player
]]-----------------------------------------------------------------------------
function Player:applyLockdownGear()
  if not jobs[self:Team()] or self.PreLockdown then return end
  self.PreLockdown = { model = self:GetModel(), jobname = self:getDarkRPVar( 'job' ), skin = self:GetSkin() }
  local data = jobs[self:Team()]

  -- apply model
  self:applyLockdownModel()

  -- set job name
  if data.jobname then
    self:setSelfDarkRPVar('job', data.jobname)
    self:setDarkRPVar('job', data.jobname)
  end

  DarkRP.giveLockdownWeapons(self)
end

--[[---------------------------------------------------------------------------
  Applies the model and skin of their designated lockdown variant
]]-----------------------------------------------------------------------------
function Player:applyLockdownModel()
  local data = jobs[self:Team()]
  local model = data.model

  -- check if the model is a table
  if model and type(model) == 'table' then
    model = model[math.random(1, table.Count(model))]
  end

  -- set model
  if model then self:SetModel( model ) end

  -- set skin
  if data.skin then self:SetSkin(data.skin) end
end

--[[---------------------------------------------------------------------------
  Reverts the lockdown gear given
]]-----------------------------------------------------------------------------
function Player:revertLockdownGear()
  -- check if it's a valid team
  if not jobs[self:Team()] then
    -- check if the player switched from CP in the middle of the lockdown
    if self.PreLockdown then self.PreLockdown = nil end
    return
  end

  self:SetSkin(self.PreLockdown.skin)
  self:SetModel(self.PreLockdown.model)
  self:setDarkRPVar('job', self.PreLockdown.jobname)

  -- remove weapons
  for _, weapon_class in pairs(jobs[self:Team()].weapons) do
    self:StripWeapon(weapon_class)
  end

  self.PreLockdown = nil
end

--[[---------------------------------------------------------------------------
  Add default values
]]-----------------------------------------------------------------------------
DarkRP.registerLockdownTeam(TEAM_POLICE, 'models/player/combine_soldier.mdl', nil, 'Overwatch Soldier', { 'ow_rifle', 'weapon_frag' }, { ['AR2'] = 60, ['Grenades'] = 2 })
DarkRP.registerLockdownTeam(TEAM_CHIEF, 'models/player/combine_soldier.mdl', 1, 'Overwatch Commander', { 'ow_shotgun', 'weapon_frag' }, { ['Buckshot'] = 24, ['Grenades'] = 3 })
