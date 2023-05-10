local hide = {
  ['DarkRP_LocalPlayerHUD'] = true,
  ['CHudAmmo'] = true,
  ['CHudSecondaryAmmo'] = true
}

-- hide default HUD elements
hook.Add('HUDShouldDraw', 'darkrphud_hide', function(element)
  if hide[element] then return false end
end)
