
-- common
local BACKGROUND_COLOUR = Color( 0, 0, 0, 150 )

-- localplayer HUD
local W, H = 210, 85
local BORDER = 6
local THICKNESS = 3
local SALARY_FORMAT = '( +%s )'
local DEFAULT_COLOUR = Color(255, 255, 255, 200)
local BAR_BACKGROUND_COLOUR = Color(0, 0, 0, 200)
local GUNLICENSE_TEXTURE = Material('icon16/page_white_text.png')
local CRITICAL_HEALTH = 15
local DEBT_COLOUR = Color(200, 0, 0, 200)

-- ammo HUD
local AMMO_W, AMMO_H = 150, H
local SMALL_BORDER = 3
local SMALL_BACKGROUND_COLOUR = Color(0, 0, 0)
local NO_CLIP_COLOUR = Color(225, 30, 30, 255)
local AMMUNITION_COLOUR = Color(255, 225, 40, 255)
local TEXT_COLOUR = Color(255, 255, 255)
local NO_AMMO_COLOUR = Color(140, 0, 0, 255)

-- prop count
local PROP_W, PROP_H = 122, 38
local PROP_ICON = '9'
local PROP_FORMAT = '%i/%i'
local PROPS = 'props'
local MAXPROPS = GetConVar('sbox_maxprops')
local PROP_TIME = 4

-- add phrases
DarkRP.addPhrase('en', 'no_ammo', 'Out of ammo!')
DarkRP.addPhrase('en', 'clips_left', '%i clips left')
DarkRP.addPhrase('en', '1clip_left', '1 clip left')
DarkRP.addPhrase('en', 'money_debt', 'Debt: %s')

--[[---------------------------------------------------------------------------
  Draws a shadowed text
  @param {number} x
  @param {number} y
  @param {number} text
  @param {string} font
  @param {Color} colour
  @param {TEXT_ALIGN_} horizontal alignment
  @param {TEXT_ALIGN_} vertical alignment
---------------------------------------------------------------------------]]
local function DrawShadowText(x, y, text, font, colour, hor_align, ver_align)
  font = font or 'darkrp_hud1'
  colour = colour or DEFAULT_COLOUR
  draw.SimpleText(text, font, x + 2, y + 2, BACKGROUND_COLOUR, hor_align, ver_align)
  draw.SimpleText(text, font, x, y, colour, hor_align, ver_align)
end

