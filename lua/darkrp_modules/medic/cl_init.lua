--[[---------------------------------------------------------------------------
  Draw HUD
]]-----------------------------------------------------------------------------

local DIST_SQRT = GM.Config.minHealDistance * GM.Config.minHealDistance
local TEXT_COLOUR, SHADOW_COLOUR = Color( 255, 255, 255 ), Color( 0, 0, 0 )

-- paint the instructions
hook.Add('HUDPaint', 'medic_target', function()
  local trace = LocalPlayer():GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() or not trace.Entity:isMedic() or trace.Entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > DIST_SQRT then return end
  local x, y = ScrW() * .5, (ScrH() * .5) + 30
  draw.DrawNonParsedText(GAMEMODE.Config.medicHudText, 'TargetID', x + 1, y + 1, SHADOW_COLOUR, 1)
  draw.DrawNonParsedText(GAMEMODE.Config.medicHudText, 'TargetID', x, y, TEXT_COLOUR, 1)
end)

--[[---------------------------------------------------------------------------
  Open menu
]]-----------------------------------------------------------------------------

local menu = nil -- current frame opened

-- receive menu open
net.Receive('medic_openmenu', function(len)
  local medic = net.ReadEntity()
  local price = net.ReadFloat()
  local breakdown = net.ReadTable()
  if not menu or not IsValid(menu) then
    menu = DarkRP.openMedicMenu(medic, price, breakdown)
  end
end)

-- receive menu close
net.Receive('medic_pricechange', function(len)
  if not menu or not IsValid(menu) then return end
  local medic = net.ReadEntity()
  if menu:GetMedic() == medic then
    menu:Close()
  end
end)
