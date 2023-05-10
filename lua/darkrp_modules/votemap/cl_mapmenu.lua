--[[---------------------------------------------------------------------------
  Map menu to select which map to vote
]]-----------------------------------------------------------------------------

local TEXT_COLOUR = Color(255, 255, 255)
local DISABLED_COLOUR = Color(100, 100, 100)
local BACKGROUND_COLOUR = Color(0, 0, 0, 150)

-- add phrase
DarkRP.addPhrase('en', 'votemap_title', 'Vote to change map')
DarkRP.addPhrase('en', 'votemap_select', 'Start vote to change map to %s')
DarkRP.addPhrase('en', 'votemap_playing', 'Already playing on this map')

local votemenu = nil

-- pops up the vote menu
local function createVoteMenu()

  if not votemenu then

    votemenu = vgui.Create('DFrame')
    votemenu:SetSkin('DarkRP')
    votemenu:SetSize(ScrW() * .5, ScrH() * .5)
    votemenu:Center()
    votemenu:SetTitle(DarkRP.getPhrase('votemap_title'))
    votemenu:Show()
    votemenu:MakePopup()
    votemenu.OnClose = function()
      votemenu = nil
    end

    local scroll = vgui.Create('DScrollPanel', votemenu)
    scroll:Dock(FILL)

    local layout = vgui.Create('DIconLayout', scroll)
    layout:Dock(FILL)
    layout:SetSpaceY(5)

    for map, name in pairs(DarkRP.getMapsToVote()) do

      local icon = Material(string.format( 'maps/thumb/%s.png', map))
      local tooltip = DarkRP.getPhrase('votemap_select', map)

      -- create vote panel
      local vote = layout:Add('DPanel')
      vote.OwnLine = true
      vote:SetSize(votemenu:GetWide() - 16, 128)
      vote.Paint = function()
        local colour = TEXT_COLOUR
        if map == game.GetMap() then
          colour = DISABLED_COLOUR
          tooltip = DarkRP.getPhrase('votemap_playing')
        end

        draw.RoundedBox(8, 0, 0, vote:GetWide(), vote:GetTall(), BACKGROUND_COLOUR)
        draw.SimpleText(name or map, 'DarkRPHUD2', vote:GetWide() * .5, vote:GetTall() * .5, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if icon:IsError() then return end

        surface.SetMaterial(icon)
        surface.SetDrawColor(colour)
        surface.DrawTexturedRect(0, 0, 128, 128)
      end

      -- create button
      local button = vgui.Create('DButton', vote)
      button:SetSkin('Default')
      button:Dock( FILL )
      button:SetText('')
      button:SetToolTip(tooltip)
      button.Paint = function() end
      button.DoClick = function()
        RunConsoleCommand('say', string.format('/votemap %s', map))
        votemenu:Close()
      end
    end
  end
end

-- receive the signal to open the menu
net.Receive('votemap_menu', function(len)
  createVoteMenu()
end)
