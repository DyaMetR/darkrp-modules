include('shared.lua')
include('cooldown.lua')
include('settings.lua')

local SPRITE = Material('sprites/light_ignorez')
local OFF_COLOUR, ON_COLOUR = Color(255, 30, 0, 50), Color(30, 255, 30, 50)
local W, H = 8, 8

function ENT:Draw()
  self:DrawModel() -- draw model

  if not DarkRP.vendingMachinesEnabled() then return end

  -- get sprite position
  local pos = self:GetPos()
  local ang = self:GetAngles()

  pos = pos + (ang:Forward() * 18)
  pos = pos + (ang:Right() * -24.5)
  pos = pos + (ang:Up() * 1.5)

  -- is visible
  local visibile = util.PixelVisible( pos, 4, self.PixVis )
	if ( !visibile || visibile < 0.66 ) then return end

  -- get colour
  local colour = ON_COLOUR
  if DarkRP.isVendingMachineOnCooldown(self:EntIndex()) then
    colour = OFF_COLOUR
  end

  -- render sprite
  render.SetMaterial(SPRITE)
  render.DrawSprite(pos, W, H, colour, visible)
end
