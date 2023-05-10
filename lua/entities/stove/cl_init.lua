include( 'shared.lua' )

-- colours
local TEXT_COLOUR = Color( 255, 255, 255 )
local BACKGROUND_COLOUR = Color( 0, 0, 0 )
local UNDERLINE_COLOUR = Color( 140, 0, 0 )
local ICON_COLOUR = Color( 140, 140, 140 )
local DISABLED_COLOUR = Color( 40, 40, 40 )

-- variables
local stove = NULL
local menu = nil

--[[---------------------------------------------------------------------------
  Creates the buy menu
  @return {Panel} menu
]]-----------------------------------------------------------------------------
local function CreateMenu()

  -- create frame
  local frame = vgui.Create( 'DFrame' )
  frame:SetSize( ScrW() * 0.6, ScrH() * 0.75 )
  frame:Center()
  frame:SetSkin( 'DarkRP' )
  frame:SetTitle( DarkRP.getPhrase( 'stove_title', ( stove:Getowning_ent():Name() or DarkRP.getPhrase( 'unknown' ) ), DarkRP.getPhrase( 'stove' ) ) )
  frame.OnClose = function()
    menu = nil
  end
  frame:MakePopup()

  -- create list
  local scroll = vgui.Create( 'DScrollPanel', frame )
  scroll:SetPos( 10, 33 )
  scroll:SetSize( frame:GetWide() - ( scroll.x * 2 ) + 5, frame:GetTall() - ( scroll.y + 10 ) )

  local layout = vgui.Create( 'DIconLayout', scroll )
  layout:SetSize( scroll:GetWide() - 15, scroll:GetTall() )
  layout:SetSpaceY( 2 )

  -- ordered list
  local list = {}
  for i, food in pairs( DarkRP.getFoods() ) do
    table.insert( list, { food = i, price = food.price } )
  end
  table.SortByMember( list, 'price', false )

  -- create icons
  for _, data in pairs( list ) do
    local i = data.food
    local food = DarkRP.getFood( i )

    -- background
    local buy = layout:Add( 'DPanel' )
    buy:SetSize( layout:GetWide(), 60 )

    -- icon
    local icon = vgui.Create( 'SpawnIcon', buy )
    icon:SetSize( buy:GetTall(), buy:GetTall() )
    icon:SetModel( food.model )

    -- button
    local button = vgui.Create( 'DButton', buy )
    button:SetSize( buy:GetWide(), buy:GetTall() )
    button:SetText( '' )
    button:SetDisabled( LocalPlayer():getDarkRPVar( 'money' ) < food.price )
    button.Paint = function() end
    button.DoClick = function()

      if stove and IsValid( stove ) then
        net.Start( 'stove_buy' )
        net.WriteEntity( stove )
        net.WriteFloat( i )
        net.SendToServer()
      end

    end

    -- paint background
    buy.Paint = function()
      local W, H = buy:GetWide(), buy:GetTall()
      local w, h = buy:GetWide(), buy:GetTall()
      local background = BACKGROUND_COLOUR

      -- set as disabled
      if button:GetDisabled() then
        background = DISABLED_COLOUR
      end

      -- check whether the button is pressed
      if button:IsDown() then

        w = w - 3
        h = h - 3

      end

      local x, y = ( W * .5 ) - ( w * .5 ), ( H * .5 ) - ( h * .5 )

      -- background
      draw.RoundedBox( 6, x, y, w, h, background )

      if not button:GetDisabled() then
        draw.RoundedBoxEx( 6, x, y + ( h - 10 ), w, 10, UNDERLINE_COLOUR, false, false, true, true )
        draw.RoundedBoxEx( 6, x, y, h, h, ICON_COLOUR, true, false, false, false )

        -- description
        draw.SimpleText( DarkRP.getPhrase( 'stove_food_restore', food.energy ) .. ( food.info or '' ), 'DefaultSmall', 65, H - 5, TEXT_COLOUR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
      end

      -- name
      draw.SimpleText( food.name, 'DarkRPHUD2', W * .5, H * .5, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      -- price
      draw.SimpleText( DarkRP.formatMoney( food.price ), 'DarkRPHUD2', W - 10, ( H - 10 ) * .5, TEXT_COLOUR, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

    end
  end

  return frame

end

--[[---------------------------------------------------------------------------
  Draw the title
]]-----------------------------------------------------------------------------
function ENT:Draw()
  self:DrawModel()

  local Pos = self:GetPos()
  local Ang = self:GetAngles()

  local owner = self:Getowning_ent()
  owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

  surface.SetFont("HUDNumber5")
  local text = DarkRP.getPhrase( 'stove' )
  local text2 = owner
  local TextWidth = surface.GetTextSize(text)
  local TextWidth2 = surface.GetTextSize(text2)

  Ang:RotateAroundAxis(Ang:Forward(), 90)
  local TextAng = Ang

  TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

  cam.Start3D2D(Pos + Ang:Right() * -36, TextAng, 0.2)
    draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    draw.WordBox(2, -TextWidth2 * 0.5 + 5, 18, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
  cam.End3D2D()
end

-- receive menu opening
net.Receive( 'stove_menu', function( len )
  if menu then return end

  stove = net.ReadEntity()
  menu = CreateMenu()
end )
