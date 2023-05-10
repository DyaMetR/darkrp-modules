--[[---------------------------------------------------------------------------
  Settings
]]-----------------------------------------------------------------------------

-- zombieWeaponDispenserCooldown - How often can players buy from the dispenser
GAMEMODE.Config.zombieWeaponDispenserCooldown = 30

-- zombieMaxAmmo - Maximum ammunition received from kill streaks
GAMEMODE.Config.zombieMaxAmmo = 30

if SERVER then
  -- in-game configuration
  CreateConVar('zombie_weaponspawner', 0, FCVAR_NONE, 'Spawn a weapon dispenser when a zombie apocalypse starts.')
  CreateConVar('zombie_removeonend', 0, FCVAR_ARCHIVE, 'Removes all previously spawned enemies when the apocalypse ends.')
  CreateConVar('zombie_rate', 5, FCVAR_ARCHIVE, 'How often are enemies spawned.')
  CreateConVar('zombie_max', 30, FCVAR_ARCHIVE, 'How many enemies can be spawned at once.')
  CreateConVar('zombie_reward', 180, FCVAR_ARCHIVE, 'How often a player collects their rewards.')
  CreateConVar('zombie_cheapspawn', 0, FCVAR_ARCHIVE, 'Whether a new spawn is searched for an enemy in case their designated one is occupied (otherwise that NPC instance is discarded).')

  --[[---------------------------------------------------------------------------
    Whether a weapon dispenser should be spawned when a zombie invasion starts
    @return {boolean} should spawn
  ]]-----------------------------------------------------------------------------
  function DarkRP.shouldSpawnZombieWeaponDispenser()
    return GetConVar('zombie_weaponspawner'):GetBool()
  end

  --[[---------------------------------------------------------------------------
    Whether enemies should be removed when a zombie invasion ends
    @return {boolean} should remove
  ]]-----------------------------------------------------------------------------
  function DarkRP.shouldRemoveZombiesOnEnd()
    return GetConVar('zombie_removeonend'):GetBool()
  end

  --[[---------------------------------------------------------------------------
    How often are enemies spawned
    @return {number} spawn rate
  ]]-----------------------------------------------------------------------------
  function DarkRP.getZombieSpawnRate()
    return GetConVar('zombie_rate'):GetFloat()
  end

  --[[---------------------------------------------------------------------------
    How many enemies can be spawned at once
    @return {number} maximum enemies at once
  ]]-----------------------------------------------------------------------------
  function DarkRP.getMaxZombies()
    return GetConVar('zombie_max'):GetInt()
  end

  --[[---------------------------------------------------------------------------
    How often players collect their rewards
    @return {number} time to collect rewards
  ]]-----------------------------------------------------------------------------
  function DarkRP.getZombieRewardRate()
    return GetConVar('zombie_reward'):GetFloat()
  end

  --[[---------------------------------------------------------------------------
    Whether 'cheap spawns' is enabled
    @return {boolean} cheap spawns enabled
  ]]-----------------------------------------------------------------------------
  function DarkRP.isZombieCheapSpawningEnabled()
    return GetConVar('zombie_cheapspawn'):GetBool()
  end
end