--[[---------------------------------------------------------------------------
  Draws a progress bar
  @param {number} x
  @param {number} y
  @param {number} w
  @param {number} h
  @param {number} number
  @param {number} value
  @param {Color} colour
---------------------------------------------------------------------------]]
function DrawBar(x, y, w, h, number, value, colour)
  draw.RoundedBox(BORDER, x, y, w, h, BAR_BACKGROUND_COLOUR)
  draw.RoundedBox(BORDER, x + THICKNESS, y + THICKNESS, (w - (THICKNESS * 2)) * value, h - (THICKNESS * 2), colour)
  draw.SimpleText(number, 'darkrp_hud1', x + (w * .5), y + math.floor(h * .5), DEFAULT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--[[---------------------------------------------------------------------------
  Draws a small progress bar
  @param {number} x
  @param {number} y
  @param {number} w
  @param {number} h
  @param {string} text
  @param {Color} text colour
  @param {number} number
  @param {number} value
  @param {Color} colour
---------------------------------------------------------------------------]]
local function DrawSmallBar(x, y, w, h, text, text_colour, value, colour)
  draw.RoundedBox(SMALL_BORDER, x, y, w, h, SMALL_BACKGROUND_COLOUR)
  draw.RoundedBox(SMALL_BORDER, x + 1, y + 1, (w - 2) * value, h - 2, colour)
  draw.SimpleText(text, 'DefaultSmall', x + (w * .5), y + math.floor(h * .5), text_colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--[[---------------------------------------------------------------------------
  Draws the status bar
  @param {number} x
  @param {number} y
  @param {number} w
  @param {number} h
---------------------------------------------------------------------------]]
local _health = 100
local _money = 500
local health_colour = Color(140, 0, 0, 180)
local function DrawLocalPlayer(x, y, w, h)
  draw.RoundedBox(BORDER, x, y, w, h, BACKGROUND_COLOUR)

  -- health
  local health = math.max(0, LocalPlayer():Health())
  if not LocalPlayer():Alive() then health = 0 end
  _health = Lerp(0.1, _health, math.min(health, GAMEMODE.Config.startinghealth))

  -- colour health
  local colour_health = math.Clamp((_health - 20)/80, 0, 1)
  if health > CRITICAL_HEALTH then
    health_colour.r = 200 * (1 - math.max((colour_health - .5) * 2, 0))
    health_colour.g = 140 * math.min(colour_health * 2, 1)
    health_colour.a = 180
  else
    local cin = (math.sin(CurTime() * 4) + 1) / 2
    health_colour.r = 255 - (100 * cin)
    health_colour.g = 0
    health_colour.a = 255
  end

  -- draw bar
  DrawBar(x + 5, y + h - 29, w - 10, 18, health, math.min(_health / LocalPlayer():GetMaxHealth(), 1), health_colour, health)

  -- money
  local money = LocalPlayer():getDarkRPVar('money') or 0
  _money = Lerp(0.1, _money, money)
  if _money >= 0 then
    DrawShadowText(x + 10, y + h - 53, DarkRP.formatMoney(math.Round(_money)))
  else
    DrawShadowText(x + 10, y + h - 53, DarkRP.getPhrase('money_debt', DarkRP.formatMoney(math.Round(math.abs(_money)))), nil, DEBT_COLOUR)
  end

  -- salary
  DrawShadowText(x + w - 10, y + h - 51, string.format(SALARY_FORMAT, DarkRP.formatMoney(LocalPlayer():getDarkRPVar('salary') or 0)), 'darkrp_hud2', nil, TEXT_ALIGN_RIGHT)

  -- disguise support
  local job = LocalPlayer():getDarkRPVar('job') or ''
  local disguise = LocalPlayer():getDarkRPVar('disguise')
  if disguise and disguise > 0 then job = DarkRP.getPhrase('in_disguise') end

  -- job
  DrawShadowText(x + 10, y + h - 75, job)

  -- draw gun license
  if LocalPlayer():getDarkRPVar('HasGunlicense') then
    surface.SetMaterial(GUNLICENSE_TEXTURE)
    surface.SetDrawColor(255, 255, 255, 100)
    surface.DrawTexturedRect(x + w, ScrH() - 32, 32, 32)
  end

  -- wanted
  if LocalPlayer():isWanted() then
    local x, y = chat.GetChatBoxPos()
    local w, h = chat.GetChatBoxSize()
    y = y + h + 24
    local text = DarkRP.getPhrase('wanted', tostring(LocalPlayer():getDarkRPVar('wantedReason')))
    draw.DrawNonParsedText(text, 'DarkRPHUD2', x, y, Color(255, 255, 255), 0)
    draw.DrawNonParsedText(text, 'DarkRPHUD2', x + 1, y - 1, Color(255, 0, 0), 0)
  end

end

--[[---------------------------------------------------------------------------
  Draws the weapon firemode
  @param {number} x
  @param {number} y
---------------------------------------------------------------------------]]
local function DrawWeaponFireMode( x, y )
  local weapon = LocalPlayer():GetActiveWeapon()
  if not IsValid( weapon ) or not weapon.FIREMODES then return end
  local firemode = 'p'
  if weapon:GetMode() > 0 then
    firemode = 'ppp'
  end
  DrawShadowText( x, y, firemode, 'darkrp_hud_firemode', TEXT_COLOUR, TEXT_ALIGN_RIGHT )
end

--[[---------------------------------------------------------------------------
  Draws the ammunition panel
  @param {number} x
  @param {number} y
  @param {number} w
  @param {number} h
---------------------------------------------------------------------------]]
local _clip = 0
local _reserve = 0
local function DrawAmmo( x, y )
  local weapon = LocalPlayer():GetActiveWeapon()
  if not IsValid(weapon) or (weapon:GetPrimaryAmmoType() <= 0 and weapon:GetSecondaryAmmoType() <= 0) then return end

  local clip = weapon:Clip1()
  local max_clip = weapon:GetMaxClip1()
  local reserve = LocalPlayer():GetAmmoCount( weapon:GetPrimaryAmmoType() )

  -- secondary only
  if weapon:GetPrimaryAmmoType() <= 0 and weapon:GetSecondaryAmmoType() > 0 then
    clip = LocalPlayer():GetAmmoCount( weapon:GetSecondaryAmmoType() )
    max_clip = game.GetAmmoMax( weapon:GetSecondaryAmmoType() )
    reserve = -1
  end

  -- reserve only
  if clip <= -1 then
    clip = reserve
    max_clip = game.GetAmmoMax( weapon:GetPrimaryAmmoType() )
    reserve = -1
  end

  -- soften values
  if clip > _clip then
    _clip = Lerp( 0.1, _clip, clip )
  else
    _clip = clip
  end

  _reserve = Lerp( 0.1, _reserve, reserve )

  local text, text_colour = '', TEXT_COLOUR

  -- bar text
  if clip <= 0 then
    if reserve <= 0 then
      text = DarkRP.getPhrase('no_ammo')
      text_colour = NO_AMMO_COLOUR
    else
      if math.ceil(reserve / max_clip) <= 1 then
        text = DarkRP.getPhrase('1clip_left')
      else
        text = DarkRP.getPhrase('clips_left', math.ceil(reserve / max_clip))
      end
    end
  end

  if reserve < 0 then ammo_text = clip end

  -- get total size of both numbers
  local w = 0

  surface.SetFont('darkrp_hud3')
  local clip_size = surface.GetTextSize(math.Round(_clip))
  w = w + clip_size

  if reserve > -1 then
    surface.SetFont('darkrp_hud4')
    w = w + surface.GetTextSize(math.Round(_reserve))
  end

  -- center of the numbers
  local center = (AMMO_W * .5) - (w * .5)

  -- colour it
  local colour = TEXT_COLOUR
  if clip <= 0 then colour = NO_CLIP_COLOUR end

  -- ammo bar
  local bar = math.min( clip / max_clip, 1 )
  if max_clip <= 0 and clip <= 0 then bar = 0 end

  -- paint the whole panel
  draw.RoundedBox(BORDER, x, y, AMMO_W, AMMO_H, BACKGROUND_COLOUR)
  DrawShadowText(x + center - 2, y + ( AMMO_H * .5 ) - 6, math.Round( _clip ), 'darkrp_hud3', colour, nil, TEXT_ALIGN_CENTER )
  if reserve > -1 then -- don't draw if it's not clip based
    DrawShadowText(x + center + clip_size + 1, y + ( AMMO_H * .5 ) - 4, math.Round( _reserve ), 'darkrp_hud4', colour, nil, TEXT_ALIGN_CENTER )
  end
  DrawSmallBar( x + 5, y + AMMO_H - 7, AMMO_W - 10, 7, text, text_colour, bar, AMMUNITION_COLOUR )

  -- draw firemode
  DrawWeaponFireMode( x + AMMO_W - 5, y - 7 )
end

--[[---------------------------------------------------------------------------
  Draws the prop count panel
  @param {number} x
  @param {number} y
---------------------------------------------------------------------------]]
local lastProps = 0
local propTime = 0
local function DrawPropCount(x, y)
  -- variables
  local props, max_props = LocalPlayer():GetCount(PROPS), MAXPROPS:GetInt()
  local colour = TEXT_COLOUR
  if props >= max_props then
    colour = NO_CLIP_COLOUR
  end
  -- trigger display
  if lastProps ~= props then
    propTime = CurTime() + PROP_TIME
    lastProps = props
  end
  -- show or hide
  if propTime < CurTime() and props < max_props * .75 then return end
  -- displace
  x = x - PROP_W
  -- draw background
  draw.RoundedBox(BORDER, x, y, PROP_W, PROP_H, BACKGROUND_COLOUR)
  -- count
  local propCount = string.format(PROP_FORMAT, props, max_props)
  DrawShadowText(x + 72, y + 8, propCount, 'darkrp_hud5', colour, TEXT_ALIGN_RIGHT)
  -- icon
  DrawShadowText(x + 76, y + 6, PROP_ICON, 'darkrp_hud_props', colour)
end

-- draw hud
hook.Add('HUDPaintBackground', 'darkrphud_paint', function()

  DrawLocalPlayer(0, ScrH() - H, W, H)
  DrawAmmo(ScrW() - AMMO_W, ScrH() - AMMO_H, AMMO_W, AMMO_H)
  DrawPropCount(ScrW(), 45)

end)
