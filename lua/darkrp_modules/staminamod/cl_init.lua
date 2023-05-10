
local HEIGHT = 7
local BORDER = 3
local WARN_COLOUR = Color( 140, 0, 0 )
local BACKGROUND_COLOUR = Color( 0, 0, 0 )
local STAMINA_COLOUR = Color( 220, 200, 170 )
local OXYGEN_COLOUR = Color( 140, 180, 180 )

-- add phrases
DarkRP.addPhrase( 'en', 'drowning', 'Drowning!' )
DarkRP.addPhrase( 'en', 'exhausted', 'Exhausted!' )

--[[---------------------------------------------------------------------------
  Draws a progress bar
  @param {number} x
  @param {number} y
  @param {number} value
  @param {number} text to display when value is 0
  @param {Color} bar colour
]]-----------------------------------------------------------------------------
local function drawBar(x, y, value, text, colour)
  local w = 200
  draw.RoundedBox(BORDER, x, y, w, HEIGHT, BACKGROUND_COLOUR)
  draw.RoundedBox(BORDER, x + 1, y + 1, (w - 2) * value, HEIGHT - 2, colour)

  if value <= .01 then
    draw.SimpleText(text, 'DefaultSmall', x + (w * .5), y + math.floor(HEIGHT * .5), WARN_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
end

-- draw bars on HUD
local _stamina = 1
local _oxygen = 1
hook.Add('HUDPaint', 'staminamod_hud', function()
  -- pos
  local x, y = 5, ScrH() - 85

  -- soften variables
  _stamina = Lerp(0.1, _stamina, (LocalPlayer():getDarkRPVar('stamina') or 100) * .01)
  _oxygen = Lerp(0.1, _oxygen, (LocalPlayer():getDarkRPVar('oxygen') or 100) * .01)

  -- draw stamina
  if _stamina < 0.99 then
    drawBar(x, y, math.max(_stamina, 0), DarkRP.getPhrase('exhausted'), STAMINA_COLOUR)
    y = y - HEIGHT
  end

  -- draw oxygen
  if _oxygen < 0.99 then
    drawBar(x, y, _oxygen, DarkRP.getPhrase('drowning'), OXYGEN_COLOUR)
  end
end)
