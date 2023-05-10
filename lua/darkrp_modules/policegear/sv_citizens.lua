--[[---------------------------------------------------------------------------
  Citizen danger level adaption
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

-- registered police teams
local police = {}

-- registered weapons
local weapons = {} -- weapons per danger level
local _weapons = {} -- all weapons and their danger levels

-- registered police gear for the each danger level
local gear = {} -- gear per danger level
local _gear = {} -- all of the gear available

-- ammunition granted for each danger level
local ammo = {}

-- potentially dangerous citizens
local citizens = {}

--[[---------------------------------------------------------------------------
  Returns the list of dangerous citizens
  @return {table} citizens
]]-----------------------------------------------------------------------------
function DarkRP.getDangerousCitizens()
  return citizens
end

--[[---------------------------------------------------------------------------
  Registers a team to acquire the police gear
  @param {number} team
]]-----------------------------------------------------------------------------
function DarkRP.addPoliceGearTeam(team)
  police[team] = true
end

--[[---------------------------------------------------------------------------
  Whether the player's team allows them to get police gear
  @return {boolean} can acquire
]]-----------------------------------------------------------------------------
function Player:canGetPoliceGear()
  return police[self:Team()]
end

--[[---------------------------------------------------------------------------
  Adds a list of weapons of a danger level
  Follows a { [weapon_class] = true } structure
  @param {number} danger level
  @param {table} weapons
]]-----------------------------------------------------------------------------
function DarkRP.addDangerLevelWeapons(danger_level, weps)
  -- add weapon per danger level
  if not weapons[danger_level] then
    weapons[danger_level] = weps
  else
    for weapon_class, _ in pairs(weps) do
      weapons[danger_level][weapon_class] = true
    end
  end

  -- add weapons to general
  for weapon_class, _ in pairs(weps) do
    _weapons[weapon_class] = danger_level
  end
end

--[[---------------------------------------------------------------------------
  Adds police gear for a danger level
  Follows a { [weapon_class] = true } structure
  @param {number} danger level
  @param {table} weapons
]]-----------------------------------------------------------------------------
function DarkRP.addDangerLevelGear(danger_level, _weapons)
  -- add gear to danger level
  if not gear[danger_level] then
    gear[danger_level] = _weapons
  else
    for weapon_class, _ in pairs(_weapons) do
      gear[danger_level][weapon_class] = true
    end
  end

  -- add gear to general
  for weapon_class, _ in pairs(_weapons) do
    _gear[weapon_class] = true
  end
end

--[[---------------------------------------------------------------------------
  Adds ammunition amounts for each danger level
  @param {number} danger level
  @param {table} ammunition types (and their amounts)
]]-----------------------------------------------------------------------------
function DarkRP.addDangerLevelAmmo(danger_level, _ammo)
  if not ammo[danger_level] then
    ammo[danger_level] = _ammo
  else
    for ammo_type, amount in pairs(_ammo) do
      ammo[danger_level][ammo_type] = amount
    end
  end
end

--[[---------------------------------------------------------------------------
  Gives ammunition to the player based on the danger level
  @param {number|nil} danger level
  @return {boolean} ammo was replenished
]]-----------------------------------------------------------------------------
function Player:updatePoliceGearAmmo(danger_level )
  if not self:isCP() then return end
  local replenished = false
  if danger_level then
    for ammo_type, amount in pairs(ammo[danger_level]) do
      if self:GetAmmoCount(ammo_type) >= amount then continue end
      self:SetAmmo(amount, ammo_type)
      replenished = true
    end
  else
    for danger, _ in pairs(citizens) do
      for ammo_type, amount in pairs(ammo[danger]) do
        if self:GetAmmoCount(ammo_type) >= amount then continue end
        self:SetAmmo(amount, ammo_type)
        replenished = true
      end
    end
  end
  return replenished
end

--[[---------------------------------------------------------------------------
  Adjusts the additional police gear of the player to the given table
  @param {number} danger level
]]-----------------------------------------------------------------------------
function Player:updatePoliceGear(danger_level)
  if citizens[danger_level] then -- if the danger level is new, update gear
    -- give weapons
    for weapon_class, _ in pairs(gear[danger_level]) do
      if self:HasWeapon(weapon_class) then continue end
      self:Give( weapon_class )
    end

    -- set ammo
    self:updatePoliceGearAmmo()
  else -- if the danger level is gone, remove weapons
    for _, weapon in pairs(self:GetWeapons()) do
      if gear[danger_level][weapon:GetClass()] then
        self:StripWeapon(weapon:GetClass())
      end
    end
  end
end

--[[---------------------------------------------------------------------------
  Adjusts all police member's gear to the given danger level
  @param {number} danger level
]]-----------------------------------------------------------------------------
function DarkRP.updatePoliceGear( danger_level )
  for _, _player in pairs(player.GetAll()) do
    if not _player:canGetPoliceGear() then continue end
    -- update gear
    _player:updatePoliceGear(danger_level)
  end
end

--[[---------------------------------------------------------------------------
  Called when a non-CP class player picks up a weapon; registers a dangerous citizen
  @param {Player} player
  @param {string} weapon class
]]-----------------------------------------------------------------------------
function DarkRP.citizenPicksUpWeapon(_player, weapon_class)
  if _player:isCP() or not _weapons[weapon_class] then return end
  local danger = _weapons[weapon_class]

  -- create category
  if not citizens[danger] then
    citizens[danger] = {}
    DarkRP.updatePoliceGear(danger)
  end

  -- add player
  if not citizens[danger][_player] then
    citizens[danger][_player] = {}
  end

  -- add weapon
  citizens[danger][_player][weapon_class] = true
end

--[[---------------------------------------------------------------------------
  Called when a non-CP class player drops a weapon; changes danger level
  @param {Player} player
  @param {string} weapon class
]]-----------------------------------------------------------------------------
function DarkRP.citizenDropsWeapon(_player, weapon_class)

  if (_player.isCP and _player:isCP()) or not _weapons[weapon_class] then return end

  local danger = _weapons[weapon_class]

  -- remove weapon
  citizens[danger][_player][weapon_class] = nil

  -- remove player from list
  if table.Count(citizens[danger][_player]) <= 0 then
    citizens[danger][_player] = nil
  end

  -- remove danger level
  if table.Count(citizens[danger]) <= 0 then
    citizens[danger] = nil
    DarkRP.updatePoliceGear(danger)
  end
end

--[[---------------------------------------------------------------------------
  Clears all traces of the given player in the dangerous citizens list
  @param {Player} player
]]-----------------------------------------------------------------------------
function DarkRP.clearCitizenDangerLevel(_player)

  if _player:isCP() then return end

  for danger, players in pairs(citizens) do
    if not players[_player] then continue end
    citizens[danger][_player] = nil

    -- check if the category is empty
    if table.Count(citizens[danger]) <= 0 then
      citizens[danger] = nil
      DarkRP.updatePoliceGear( danger )
    end
  end
end

--[[---------------------------------------------------------------------------
  Add default values
]]-----------------------------------------------------------------------------

-- add police teams
DarkRP.addPoliceGearTeam( TEAM_POLICE )
DarkRP.addPoliceGearTeam( TEAM_CHIEF )

-- danger levels
local DANGER_HEAVY = 0
--local DANGER_SNIPER = 1

-- add dangerous weapons
DarkRP.addDangerLevelWeapons( DANGER_HEAVY, {
  ['igfl_ak47'] = true,
  ['igfl_ar2'] = true,
  ['igfl_aug'] = true,
  ['igfl_famas'] = true,
  ['igfl_galil'] = true,
  ['igfl_m4a1'] = true,
  ['igfl_m249'] = true,
  ['igfl_mac10'] = true,
  ['igfl_mp5'] = true,
  ['igfl_mp7'] = true,
  ['igfl_p90'] = true,
  ['igfl_sg552'] = true,
  ['igfl_tmp'] = true,
  ['igfl_ump45'] = true,
  ['igfl_scout'] = true,
  ['igfl_awp'] = true,
  ['igfl_g3sg1'] = true,
  ['igfl_sg550'] = true,
  ['igfl_m3super90'] = true,
  ['igfl_xm1014'] = true,
  ['igfl_spas12'] = true
} )

--[[DarkRP.addDangerLevelWeapons( DANGER_SNIPER, {
  ['igfl_scout'] = true,
  ['igfl_awp'] = true,
  ['igfl_g3sg1'] = true,
  ['igfl_sg550'] = true
} )]]

-- add gear
DarkRP.addDangerLevelGear( DANGER_HEAVY, { ['cp_smg'] = true } )
DarkRP.addDangerLevelAmmo( DANGER_HEAVY, { ['smg1'] = 135 } )
--[[DarkRP.addDangerLevelGear( DANGER_SNIPER, { ['cp_sniper'] = true } )
DarkRP.addDangerLevelAmmo( DANGER_SNIPER, { ['SniperRound'] = 30 } )]]
