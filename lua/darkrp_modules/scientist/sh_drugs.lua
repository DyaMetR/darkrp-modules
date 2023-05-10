
local NET = 'cocaine_paranoia'

if SERVER then util.AddNetworkString(NET) end

-- phrases
DarkRP.addPhrase('en', 'cocaine', 'Cocaine')
DarkRP.addPhrase('en', 'cocaine_desc', 'Physical performance greately increased. Better recoil control. Paranoia.')
DarkRP.addPhrase('en', 'meth', 'Methanphetamine')
DarkRP.addPhrase('en', 'meth_desc', 'Speed and stamina increased.')
DarkRP.addPhrase('en', 'lsd', 'Acid trip')
DarkRP.addPhrase('en', 'lsd_desc', 'Can sense nearby relevant entities.')
DarkRP.addPhrase('en', 'mushroom', 'Mushrooms')
DarkRP.addPhrase('en', 'mushroom_desc', 'Intoxicated by hallucinogenic mushrooms.')
DarkRP.addPhrase('en', 'weed', 'Marijuana')
DarkRP.addPhrase('en', 'weed_desc', 'Defense increased.')
DarkRP.addPhrase('en', 'heroin', 'Heroin')
DarkRP.addPhrase('en', 'heroin_desc', 'Defense greately increased. You will surely miss it.')
DarkRP.addPhrase('en', 'heroin_addiction', 'Heroin addiction')
DarkRP.addPhrase('en', 'heroin_addiction_desc', 'Maximum health and defense reduced.')

--[[---------------------------------------------------------------------------
  Add status effects
]]-----------------------------------------------------------------------------
DarkRP.DARKRP_LOADING = true

-- cocaine effect
DarkRP.addStatus('cocaine', {
  name = DarkRP.getPhrase('cocaine'),
  desc = DarkRP.getPhrase('cocaine_desc'),
  icon = Material('icon16/lightning_add.png'),
  effects = {
    ['overheal'] = { 1.5, 80, 80 },
    ['stamina'] = { 200, 60 },
    ['speed'] = { 50, 60 }
  },
  on_add = function(_player, instance)
    _player:SetHealth(math.max(_player:Health() - 40, 1))
    if SERVER then
      net.Start(NET)
      net.WriteBool(true)
      net.Send(_player)
    end
  end,
  on_expire = function(_player, instance)
    if SERVER then
      net.Start(NET)
      net.WriteBool(false)
      net.Send(_player)
    end
  end
})

-- methanphetamine effect
DarkRP.addStatus('meth', {
  name = DarkRP.getPhrase('meth'),
  desc = DarkRP.getPhrase('meth_desc'),
  icon = Material('icon16/lightning.png'),
  effects = {
    ['overheal'] = { 3, 55, 55 },
    ['stamina'] = { 160, 180 },
    ['speed'] = { 30, 180 }
  },
  on_add = function(_player, instance)
    _player:SetHealth(math.max(_player:Health() - 30, 1))
  end
})

-- LSD effect
DarkRP.addStatus('lsd', {
  name = DarkRP.getPhrase('lsd'),
  desc = DarkRP.getPhrase('lsd_desc'),
  icon = Material('icon16/color_wheel.png'),
  effects = {
    ['timer'] = { 120 }
  }
})

-- mushrooms effect
DarkRP.addStatus('mushroom', {
  name = DarkRP.getPhrase('mushroom'),
  desc = DarkRP.getPhrase('mushroom_desc'),
  icon = Material('icon16/error.png'),
  effects = {
    ['timer'] = { 90 }
  }
})

-- weed effect
DarkRP.addStatus('weed', {
  name = DarkRP.getPhrase('weed'),
  desc = DarkRP.getPhrase('weed_desc'),
  icon = Material('icon16/weather_clouds.png'),
  effects = {
    ['overheal'] = { 5, 45, 45 },
    ['defense'] = { 0.85, 120 }
  },
  on_add = function(_player, instance)
    _player:SetHealth(math.max(_player:Health() - 20, 1))
  end
})

-- heroin effect
DarkRP.addStatus('heroin', {
  name = DarkRP.getPhrase('heroin'),
  desc = DarkRP.getPhrase('heroin_desc'),
  icon = Material('icon16/pill_add.png'),
  effects = {
    ['defense'] = { 0.65, 120 }
  },
  on_add = function(_player, instance)
    if not _player:hasStatus('heroin_addiction') then
      _player:addStatusEffect('overheal', 'heroin', 'heroin', 2, 150, 150)
    else
      _player:addStatusEffect('overheal', 'heroin', 'heroin', 1.25, 75, 75)
    end
    _player:SetHealth(math.max(_player:Health() - 50, 1))
    _player:SetMaxHealth(GAMEMODE.Config.startinghealth * .5)
  end,
  on_expire = function(_player, instance)
    if not _player:Alive() then return end
    _player:addStatus('heroin_addiction', 'heroin_addiction')
  end
})

