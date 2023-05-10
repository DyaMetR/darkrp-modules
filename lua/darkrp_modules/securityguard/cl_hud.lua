
-- constants
local TEXT_COLOUR, SHADOW_COLOUR = Color(255, 255, 255, 200), Color(0, 0, 0, 200)
local DETAILS_COLOUR = Color(255, 255, 255)
local BACKGROUND_COLOR = Color(0, 0, 0, 155)
local FOREGROUND_COLOUR = Color(51, 58, 51, 100)
local HEADER_COLOUR = Color(0, 0, 70, 100)
local TITLE_COLOUR = Color(255, 0, 0)
local BAR_BACKGROUND_COLOUR = Color(0, 0, 0, 200)
local MARGIN, PADDING, SENSOR_SIZE = 1, 16, 39
local BLINK_COLOUR, UNBLINK_COLOUR = Color(255, 255, 0), Color(255, 0, 0)
local SENSOR_COLOUR = Color(100, 125, 255, 200)
local HIGHLIGHT_TIME = 4
local BLINK_RATE = 0.15
local ANGLE_ZERO = Angle(0, 0, 0)

--[[
these are the titles that the sensors are given, it supports up to 8 names
by default max sensors are 4 so there's probably no need for the other 4 but
they're here just in case. in case you want more than 8 sensors you'll have to
increase the list
]]--
local SENSOR_IDS = {'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'dseta', 'eta', 'theta'}

-- add phrases
DarkRP.addPhrase('en', 'security_title', 'Security status')
DarkRP.addPhrase('en', 'msensor_title', 'Motion sensors: %s')
DarkRP.addPhrase('en', 'security_health', '%s\'s vital signs: %s')
DarkRP.addPhrase('en', 'security_optimal', 'Optimal')
DarkRP.addPhrase('en', 'security_fine', 'Stable')
DarkRP.addPhrase('en', 'security_hurt', 'Worrying')
DarkRP.addPhrase('en', 'security_neard', 'Critical')
DarkRP.addPhrase('en', 'security_dead', '**Flatlined**')
DarkRP.addPhrase('en', 'security_sensor', 'Sensor %s')
DarkRP.addPhrase('en', 'security_sensor_status', 'Sensor %s: %s')
DarkRP.addPhrase('en', 'security_sensor_idle', 'Idle')
DarkRP.addPhrase('en', 'security_sensor_detected', '**Movement detected**')
DarkRP.addPhrase('en', 'security_sensor_none', 'None installed')

-- variables
local damage = {}
local blink = false
local lastBlink = 0
local ply_pos, ply_yaw = Vector(0, 0, 0), Angle(0, 0, 0)

--[[---------------------------------------------------------------------------
  Draws the panel
  @param {number} x
  @param {number} y
]]-----------------------------------------------------------------------------
local function drawPanel(x, y)
  -- background
  draw.RoundedBox(10, x, y, 460, 136, BACKGROUND_COLOR) -- 110
  draw.RoundedBox(10, x + 2, y + 2, 456, 132, FOREGROUND_COLOUR)
  draw.RoundedBox(10, x + 2, y + 2, 456, 20, HEADER_COLOUR)

  -- title
  draw.DrawNonParsedText(DarkRP.getPhrase('security_title'), 'DarkRPHUD1', x + 20, y + 2, TITLE_COLOUR, 0)

  -- draw client's vital signs
  local client = LocalPlayer():getSecurityContractTarget()
  local signs = DarkRP.getPhrase('security_optimal')
  if client:Alive() then
    if client:Health() >= 70 and client:Health() < 90 then
      signs = DarkRP.getPhrase('security_fine')
    elseif client:Health() > 30 and client:Health() < 70 then
      signs = DarkRP.getPhrase('security_hurt')
    elseif client:Health() <= 30 then
      signs = DarkRP.getPhrase('security_neard')
    end
  else
    signs = DarkRP.getPhrase('security_dead')
  end
  draw.DrawNonParsedText(DarkRP.getPhrase('security_health', client:Name(), signs), 'DarkRPHUD1', x + 20, y + 25, DETAILS_COLOUR, 0)

  -- motion sensors
  local sensors = DarkRP.getMotionSensors()
  local text = DarkRP.getPhrase('security_sensor_none')
  if table.Count(sensors) > 0 then
    text = '\n'
    local i = 1
    for _, index in pairs(sensors) do
      local sensor = ents.GetByIndex(index)
      local status = DarkRP.getPhrase('security_sensor_idle')
      if sensor:GetDetected() then status = DarkRP.getPhrase('security_sensor_detected') end
      text = text .. DarkRP.getPhrase('security_sensor_status', SENSOR_IDS[i], status) .. '\n'
      i = i + 1
    end
  end

  -- draw motion sensors
  draw.DrawNonParsedText(DarkRP.getPhrase('msensor_title', text), 'DarkRPHUD1', x + 20, y + 42, DETAILS_COLOUR, 0)
end

--[[---------------------------------------------------------------------------
  Draws an entity dot
  @param {Vector} pos
  @param {Color} colour
  @param {boolean} should blink
  @param {string} label
  @param {string} font
  @param {boolean} whether the text should cast a shadow
]]-----------------------------------------------------------------------------
local function drawDot(pos, colour, blinking, label, font, shadow)
  local scn = pos:ToScreen()
  local x, y, onScreen = scn.x, scn.y, scn.visible

  -- if blinking and not on screen, switch places
  if blinking and not onScreen then
    local ang = -WorldToLocal(pos, ANGLE_ZERO, ply_pos, ply_yaw):Angle().y
    x = (ScrW() * 0.5) + math.cos(math.rad(ang - 90)) * (ScrH() * .25)
    y = (ScrH() * 0.5) + math.sin(math.rad(ang - 90)) * (ScrH() * .25)
  end

  -- draw dot
  if not blinking then
    draw.RoundedBox(10, x - 8, y - 8, 16, 16, colour)
  else
    if blink then
      colour = BLINK_COLOUR
    else
      colour = UNBLINK_COLOUR
    end
    draw.RoundedBox(12, x - 10, y - 10, 20, 20, colour)
  end

  -- draw text
  if not label then return end
  if shadow then draw.SimpleText(label, font, x + 1, y + 19, SHADOW_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
  draw.SimpleText(label, font, x, y + 18, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--[[---------------------------------------------------------------------------
  Draws the client's health
]]-----------------------------------------------------------------------------
local lastHealth = 100
local clientBlink = 0
local function drawClient()
  local client = LocalPlayer():getSecurityContractTarget()
  local pos = client:GetPos()
  pos.z = pos.z + 36

  -- get damage
  if lastHealth ~= client:Health() then
    if lastHealth > client:Health() then
      clientBlink = CurTime() + HIGHLIGHT_TIME
    end
    lastHealth = client:Health()
  end

  -- colour
  local mul = math.Clamp((client:Health() - 20) / 80, 0, 1)
  local colour = Color(255 * (1 - math.max((mul - .5) * 2, 0)), 140 * math.min(mul * 2, 1), 0, 180)
  if not client:Alive() then colour = SHADOW_COLOUR end

  -- draw
  drawDot(pos, colour, clientBlink > CurTime() and client:Alive(), client:Name(), 'ChatFont')
end

--[[---------------------------------------------------------------------------
  Draws the client's entities
  @param {table} entities
]]-----------------------------------------------------------------------------
local function drawEntities(entities)
  if table.Count(entities) <= 0 then return end

  local i = 0
  for index, health in pairs(entities) do
    local ent = ents.GetByIndex(index)
    if not IsValid(ent) then continue end

    -- remove blinking if time runs out
    if damage[index] and damage[index] < CurTime() then
      damage[index] = nil
    end

    -- colour
    local mul = math.Clamp((health - .2) / .8, 0, 1)
    local colour = Color(255 * (1 - math.max((mul - .5) * 2, 0)), 140 * math.min(mul * 2, 1), 0, 180)

    -- draw
    drawDot(ent:GetPos(), colour, damage[index], ent.PrintName, 'DefaultSmall', true)
  end
end

--[[---------------------------------------------------------------------------
  Draws the motion sensors status
  @param {table} sensors
]]-----------------------------------------------------------------------------
local function drawSensors(sensors)
  i = 1
  for _, index in pairs(sensors) do
    local sensor = ents.GetByIndex(index)
    if not IsValid(sensor) then continue end
    drawDot(sensor:GetPos(), SENSOR_COLOUR, sensor:GetDetected(), DarkRP.getPhrase('security_sensor', string.upper(SENSOR_IDS[i])), 'DarkRPHUD1')
    i = i + 1
  end
end

--[[---------------------------------------------------------------------------
  Draws the whole HUD
]]-----------------------------------------------------------------------------
hook.Add('HUDPaint', 'securityguard_hud', function()
  local contract = LocalPlayer():getSecurityContractTarget()
  if not LocalPlayer().isSecurityGuard or not LocalPlayer():isSecurityGuard() or not contract then return end

  -- get height and tables
  local h = 0
  local entities, sensors = DarkRP.getSecurityTrackedEntities(), DarkRP.getMotionSensors()

  -- entities
  if table.Count(entities) > 0 then
    h = MARGIN + (table.Count(entities) * PADDING)
  end

  -- sensors
  if table.Count(sensors) <= 0 then
    h = h + SENSOR_SIZE
  end

  -- animate blinking
  if lastBlink < CurTime() then
    blink = not blink
    lastBlink = CurTime() + BLINK_RATE
  end

  -- get player pos and angle components we need
  ply_pos.x = LocalPlayer():GetPos().x
  ply_pos.y = LocalPlayer():GetPos().y
  ply_yaw.y = LocalPlayer():EyeAngles().y

  -- draw panel
  drawPanel(10, 10)

  -- draw client health
  drawClient()

  -- draw entities
  drawEntities(entities)

  -- draw sensors
  if table.Count(sensors) <= 0 then return end
  drawSensors(sensors)
end)

--[[---------------------------------------------------------------------------
  Gets the updated entities
  @param {number} entity index
  @param {number} old health value
  @param {number} health
]]-----------------------------------------------------------------------------
hook.Add('securityEntityUpdated', 'securityguard_entdamage', function(entIndex, oldHealth, health)
  if oldHealth < health then return end
  damage[entIndex] = CurTime() + HIGHLIGHT_TIME
end)
