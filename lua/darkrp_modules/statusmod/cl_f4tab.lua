-- add phrases
DarkRP.addPhrase( 'en', 'effects_warn', 'There are effects being overriden by %s:' )

-- colours
local TEXT_COLOUR = Color( 255, 255, 255 )
local BACKGROUND_COLOUR = Color( 0, 0, 0 )
local UNDERLINE_COLOUR = Color( 47, 79, 68 )
local DISABLED_COLOUR = Color( 40, 40, 40 )

-- warning icon
local WARNING_TEXTURE = Material( 'icon16/exclamation.png' )

-- add phrases
DarkRP.addPhrase( 'en', 'status_tab', 'Statuses' )

--[[---------------------------------------------------------------------------
  Status descriptor panel
]]-----------------------------------------------------------------------------
local PANEL = {}

AccessorFunc(PANEL, 'status', 'Status')
AccessorFunc(PANEL, 'instance', 'Instance')
AccessorFunc(PANEL, 'clientside', 'ClientOnly', FORCE_BOOL)

function PANEL:Init()
  self.BaseClass.Init(self)
  self:SetTall(60)
end

function PANEL:Paint(w, h)
  local present = (self:GetClientOnly() and self:GetInstance().func()) or DarkRP.getActiveStatus(self:GetInstance())
  local data = DarkRP.getStatus(self:GetStatus())
  if self:GetClientOnly() then data = self:GetInstance() end
  local background = BACKGROUND_COLOUR

  -- draw background
  if not present then background = DISABLED_COLOUR end
  draw.RoundedBox(6, 0, 0, w, h, background)

  -- draw details
  if present then
    draw.RoundedBoxEx( 6, 0, h - 10 , w, 10, UNDERLINE_COLOUR, false, false, true, true )
    draw.SimpleText( data.desc or '', 'DefaultSmall', 5, h - 5, TEXT_COLOUR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
  end

  -- icon
  if data.icon then
    surface.SetDrawColor( TEXT_COLOUR )
    surface.SetMaterial( data.icon )
    surface.DrawTexturedRect( ( self:GetTall() * .5 ) - 8, ( self:GetTall() * .5 ) - 12, 16, 16 )
  end

  -- name
  draw.SimpleText( data.name or status, 'DarkRPHUD2', w * .5, h * .5, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

  -- warning icon
  if not self:GetClientOnly() and self.Warning then
    surface.SetDrawColor( TEXT_COLOUR )
    surface.SetMaterial( WARNING_TEXTURE )
    surface.DrawTexturedRect( self:GetWide() - 21, 5, 16, 16 )
  end
end

function PANEL:overrideCheck()
  if self:GetClientOnly() then return end

  -- compose warning
  local tooltip = nil

  -- get overriden effects
  for effect, _ in pairs(DarkRP.getStatus(self:GetStatus()).effects) do
    local is_overriden, override = DarkRP.isStatusEffectOverriden(self:GetStatus(), effect)
    if not is_overriden then continue end
    if not tooltip then
      tooltip = DarkRP.getPhrase('effects_warn', DarkRP.getStatus(override).name)
    end
    tooltip = tooltip .. '\n' .. DarkRP.getStatusEffect(effect).name
  end

  -- create tooltip and set warning
  if tooltip then
    self:SetToolTip(tooltip)
    self.Warning = true
  end
end

derma.DefineControl('StatusDescriptor', '', PANEL, 'DPanel')

--[[---------------------------------------------------------------------------
  Status container
]]-----------------------------------------------------------------------------
PANEL = {}

function PANEL:Init()
  self.BaseClass.Init(self)
  self:Dock(FILL)
  self.scroll = vgui.Create('DScrollPanel', self)
  self.scroll:SetPos(6, 0)
  self.iconList = vgui.Create('DIconLayout', self.scroll)
  self.iconList:SetSpaceY(2)
  self:fillData()
end

function PANEL:fillData()
  self.iconList:Clear()

  -- check for condition based statuses
  for status, data in pairs(DarkRP.getClientStatuses()) do
    if not data.func() then continue end
    local panel = vgui.Create('StatusDescriptor')
    panel:SetSkin('Default')
    panel:SetStatus(status)
    panel:SetInstance(data)
    panel:SetClientOnly(true)
    self.iconList:Add(panel)
  end

  -- check for framework statuses
  for instance, status in pairs(DarkRP.getActiveStatuses()) do
    local panel = vgui.Create('StatusDescriptor')
    panel:SetSkin('Default')
    panel:SetStatus(status)
    panel:SetInstance(instance)
    panel:overrideCheck()
    self.iconList:Add(panel)
  end

  -- layout
  self:InvalidateLayout(true)
end

function PANEL:Refresh()
  self:fillData()
end

function PANEL:PerformLayout()
  self.scroll:SetSize(self:GetWide() - 12, self:GetTall() - 6)
  self.iconList:SetSize(self.scroll:GetWide(), self.scroll:GetTall())
  for _, child in pairs(self.iconList:GetChildren()) do
    child:SetWide(self.iconList:GetWide())
  end
end

function PANEL:Paint(w, h) end

derma.DefineControl('StatusTab', '', PANEL, 'DPanel')

--[[---------------------------------------------------------------------------
  Add to the F4 menu
]]-----------------------------------------------------------------------------
hook.Add('F4MenuTabs', 'statusmod_f4tab', function()
  DarkRP.addF4MenuTab(DarkRP.getPhrase('status_tab'), vgui.Create('StatusTab'))
end)
