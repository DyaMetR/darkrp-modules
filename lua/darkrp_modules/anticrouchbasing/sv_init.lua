local DUCKHULL_HEIGHT = Vector(0, 0, 36)
local TOP_HEIGHT = Vector(0, 0, 10)
local BOTTOM_HEIGHT = Vector(0, 0, -4)
local headtop = {}

-- check whether the bullet really went through the player's hull
hook.Add('PlayerTraceAttack', 'anticrouchbasing', function(_player, dmginfo, dir, trace)
  if not _player:Crouching() then return end
  local neck = _player:GetPos() + DUCKHULL_HEIGHT
  if trace.HitPos.z >= neck.z then -- the bullet has hit somewhere on the head
    local pos = neck + (_player:GetAngles():Forward() * 14) -- get the precise location of the neck
    headtop.start = pos + TOP_HEIGHT
    headtop.endpos = pos + BOTTOM_HEIGHT
    headtop.filter = _player
    local prop = util.TraceLine(headtop) -- trace from the top of the head to the neck looking for something obstructing the hitbox
    return prop.Hit and prop.HitPos.z <= trace.HitPos.z
  end
end)
