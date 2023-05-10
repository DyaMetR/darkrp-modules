include( 'shared.lua' )

-- constants
local TEXT_COLOUR = Color( 255, 255, 255 )
local BACKGROUND_COLOUR = Color( 0, 0, 0 )
local UNDERLINE_COLOUR = Color( 140, 0, 0 )
local ICON_COLOUR = Color( 140, 140, 140 )
local DISABLED_COLOUR = Color( 40, 40, 40 )

-- variables
local menu
local server

--[[---------------------------------------------------------------------------
  Creates the buy menu
  @return {Panel} menu
]]-----------------------------------------------------------------------------
local function CreateMenu()

  -- create frame
  menu = vgui.Create('DFrame')
  menu:SetSize(ScrW() * .5, ScrH() * .5)
  menu:SetSkin('DarkRP')
  menu:Center()
  menu:MakePopup()
  menu:SetTitle('')
  menu.OnClose = function()
    menu = nil
  end

  -- create property sheet
  local sheet = vgui.Create('DPropertySheet', menu)
  sheet:SetPos( 10, 33 )
  sheet:SetSize( menu:GetWide() - ( sheet.x * 2 ) + 5, menu:GetTall() - ( sheet.y + 10 ) )

  -- create buy menu
  local buyMenu = vgui.Create('DScrollPanel')
  buyMenu:SetSize(sheet:GetWide() - 16, sheet:GetTall() - 16)

  local ingList = vgui.Create('DIconLayout', buyMenu)
  ingList:SetSize(buyMenu:GetWide(), buyMenu:GetTall())
  ingList:SetSpaceY(2)

  -- sort ingredients per price
  local ingredients = {}
  for i, data in pairs(DarkRP.getIngredients()) do
    table.insert(ingredients, {i = i, price = data.price})
  end
  table.SortByMember( ingredients, 'price', false )

  -- add ingredients to buy
  for i, data in pairs(ingredients) do
    local i, data = data.i, DarkRP.getIngredient(data.i)

    -- make panel
    local buy = ingList:Add('DPanel')
    buy:SetSize(ingList:GetWide(), 60)

    local icon = vgui.Create('SpawnIcon', buy)
    icon:SetSize(60, 60)
    icon:SetModel(data.model)

    local button = vgui.Create('DButton', buy)
    button:SetSize(buy:GetWide(), buy:GetTall())
    button:SetText('')
    button.Paint = function() end
    button.DoClick = function()
      net.Start('sc_terminal_buy')
      net.WriteEntity(server)
      net.WriteString(i)
      net.SendToServer()
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

      local x, y = (W * .5) - (w * .5), (H * .5) - (h * .5)

      -- background
      draw.RoundedBox(6, x, y, w, h, background)
      if not button:GetDisabled() then
        draw.RoundedBoxEx(6, x, y + (h - 10), w, 10, UNDERLINE_COLOUR, false, false, true, true)
        draw.RoundedBoxEx(6, x, y, h, h, ICON_COLOUR, true, false, false, false)
      end
      -- name
      draw.SimpleText(data.name, 'DarkRPHUD2', W * .5, H * .5, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      -- price
      draw.SimpleText(DarkRP.formatMoney(data.price), 'DarkRPHUD2', W - 10, ( H - 10 ) * .5, TEXT_COLOUR, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
  end

  --create recipe menu
  local recipeMenu = vgui.Create('DScrollPanel')
  recipeMenu:SetSize(sheet:GetWide() - 16, sheet:GetTall() - 16)

  local rcpList = vgui.Create('DIconLayout', recipeMenu)
  rcpList:SetSize(recipeMenu:GetWide(), recipeMenu:GetTall())
  rcpList:SetSpaceY(2)

  -- add recipes
  for lab, recipes in pairs(DarkRP.getDrugRecipes()) do
    for drug, recipe in pairs(recipes) do
      -- get ingredients
      local text = ''
      for i, ingredient in pairs(recipe.ingredients) do
        text = text .. DarkRP.getIngredient(ingredient).name .. ' + '
      end
      -- add lab used and result
      text = text .. DarkRP.getLabName(lab) .. ' = ' .. recipe.name

      -- create panel
      local panel = rcpList:Add('DPanel')
      panel:SetSize(rcpList:GetWide(), 60)
      panel.Paint = function()
        local w, h = panel:GetWide(), panel:GetTall()
        draw.RoundedBox( 6, 0, 0, w, h, BACKGROUND_COLOUR )
        draw.RoundedBoxEx( 6, 0, ( h - 10 ), w, 10, UNDERLINE_COLOUR, false, false, true, true )
        draw.RoundedBoxEx( 6, 0, 0, h, h, ICON_COLOUR, true, false, false, false )
        draw.SimpleText( text, 'DarkRPHUD2', w * .5, h * .5, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      end

      local icon = vgui.Create('ModelImage', panel)
      icon:SetSize(60, 60)
      icon:SetModel(recipe.model)
    end
  end

  -- add sheets
  sheet:AddSheet(DarkRP.getPhrase('sc_terminal_tab_buy'), buyMenu, 'icon16/cart.png', nil, nil, DarkRP.getPhrase('sc_terminal_tab_buy_desc'))
  sheet:AddSheet(DarkRP.getPhrase('sc_terminal_tab_recipes'), recipeMenu, 'icon16/application_view_list.png', nil, nil, DarkRP.getPhrase('sc_terminal_tab_recipes_desc'))

end

-- receive menu opening
net.Receive('sc_terminal_menu', function( len )
  if menu then return end

  server = net.ReadEntity()
  menu = CreateMenu()
end)
