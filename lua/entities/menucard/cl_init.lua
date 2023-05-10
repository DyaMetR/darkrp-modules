include('shared.lua')
include('commands.lua')

surface.CreateFont('darkrp_menucard', {
  font = 'Times New Roman',
  size = 28,
  weight = 1000,
  italic = true
})

--[[---------------------------------------------------------------------------
  Draw the model with a label indicating it's a menu card
]]-----------------------------------------------------------------------------
function ENT:Draw()
  self:DrawModel()

  local pos = self:GetPos()
  local ang = self:GetAngles()

  ang:RotateAroundAxis(ang:Right(), -90)
  ang:RotateAroundAxis(ang:Up(), 90)

  cam.Start3D2D(pos - (ang:Right() * 3) - (ang:Forward() * 7), ang, 0.2)
    draw.SimpleText('MENU', 'darkrp_menucard', 0, 0, Color(0, 0, 0))
  cam.End3D2D()
end

-- fonts
surface.CreateFont('darkrp_menucard_1', {
  font = 'Times New Roman',
  size = ScreenScale(20)
})

surface.CreateFont('darkrp_menucard_2', {
  font = 'Verdana',
  size = ScreenScale(10),
  weight = 1000
})

surface.CreateFont('darkrp_menucard_3', {
  font = 'Tahoma',
  size = ScreenScale(6),
  italic = true
})

-- constants
local MIN_DISTANCE_SQRT = 10000

-- phrases
DarkRP.addPhrase('en', 'menucard_title', '%s\'s Restaurant')
DarkRP.addPhrase('en', 'menucard_settings', 'Customize stove food retail prices and menu card title')
DarkRP.addPhrase('en', 'menucard_setprice', 'Set price')
DarkRP.addPhrase('en', 'menucard_newprice', 'Write the new price for %s')
DarkRP.addPhrase('en', 'menucard_reset_tip', 'Reset %s price')
DarkRP.addPhrase('en', 'menucard_resetall_label', 'Reset all food prices to default')

-- variables
local shouldDraw = false
local ent
local data
local displacement = 0
local backgroundColour = Color(255, 255, 255)
local textColour = Color(0, 0, 0)

-- paint menu card for customers
hook.Add('HUDPaint', 'darkrp_menucard_draw', function()
  if not shouldDraw then return end
  local w, h = ScrW() * .6, ScrH()
  local x, y = (ScrW() * .5) - (w * .5), ScrH() - (ScrH() * .86 * displacement)

  -- colours
  backgroundColour.a = 200 * displacement
  textColour.a = 255 * displacement

  -- draw
  draw.RoundedBox(0, x, y, w, h, backgroundColour)
  draw.SimpleText(data.title, 'darkrp_menucard_1', x + (w * .5), y + ScreenScale(20), textColour, TEXT_ALIGN_CENTER)

  for i, food in pairs(data.prices) do
    local data = DarkRP.getFood(food.id)
    draw.SimpleText(data.name, 'darkrp_menucard_2', x + ScreenScale(15), y + ScreenScale(50), textColour)
    draw.SimpleText(DarkRP.formatMoney(food.price), 'darkrp_menucard_2', x + w - ScreenScale(15), y + ScreenScale(50), textColour, TEXT_ALIGN_RIGHT)
    draw.SimpleText(data.info or '', 'darkrp_menucard_3', x + ScreenScale(15), y + ScreenScale(60), textColour)
    y = y + ScreenScale(21)
  end

  -- bring it up/down
  if not IsValid(ent) or ent == nil or LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > MIN_DISTANCE_SQRT then
    displacement = Lerp(0.2, displacement, 0)
    if displacement <= 0.01 then
      shouldDraw = false
      data = nil
    end
  else
    displacement = Lerp(0.1, displacement, 1)
  end
end)

