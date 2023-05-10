--[[---------------------------------------------------------------------------
  Draw notifications
]]-----------------------------------------------------------------------------

-- add phrases
DarkRP.addPhrase('en', 'policerequest', 'HELP REQUEST!')

-- new fonts
surface.CreateFont('policerequest_hud1', {
  font = 'Coolvetica',
  size = 30,
  weight = 0
})

surface.CreateFont('policerequest_hud2', {
  font = 'Coolvetica',
  size = 18,
  weight = 0
})

local HEIGHT = Vector(0, 0, 60)
local TEXT_COLOUR = Color(255, 255, 255)
local OUTLINE_COLOUR = Color(0, 0, 0)
local FORMAT = '%im'
local HUNIT_TO_M = 0.02
local LONG_DISTANCE = 2000 -- from which distance the indicators turn minimalistic

hook.Add('HUDPaint', 'policerequest_hud', function()

  local requests = DarkRP.getPoliceRequests()

  if not requests then return end

  for i, pos in pairs(requests) do
    local _player = ents.GetByIndex(i)
    if not IsValid(_player) then continue end

    local scpos = (pos + HEIGHT):ToScreen()
    local distance = LocalPlayer():GetPos():Distance(pos)
    local cin = (math.sin(CurTime() * 2) + 1) / 2
    local font = 'DarkRPHUD2'

    if distance <= LONG_DISTANCE then
      font = 'policerequest_hud1'
      draw.SimpleTextOutlined(_player:Name(), 'policerequest_hud2', scpos.x, scpos.y + 24, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, OUTLINE_COLOUR)
      draw.SimpleTextOutlined(string.format(FORMAT, math.ceil(distance * HUNIT_TO_M)), 'DarkRPHUD2', scpos.x, scpos.y - 28, TEXT_COLOUR, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, OUTLINE_COLOUR)
    end

    draw.SimpleTextOutlined(DarkRP.getPhrase('policerequest'), font, scpos.x, scpos.y, Color(cin * 255, 0, 255 - (cin * 255), 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, OUTLINE_COLOUR)
  end

end)
