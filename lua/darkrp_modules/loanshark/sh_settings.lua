--[[---------------------------------------------------------------------------
  Settings
]]-----------------------------------------------------------------------------

-- loanJobs - Jobs that can loan money
GM.Config.loanJobs            = { [TEAM_MOB] = true }

-- maxLoanDebt - Maximum interest percentage that can be reached
GM.Config.maxLoanDebt         = .5

-- minLoan - Minimum money amount that can be lent
GM.Config.minLoan             = 500

-- maxLoan - Maximum money amount that can be lent
GM.Config.maxLoan             = 10000

-- loanTime - Seconds that it takes to reach maximum debt
GM.Config.loanTime            = 900

-- loanQuestionTime - Seconds to answer a loan request
GM.Config.loanQuestionTime    = 30

-- minLoanDistance - Maximum distance to request a loan
GM.Config.minLoanDistance     = 150

-- loanSharkText - Text displayed on the HUD when looking at a loan shark
GM.Config.loanSharkText       = 'I can lend money.\nPress R on me to request a loan!'

-- loanSharkTextUnable - Text displayed on the HUD when looking at a loan shark that cannot afford a loan
GM.Config.loanSharkTextUnable = 'I can\'t afford a loan right now.'

-- loanSharkTextPay - Text displayed on the HUD when looking at your loan shark
GM.Config.loanSharkTextPay    = 'You owe me money!\nPress R on me to pay back your loan.'
