--[[---------------------------------------------------------------------------
  Declare chat commands
]]-----------------------------------------------------------------------------

DarkRP.declareChatCommand{
    command = 'requestloan',
    description = 'Request a money loan from the loan shark you\'re looking at.',
    delay = 0.5
}

DarkRP.declareChatCommand{
    command = 'forgiveloan',
    description = 'Forgives a player\'s loan.',
    condition = function(_player) return _player:canLoanMoney() end,
    delay = 0.5
}

DarkRP.declareChatCommand{
    command = 'payloan',
    description = 'Pays a debt back to your loan shark.',
    condition = function(_player)
      local loanShark =  _player:getDarkRPVar('loanshark')
      return loanShark or IsValid(loanShark)
    end,
    delay = 0.5
}