-- addiction debuff
DarkRP.addStatus('heroin_addiction', {
  name = DarkRP.getPhrase('heroin_addiction'),
  desc = DarkRP.getPhrase('heroin_addiction_desc'),
  icon = Material('icon16/pill_delete.png'),
  effects = {
    ['defense'] = { 1.25, 1800 }
  },
  on_add = function(_player, instance)
    _player:SetMaxHealth(GAMEMODE.Config.startinghealth * .5)
  end,
  on_expire = function(_player, instance)
    _player:SetMaxHealth(GAMEMODE.Config.startinghealth)
  end
})

DarkRP.DARKRP_LOADING = nil

if SERVER then

  local INGREDIENT_CLASS = 'spawned_ingredient'

  -- removes all of a players' ingredients
  local function removeAllIngredients(_player)
    if oldTeam == TEAM_SCIENTIST then
      for _, ent in pairs(ents.GetAll()) do
        if ent:GetClass() == INGREDIENT_CLASS and ent:Getowning_ent() == _player then
          ent:Remove()
        end
      end
    end
  end

  -- persist maximum health penalty between jobs
  hook.Add('PlayerChangedTeam', 'drugs_changeteam', function(_player, oldTeam, newTeam)
    -- remove all ingredients
    removeAllIngredients(_player)
    -- reset heroin addiction when player changes teams
    if not _player:hasStatus('heroin_addiction') then return end
    timer.Simple(0.1, function()
      _player:SetMaxHealth(GAMEMODE.Config.startinghealth * .5)
    end)
  end)

  -- remove all ingredients on disconnect
  hook.Add('PlayerDisconnected', 'drugs_disconnect', function(_player)
    removeAllIngredients(_player)
  end)

  -- make guns more controllable when being on coke
  hook.Add('IGFLScaleRecoil', 'drugs_recoil', function(_player, weapon)
    if IsValid(weapon) and IsValid(_player) and _player.hasStatus and not _player:hasStatus('cocaine') then return end
    return 0.75
  end)

end

if CLIENT then

  local PARANOIA_SOUNDS = {
    'Weapon_Pistol.Single',
    'Weapon_357.Single',
    'Weapon_SMG1.Single',
    'Weapon_AR2.Single',
    'Weapon_Shotgun.Single',
    'Weapon_Crossbow.Single',
    'Weapon_Glock18.Single',
    'Weapon_USP.Single',
    'Weapon_P228.Single',
    'Weapon_Fiveseven.Single',
    'Weapon_Deagle.Single',
    'Weapon_Mac10.Single',
    'Weapon_TMP.Single',
    'Weapon_MP5.Single',
    'Weapon_UMP45.Single',
    'Weapon_P90.Single',
    'Weapon_M3.Single',
    'Weapon_XM1014.Single',
    'Weapon_Famas.Single',
    'Weapon_Galil.Single',
    'Weapon_M4A1.Single',
    'Weapon_AK47.Single',
    'Weapon_SG552.Single',
    'Weapon_AUG.Single',
    'Weapon_SG550.Single',
    'Weapon_G3SG1.Single',
    'Weapon_Scout.Single',
    'Weapon_AWP.Single',
    'Weapon_M249.Single',
    'NPC.ButtonBlip2',
    'NPC.ButtonLatchLocked2',
    'Buttons.LatchUnlocked1',
    'Town.d1_town_01_lightswitch2',
    'Buttons.snd15'
  }
  local PARANOIA_TIMER = 'cocaine_paranoia'
  local PARANOIA_TICK = 8

  --[[---------------------------------------------------------------------------
    Adds a sound to be heard when a player consumes cocaine
    @param {string} sound
  ]]-----------------------------------------------------------------------------
  function DarkRP.addCocaineParanoiaSound(sound)
    table.insert(PARANOIA_SOUNDS, sound)
  end

  -- receive paranoia loop
  net.Receive(NET, function(len)
    local start = net.ReadBool()
    if start then
      timer.Create(PARANOIA_TIMER, PARANOIA_TICK, 0, function()
        LocalPlayer():EmitSound(PARANOIA_SOUNDS[math.random(1, #PARANOIA_SOUNDS)])
      end)
    else
      timer.Remove(PARANOIA_TIMER)
    end
  end)

end
