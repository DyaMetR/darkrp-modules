--[[---------------------------------------------------------------------------
  Event status indicator
]]-----------------------------------------------------------------------------

-- language
DarkRP.addPhrase('en', 'zombieapocalypse', 'Zombie apocalypse')
DarkRP.addPhrase('en', 'zombie_reward', 'Kill reward')
DarkRP.addPhrase('en', 'zombie_time', 'Collect reward in: %s')
DarkRP.addPhrase('en', 'zombie_kills', '%i kills')
DarkRP.addPhrase('en', 'zombie_timelimit', 'Apocalypse ends in %s')

-- constants
local BACKGROUND_DIST = 5

-- intro animation
local introSound = false
local titleShown = false
local y = 0 -- title relative height
local darken = 0
local delay = 0
local tick = 0 -- white background tick
local bg_x, bg_y = 0, 0 -- white background position
local colour = Color(255, 255, 255)
local bgColour = Color(255, 60, 30)

-- accumulated money
local money, kills, time = 0, 0, 0

-- fonts
surface.CreateFont('zombieapocalypse_1', {
  font = 'Akbar',
  size = ScreenScale(26)
})

surface.CreateFont('zombieapocalypse_2', {
  font = 'Akbar',
  size = 28
})

surface.CreateFont('zombieapocalypse_3', {
  font = 'Akbar',
  size = 48
})

--[[---------------------------------------------------------------------------
  Draws the intro
]]-----------------------------------------------------------------------------
local function DrawIntro()
  -- make start sound
  if not introSound then
    surface.PlaySound('ambient/creatures/town_zombie_call1.wav')
    introSound = true
  end
  -- animate
  if not titleShown then
    y = Lerp(0.07, y, 1)
    darken = Lerp(0.07, darken, 1)
    if y > 0.99 then
      delay = CurTime() + 2
      titleShown = true
    end
    colour.a = 255 * y
    bgColour.a = colour.a * .8
  else
    if delay < CurTime() then
      darken = Lerp(0.01, darken, 0)
      y = Lerp(0.01, y, 3)
    end
    colour.a = 255 * (1 - (y - 1))
    bgColour.a = colour.a * .8
  end
  if colour.a > 10 and tick < CurTime() then
    bg_x = math.random(-1, 1)
    bg_y = math.random(-1, 1)
    tick = CurTime() + 0.06
  end
  -- draw
  draw.SimpleText(DarkRP.getPhrase('zombieapocalypse'), 'zombieapocalypse_1', (ScrW() * .5) + (bg_x * BACKGROUND_DIST), ((ScrH() * 0.3) * y) + (bg_y * BACKGROUND_DIST), bgColour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  draw.SimpleText(DarkRP.getPhrase('zombieapocalypse'), 'zombieapocalypse_1', ScrW() * .5, (ScrH() * 0.3) * y, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- draw text with a shadow
local function DrawText(text, font, x, y, align)
  draw.SimpleText(text, font, x + 2, y + 2, Color(255, 80, 50, 80), align)
  draw.SimpleText(text, font, x, y, Color(255, 255, 255, 255), align)
end

--[[---------------------------------------------------------------------------
  Draw the HUD component
]]-----------------------------------------------------------------------------
hook.Add('HUDPaint', 'zombieapocalypse_hud', function()
  if not DarkRP.isZombieApocalypseActive() then
    titleShown = false
    darken = 0
    y = 0
    introSound = false
    timeleft = -1
    return
  end
  DrawIntro()

  -- draw accumulated money
  local w, h = 240, 103
  local x, y = (ScrW() * .5) - (w * .5), (ScrH() - h)
  local offset = 0

  -- if a time limit is set, make the background taller
  local countdown = GetGlobalFloat('RPZombieApocalypseEndTime') - CurTime()
  if countdown >= 0 then
    h = h + 32
    y = y - 32
    offset = 32
  end

  -- draw background
  draw.RoundedBox(6, x, y, w, h, Color(26, 4, 10, 150))

  -- draw countdown
  if countdown >= 0 then
    DrawText(DarkRP.getPhrase('zombie_timelimit', string.FormattedTime(math.max(countdown, 0), '%i:%02i')), 'zombieapocalypse_2', x + 12, y + 5)
  end

  -- draw stats
  y = y + offset
  DrawText(DarkRP.getPhrase('zombie_reward'), 'zombieapocalypse_2', x + 12, y + 5)
  DrawText(DarkRP.getPhrase('zombie_kills', kills), 'zombieapocalypse_2', x + w - 12, y + 5, TEXT_ALIGN_RIGHT)
  DrawText(DarkRP.formatMoney(money), 'zombieapocalypse_3', x + 12, y + 27)
  if time - CurTime() < 0 then return end -- draw time until next pay
  DrawText(DarkRP.getPhrase('zombie_time', string.FormattedTime(math.max(time - CurTime(), 0), '%i:%02i')), 'zombieapocalypse_2', x + 12, y + 70)
end)

--[[---------------------------------------------------------------------------
  Post processing effects
]]-----------------------------------------------------------------------------
local tab = {}
hook.Add('RenderScreenspaceEffects', 'zombieapocalypse_pp', function()
  if not DarkRP.isZombieApocalypseActive() then return end
  tab[ '$pp_colour_addr' ] = 0.06 * darken
	tab[ '$pp_colour_addg' ] = 0
	tab[ '$pp_colour_addb' ] = 0
	tab[ '$pp_colour_brightness' ] = 0 - (.33 * darken)
	tab[ '$pp_colour_contrast' ] = 1 + darken
	tab[ '$pp_colour_colour' ] = 1 - (.5 * darken)
	tab[ '$pp_colour_mulr' ] = 0.7 * darken
	tab[ '$pp_colour_mulg' ] = 0
	tab[ '$pp_colour_mulb' ] = 0
  DrawColorModify(tab)
end)

--[[---------------------------------------------------------------------------
  Receive data from server
]]-----------------------------------------------------------------------------
-- receive total kills
net.Receive('zombieapocalypse_kill', function(len)
  kills = net.ReadFloat()
end)

-- receive reward money
net.Receive('zombieapocalypse_money', function(len)
  money = net.ReadFloat()
end)

-- receive next reward time
net.Receive('zombieapocalypse_time', function(len)
  time = net.ReadFloat()
end)
