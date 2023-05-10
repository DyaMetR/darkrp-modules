
-- toggle help console variable
local shouldShowHelp = CreateClientConVar('rp_scientisthelp', 1, true, true)

-- add phrase
DarkRP.addPhrase('en', 'scientist_help_header', 'Scientist help')
DarkRP.addPhrase('en', 'scientist_help', 'In order to be able to make drugs you have to own a Terminal.\nIt\'s used to buy drug ingredients and also contains\nthe recipes for each drug.\nType /scientisthelp to toggle this box.')

-- colours
local BACKGROUND_COLOUR = Color(0, 0, 0, 155)
local FOREGROUND_COLOUR = Color(51, 58, 51,100)
local HEADER_COLOUR = Color(0, 0, 70, 100)
local TITLE_COLOUR = Color(255, 0, 0, 255)
local TEXT_COLOUR = Color(255, 255, 255, 255)

-- draw scientist help
hook.Add('HUDPaint', 'scientist_help', function()
  if not LocalPlayer().isScientist or not LocalPlayer():isScientist() then return end
  if not shouldShowHelp:GetBool() then return end

  draw.RoundedBox(10, 10, 10, 460, 110, BACKGROUND_COLOUR)
  draw.RoundedBox(10, 12, 12, 456, 106, FOREGROUND_COLOUR)
  draw.RoundedBox(10, 12, 12, 456, 20, HEADER_COLOUR)

  draw.DrawNonParsedText(DarkRP.getPhrase('scientist_help_header'), 'DarkRPHUD1', 30, 12, TITLE_COLOUR, 0)
  draw.DrawNonParsedText(DarkRP.getPhrase('scientist_help'), 'DarkRPHUD1', 30, 35, TEXT_COLOUR, 0)
end)
