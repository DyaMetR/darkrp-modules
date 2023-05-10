--[[---------------------------------------------------------------------------
  Damage scaling
]]-----------------------------------------------------------------------------

-- torso hitgroups
local TORSO_HITGROUPS = {
  [HITGROUP_GENERIC] = true,
  [HITGROUP_CHEST] = true,
  [HITGROUP_STOMACH] = true,
  [HITGROUP_GEAR] = true
}

-- arm hitgroups
local ARM_HITGROUPS = {
  [HITGROUP_LEFTARM] = true,
  [HITGROUP_RIGHTARM] = true
}

-- leg hitgroups
local LEG_HITGROUPS = {
  [HITGROUP_LEFTLEG] = true,
  [HITGROUP_RIGHTLEG] = true
}

-- Player take damage
function GM:ScalePlayerDamage( _player, hitgroup, dmginfo )
  local armour = _player:getDarkRPVar( 'kevlar' )
  local kevlar = DarkRP.getKevlarType( _player:getDarkRPVar( 'kevlar_type' ) )
  local has_armour = kevlar and armour > 0

  local damage = 1 -- damage multiplier
  local ap = 1 -- armour damage multiplier
  local hitKevlar = false -- whether armour should get damaged
  local torso, head = 0, 0 -- protection to torso and head

  -- get torso and head damage reduction
  if has_armour then
    torso, head = kevlar.torso, kevlar.head
  end

  -- simplify hitgroup
  if TORSO_HITGROUPS[hitgroup] then
    damage = GAMEMODE.Config.torsodamage
    ap = 1 - ( torso * .01 ) -- scale damage
    hitKevlar = true
  elseif ARM_HITGROUPS[hitgroup] then
    damage = GAMEMODE.Config.armsdamage
  elseif LEG_HITGROUPS[hitgroup] then
    damage = GAMEMODE.Config.legsdamage
  elseif hitgroup == HITGROUP_HEAD then
    damage = GAMEMODE.Config.headdamage
    ap = 1 - ( head * .01 )
    hitKevlar = true
  end

  if has_armour and hitKevlar then
    -- deduct armour points
    _player:setDarkRPVar( 'kevlar', math.max( armour - ( dmginfo:GetDamage() * kevlar.ap ), 0 ) )
    -- remove armour
    if _player:getDarkRPVar( 'kevlar' ) <= 0 and kevlar.removeOnEmpty then
      _player:removeKevlar()
    end
  end

  -- scale damage
  dmginfo:ScaleDamage( damage * ap ) -- scale damage and apply armour protection
end
