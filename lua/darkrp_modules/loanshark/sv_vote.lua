
-- constants
local QUESTION = 'loan|%i|%i'

-- phrases
DarkRP.addPhrase('en', 'loan_question', 'Give %s a %s loan?')
DarkRP.addPhrase('en', 'loan_reject', '%s rejected your loan request.')
DarkRP.addPhrase('en', 'loan_request', 'Request sent.')
DarkRP.addPhrase('en', 'loan_reject_self', 'You rejected %s loan request.')

-- called when a request is answered
local function requestCallback(answer, loanshark, requester, _, money)
  -- check distance
  if requester:GetPos():Distance(loanshark:GetPos()) > GAMEMODE.Config.minLoanDistance then
    DarkRP.notify(requester, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
    DarkRP.notify(loanshark, NOTIFY_ERROR, 4, DarkRP.getPhrase('distance_too_big'))
    return
  end
  -- give loan
  if tobool(answer) then
    loanshark:giveLoan(requester, money)
  else
    DarkRP.notify(requester, NOTIFY_ERROR, 4, DarkRP.getPhrase('loan_reject', loanshark:Name()))
    DarkRP.notify(loanshark, NOTIFY_ERROR, 4, DarkRP.getPhrase('loan_reject_self', requester:Name()))
  end
end

--[[---------------------------------------------------------------------------
  Creates a question to a loan shark to give a player's a loan
  @param {Player} loan requester
  @param {Player} loan shark
  @param {number} money to loan
]]-----------------------------------------------------------------------------
function DarkRP.playerRequestLoan(requester, loanshark, money)
  money = math.Clamp(money, GAMEMODE.Config.minLoan, GAMEMODE.Config.maxLoan)
  DarkRP.notify(requester, NOTIFY_GENERIC, 4, DarkRP.getPhrase('loan_request'))
  -- create question
  DarkRP.createQuestion(
    DarkRP.getPhrase('loan_question', requester:Name(), DarkRP.formatMoney(money)),
    string.format(QUESTION, requester:EntIndex(), loanshark:EntIndex()),
    loanshark,
    GAMEMODE.Config.loanQuestionTime,
    requestCallback,
    requester,
    nil,
    money
  )
end
