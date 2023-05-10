
-- constants
local DIST_SQRT = GAMEMODE.Config.minGuardDistance * GAMEMODE.Config.minGuardDistance
local TEXT_COLOUR, SHADOW_COLOUR = Color(200, 200, 200), Color(0, 0, 0)
local DEFAULT_COLOUR, UNABLE_COLOUR = Color(255, 255, 255), Color(140, 0, 0)
local INTEREST_FORMAT = '%i%%'
local BACKGROUND_COLOR = Color(0, 0, 0, 155)
local HUD_FORMAT = '%s: %s (%s)'

-- pharses
DarkRP.addPhrase('en', 'loan_hud', 'Loan shark: %s\nDebt: %s (%s)')
DarkRP.addPhrase('en', 'loan_query_title', 'Request money loan')
DarkRP.addPhrase('en', 'loan_query', 'How much money do you want your loan to be? (%s - %s)')
DarkRP.addPhrase('en', 'loan_debtor', 'Loan: %s\nDebt: %s (%s)')
DarkRP.addPhrase('en', 'loan_debtor_max', 'Owes you money.')
DarkRP.addPhrase('en', 'loan_shark_max', 'Time frame exceeded.')
DarkRP.addPhrase('en', 'loan_list_title', 'Loans')

-- variables
local debtors = {}

--[[---------------------------------------------------------------------------
  Draws a text when looking at a loan shark
]]-----------------------------------------------------------------------------
local function drawTargetID()
  local trace = LocalPlayer():GetEyeTrace()
  if not trace.Hit or not trace.Entity:IsPlayer() then return end -- check if it's a player
  local loanShark = trace.Entity:getDarkRPVar('loanshark') -- possible loan shark
  if (not trace.Entity:canLoanMoney() and loanShark ~= LocalPlayer() and not LocalPlayer():isLoanSharkAlly(loanShark)) or trace.Entity:GetPos():DistToSqr( LocalPlayer():GetPos() ) > DIST_SQRT then return end
  local x, y = ScrW() * .5, (ScrH() * .5) + 30 -- set position
  local loan = trace.Entity:getDarkRPVar('loan') -- money lent

  -- move text if hitman
  if trace.Entity:isHitman() then
    y = y + 40
  end

  -- select text and colour
  local text, colour = GAMEMODE.Config.loanSharkText, TEXT_COLOUR
  if trace.Entity == LocalPlayer():getDarkRPVar('loanshark') then -- player is your loan shark
    text = GAMEMODE.Config.loanSharkTextPay
    colour = DEFAULT_COLOUR
  elseif loanShark == LocalPlayer() then -- you are the player's loan shark
    if trace.Entity:isDebtor() then
      text = DarkRP.getPhrase('loan_debtor_max')
      draw.DrawNonParsedText(text, 'TargetID', x + 1, y + 38, SHADOW_COLOUR, 1)
      draw.DrawNonParsedText(text, 'TargetID', x, y + 37, UNABLE_COLOUR, 1)
    end
    text = DarkRP.getPhrase('loan_debtor', DarkRP.formatMoney(loan), DarkRP.formatMoney(trace.Entity:getDebt()), string.format(INTEREST_FORMAT, math.floor(trace.Entity:getLoanInterest() * 100)))
  elseif LocalPlayer():isLoanSharkAlly(loanShark) then -- you are the player's loan shark's ally
    if trace.Entity:isDebtor() then
      text = DarkRP.getPhrase('loanshark_boss_debtor')
      colour = UNABLE_COLOUR
    else
      text = DarkRP.getPhrase('loanshark_boss_loan', DarkRP.formatMoney(loan))
    end
  else -- you're a citizen without a debt from this loan shark
    if not trace.Entity:canAfford(GAMEMODE.Config.minLoan) then
      text = GAMEMODE.Config.loanSharkTextUnable
      colour = UNABLE_COLOUR
    end
  end

  -- draw
  draw.DrawNonParsedText(text, 'TargetID', x + 1, y + 1, SHADOW_COLOUR, 1)
  draw.DrawNonParsedText(text, 'TargetID', x, y, colour, 1)
end

--[[---------------------------------------------------------------------------
  Draw the current debt to pay and the loan shark
]]-----------------------------------------------------------------------------
local function drawLoanHUD()
  local loanShark = LocalPlayer():getDarkRPVar('loanshark')
  if not loanShark or not IsValid(loanShark) then return end
  local x, y = 240, ScrH() - 83
  local text = DarkRP.getPhrase('loan_hud', loanShark:Name(), DarkRP.formatMoney(LocalPlayer():getDebt()), string.format(INTEREST_FORMAT, math.floor(LocalPlayer():getLoanInterest() * 100)))
  -- draw main text
  draw.DrawNonParsedText(text, 'TargetID', x + 1, y + 1, SHADOW_COLOUR)
  draw.DrawNonParsedText(text, 'TargetID', x, y, DEFAULT_COLOUR)
  -- draw warning
  if CurTime() > LocalPlayer():getDarkRPVar('loantime') then
    text = DarkRP.getPhrase('loan_shark_max')
    y = y + 35
    draw.DrawNonParsedText(text, 'TargetID', x + 1, y + 1, SHADOW_COLOUR)
    draw.DrawNonParsedText(text, 'TargetID', x, y, UNABLE_COLOUR)
  end
end

--[[---------------------------------------------------------------------------
  Draw the current debtors
]]-----------------------------------------------------------------------------
local function drawSharkHUD()
  local count = table.Count(debtors)
  if not LocalPlayer():canLoanMoney() or count <= 0 then return end
  local x, y, w = 10, 130, 460
  -- background
  draw.RoundedBox(6, x, y, w, 35 + (20 * count), BACKGROUND_COLOR)
  -- title
  draw.DrawNonParsedText(DarkRP.getPhrase('loan_list_title'), 'DarkRPHUD1', x + 20, y + 4, DEFAULT_COLOUR, 0)
  -- separator
  draw.RoundedBox(0, x + 10, y + 24, w - 20, 1, DEFAULT_COLOUR)
  -- debtors
  local i = 0
  for debtor, _ in pairs(debtors) do
    local colour = DEFAULT_COLOUR
    if debtor:isDebtor() then colour = UNABLE_COLOUR end
    draw.DrawNonParsedText(string.format(HUD_FORMAT, debtor:Name(), DarkRP.formatMoney(debtor:getDebt()), string.format(INTEREST_FORMAT, math.floor(debtor:getLoanInterest() * 100))), 'DarkRPHUD1', x + 10, y + 31 + (20 * i), colour, 0)
    i = i + 1
  end
end

-- paint HUD
hook.Add('HUDPaint', 'loanshark_hud', function()
  if hook.Run('HUDShouldDraw', 'DarkRPHUD_LoanShark') == false then return end
  drawLoanHUD()
  drawTargetID()
  drawSharkHUD()
end)

-- receive prompt
net.Receive('loanshark_prompt', function(len)
  Derma_StringRequest(
    DarkRP.getPhrase('loan_query_title'),
    DarkRP.getPhrase('loan_query', DarkRP.formatMoney(GAMEMODE.Config.minLoan), DarkRP.formatMoney(GAMEMODE.Config.maxLoan)),
    GAMEMODE.Config.minLoan,
    function(value) RunConsoleCommand('say', '/requestloan ' .. value) end
  )
end)

-- receive debtors
net.Receive('loanshark_debtors', function(len)
  debtors = net.ReadTable()
end)