--[[---------------------------------------------------------------------------
  Opens the customization menu
]]-----------------------------------------------------------------------------
local function createMenuCardSettings()
  local frame = vgui.Create('DFrame')
  frame:SetTitle(DarkRP.getPhrase('menucard_settings'))
  frame:SetSkin('DarkRP')
  frame:SetSize(500, 500)
  frame:Center()
  frame:ShowCloseButton(true)
  frame:MakePopup()

  local title = vgui.Create('DTextEntry', frame)
  title:SetPos(4, 27)
  title:SetSize(frame:GetWide() - 8, 24)
  title:SetText(data.title)
  title.OnEnter = function(self)
    RunConsoleCommand('say', '/menucardtitle ' .. title:GetValue())
  end

  local scroll = vgui.Create('DScrollPanel', frame)
  scroll:SetPos(5, 54)
  scroll:SetSize(frame:GetWide() - 10, frame:GetTall() - 73)

  local list = vgui.Create('DIconLayout', scroll)
  list:SetSize(scroll:GetWide(), scroll:GetTall())
  list:SetSpaceY(5)

  for id, food in pairs(DarkRP.getFoods()) do
    -- background
    local row = list:Add('DPanel')
    row:SetSize(list:GetWide(), 32)
    -- name
    local name = vgui.Create('DLabel', row)
    name:SetPos(12, 9)
    name.UpdateLabel = function(self, price)
      self:SetText(food.name .. ' (' .. DarkRP.formatMoney(price or data.prices[id] or math.floor(food.price * GAMEMODE.Config.foodDefaultProfit)) .. ')')
    end
    name:UpdateLabel()
    name:SizeToContents()
    -- price
    local price = vgui.Create('DButton', row)
    price:SetSize(100, 24)
    price:SetPos(row:GetWide() - price:GetWide() - 4, 4)
    price:SetText(DarkRP.getPhrase('menucard_setprice'))
    price.DoClick = function()
      Derma_StringRequest(DarkRP.getPhrase('menucard_setprice'), DarkRP.getPhrase('menucard_newprice', food.name), data.prices[id] or math.floor(food.price * GAMEMODE.Config.foodDefaultProfit),
      function(value)
        local newPrice = tonumber(value)
        if not newPrice then return end
        local finalPrice = math.Clamp(newPrice, food.price, math.floor(food.price * GAMEMODE.Config.maxFoodPrice))
        RunConsoleCommand('say', '/foodprice ' .. id .. ' ' .. finalPrice)
        name:UpdateLabel(finalPrice)
      end)
    end
    -- reset
    local reset = vgui.Create('DImageButton', row)
    reset:SetPos(row:GetWide() - price:GetWide() - 28, 8)
    reset:SetToolTip(DarkRP.getPhrase('menucard_reset_tip', food.name))
    reset:SetImage('icon16/arrow_refresh.png')
    reset:SizeToContents()
    reset.DoClick = function()
      RunConsoleCommand('say', '/resetfoodprice ' .. id)
      name:UpdateLabel(math.floor(food.price * GAMEMODE.Config.foodDefaultProfit))
    end
  end

  local resetAll = vgui.Create('DButton', frame)
  resetAll:SetText(DarkRP.getPhrase('menucard_resetall_label'))
  resetAll:SetSize(frame:GetWide() - 8, 24)
  resetAll:SetPos(4, frame:GetTall() - 28)
  resetAll.DoClick = function()
    RunConsoleCommand('say', '/resetallfoodprices')
    frame:Close()
  end
end

-- receive the menu data
net.Receive('darkrp_menucard', function(len)
  shouldDraw = false -- hide in case it wasn't hid before

  -- get data
  local owner = net.ReadEntity()
  ent = net.ReadEntity()
  data = net.ReadTable()

  -- set the default title if none is provided
  data.title = data.title or DarkRP.getPhrase('menucard_title', owner:Name())

  -- if it's the owner, open the customization menu instead
  if owner == LocalPlayer() then
    createMenuCardSettings()
    return
  end

  -- make a table where the prices will be sorted from higher to lower
  local prices = {}

  -- custom prices
  for food, price in pairs(data.prices) do
    table.insert(prices, {id = food, price = price})
  end

  -- default prices
  for id, food in pairs(DarkRP.getFoods()) do
    if data.prices[id] then continue end
    table.insert(prices, {id = id, price = math.floor(food.price * GAMEMODE.Config.foodDefaultProfit)})
  end

  -- sort table
  table.SortByMember(prices, 'price')

  -- set new prices table
  data.prices = prices

  -- finally, draw the HUD version
  shouldDraw = true
end)
