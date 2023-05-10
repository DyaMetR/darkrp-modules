--[[---------------------------------------------------------------------------
  Draw the indicator
]]-----------------------------------------------------------------------------

local BORDER = 6
local BACKGROUND_COLOUR = Color(0, 0, 0, 150)
local ICON_COLOUR = Color(255, 255, 255, 255)
local NO_ARMOUR_COLOUR = Color(150, 150, 150, 255)
local DEFAULT_ICON = Material('icon16/shield.png')

-- draws the kevlar indicator
local function drawKevlar(x, y, armour, variant)
  variant = variant or 1

  -- background
  draw.RoundedBox(BORDER, x, y, 64, 23, BACKGROUND_COLOUR)

  local colour = ICON_COLOUR
  if armour <= 0 then colour = NO_ARMOUR_COLOUR end
  -- armour
  draw.SimpleText(string.format('%d%%', armour), 'DarkRPHUD1', x + 60, y + 11, colour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

  -- icon
  local icon = DarkRP.getKevlarType(variant).icon or DEFAULT_ICON

  x, y = x + 3, y + 3

  surface.SetMaterial(icon)
  surface.SetDrawColor(colour)
  surface.DrawTexturedRect(x, y, 16, 16)
end

-- draw the indicator
hook.Add('HUDPaint', 'kevlarvests_hud', function()
  local armour, _type = LocalPlayer():getDarkRPVar('kevlar') or 0, LocalPlayer():getDarkRPVar('kevlar_type') or KEVLAR_NONE

  if _type ~= KEVLAR_NONE then
    drawKevlar( 141, ScrH() - 79, armour, _type )
  end
end )
