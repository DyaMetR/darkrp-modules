
DarkRP.isAlcoholModInstalled = true

-- player spawned
hook.Add( 'PlayerSpawn', 'alcoholmod_spawn', function(_player)
  if not _player.AlcoholDrinks then _player.AlcoholDrinks = {} end
  _player.AlcoholBoost = 0
  _player:setSelfDarkRPVar('alcohol', 0)
  _player:setSelfDarkRPVar('hangover', 0)
  _player.HangoverNotice = false
  _player.HangoverWarning = false
end )

-- reduce incoming damage
hook.Add( 'EntityTakeDamage', 'alcoholmod_damage', function(_player, dmginfo)
  if not _player:IsPlayer() then return end
  dmginfo:ScaleDamage(1 - ( _player:getDarkRPVar('alcohol') * 0.01 * GAMEMODE.Config.alcoholDefense * .01))
end )
