-- constants
local FONT = 'DefaultSmall'
local BORDER = 3
local TEXT_COLOUR, STARVE_COLOUR = Color( 255, 255, 255 ), Color( 140, 0, 0 )
local BACKGROUND_COLOUR, FOREGROUND_COLOUR = Color( 0, 0, 0 ), Color( 30, 30, 120 )
local FORMAT = '%i%%'

-- add starving phrase
DarkRP.addPhrase('en', 'starving', 'Starving!')

-- paint HUD
hook.Add('HUDPaint', 'hungermodplus_hud', function()

  if hook.Run('HUDShouldDraw', 'DarkRP_HungerMod+') == false then return end

  -- size
  local w, h = 200, 7
  local x, y = 5, ScrH() - h

  -- energy variable
  local energy = LocalPlayer():getDarkRPVar('Energy') or 100

  -- draw bar
  draw.RoundedBox(BORDER, x, y, w, h, BACKGROUND_COLOUR)
  draw.RoundedBox(BORDER, x + 1, y + 1, (w - 2) * energy * .01, h - 2, FOREGROUND_COLOUR)

  -- get text colour and contents
  local text, colour = string.format(FORMAT, energy), TEXT_COLOUR
  if energy <= 0 then
    text = DarkRP.getPhrase('starving')
    colour = STARVE_COLOUR
  end

  -- draw text
  draw.SimpleText(text, FONT, x + (w * .5), y + math.floor(h * .5), colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

end)
