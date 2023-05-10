
-- constants
local DIST_SQRT = GAMEMODE.Config.minGuardDistance * GAMEMODE.Config.minGuardDistance
local TEXT_COLOUR, SHADOW_COLOUR = Color(255, 255, 255), Color(0, 0, 0)
local UNABLE_COLOUR = Color(140, 0, 0)

-- add phrases
DarkRP.addPhrase('en', 'guard_request_query', 'Would you like to request %s services?')
DarkRP.addPhrase('en', 'guard_hud_hired', 'Security Guard: %s')
DarkRP.addPhrase('en', 'guard_hud_client', 'Serving: %s')

--[[---------------------------------------------------------------------------
  Draws a text when looking at a security guard
]]-----------------------------------------------------------------------------
local function drawTargetID()
  if LocalPlayer():isSecurityGuard() then return end
  local trace = LocalPlayer():GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() or not trace.Entity:isSecurityGuard() or trace.Entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > DIST_SQRT then return end
  local x, y = ScrW() * .5, (ScrH() * .5) + 30

  -- select text and colour
  local text, colour = GAMEMODE.Config.guardHudText, TEXT_COLOUR
  local contract = LocalPlayer():getSecurityContractTarget()
  if contract and contract ~= trace.Entity then
    text = GAMEMODE.Config.guardHudTextUnable
    colour = UNABLE_COLOUR
  else
    local client = trace.Entity:getSecurityContractTarget()
    if client then
      text = string.format(GAMEMODE.Config.guardHired, client:Name())
    end
  end

  -- draw
  draw.DrawNonParsedText(text, 'TargetID', x + 1, y + 1, SHADOW_COLOUR, 1)
  draw.DrawNonParsedText(text, 'TargetID', x, y, colour, 1)
end

--[[---------------------------------------------------------------------------
  Draws who you contracted
]]-----------------------------------------------------------------------------
local function drawContractHUD()
  local contract = LocalPlayer():getSecurityContractTarget()
  if not contract then return end

  -- pos and text
  local x, y = chat.GetChatBoxPos()
  local w, h = chat.GetChatBoxSize()
  if GetGlobalBool('DarkRP_Lockdown') then y = y - 20 end
  local text, colour = DarkRP.getPhrase('guard_hud_hired', contract:Name()), TEXT_COLOUR

  -- text
  if LocalPlayer():isSecurityGuard() then
    text = DarkRP.getPhrase('guard_hud_client', contract:Name())
  end

  -- colour
  if not contract:Alive() or contract:isArrested() then
    colour = UNABLE_COLOUR
  end

  -- draw
  draw.DrawNonParsedText(text, 'TargetID', x, y + h, colour, 0)
end

-- paint HUD
hook.Add('HUDPaint', 'securityguard_contract_hud', function()
  if hook.Run('HUDShouldDraw', 'DarkRPHUD_SecurityGuardContract') == false then return end
  if not LocalPlayer().isSecurityGuard then return end
  drawContractHUD()
  drawTargetID()
end)

-- receive prompt
net.Receive('securityguard_prompt', function(len)
  local guard = net.ReadString()
  Derma_Query(
    DarkRP.getPhrase('guard_request_query', guard),
    RPExtraTeams[TEAM_SECURITYGUARD].name,
    DarkRP.getPhrase('yes'),
    function() RunConsoleCommand('say', '/requestsecurity ' .. guard) end,
    DarkRP.getPhrase('no')
  )
end)
