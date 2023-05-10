
DEFINE_BASECLASS( 'igfl_base' )

local SCOPE_TIMER = 'igfl_scope_base_%i'
local RESCOPE_TIMER = 'igfl_scope_base_%i_rescope'
local POST_SHOT_UNSCOPE_TIME = 0.1

SWEP.Base                 = 'igfl_base'
SWEP.PrintName            = 'IGF Lite Scope Base'
SWEP.Author               = 'DyaMetR'
SWEP.Instructions         = 'ATTACK for primary fire\nATTACK2 to aim down the scope\nUSE + ATTACK to toggle safety'
SWEP.Category             = 'IGF Lite'
SWEP.IsRedDot             = false
SWEP.ScopeInSpeed         = 0.25 -- how much time it takes for the player to scope in
SWEP.IsBoltAction         = false

function SWEP:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Bool', 9, 'Scoped')
end

function SWEP:PrimaryAttack()
  local couldShoot = BaseClass.PrimaryAttack(self)
  if not self.IsBoltAction or not couldShoot or not self:GetScoped() or self:Clip1() <= 0 then return end
  local _timer = string.format(RESCOPE_TIMER, self:GetOwner():EntIndex())
  -- unscope after shot
  timer.Create(_timer, POST_SHOT_UNSCOPE_TIME, 1, function()
    if not IsValid(self) then return end
    -- unscope
    self:SetIronSights(false)
    self:SetScoped(false)
    self:GetOwner():SetFOV(0, 0.25)
    -- rescope after chambering next round
    timer.Create(_timer, self.Primary.Delay, 1, function()
      if not IsValid(self) then return end
      self:ScopeIn()
    end)
  end)
end

function SWEP:IronSights(ironsights)
  if (not self:CanIronSights() and ironsights) or self:GetHolster() or ironsights == self:GetIronSights() or self:GetNextHolsterDelay() > CurTime() then return end

  if not ironsights then
    self:SetIronSights(false)
    self:SetScoped(false)
    self:GetOwner():SetFOV(0, 0.25)
    timer.Remove(string.format(SCOPE_TIMER, self:GetOwner():EntIndex()))
    timer.Remove(string.format(RESCOPE_TIMER, self:GetOwner():EntIndex()))
  else
    self:ScopeIn()
  end

  self:UpdateHoldType()
end

function SWEP:ScopeIn()
  self:SetIronSights(true)
  self:GetOwner():SetFOV(math.max(self.AimFOV, 50), .5 * self.IronSightsDelay)
  timer.Create(string.format(SCOPE_TIMER, self:GetOwner():EntIndex()), self.ScopeInSpeed, 1, function()
    if not IsValid(self) then return end
    self:SetScoped(true)
    self:GetOwner():SetFOV(self.AimFOV, 0)
  end)
end

function SWEP:Holster()
  timer.Remove(string.format(SCOPE_TIMER, self:GetOwner():EntIndex()))
  timer.Remove(string.format(RESCOPE_TIMER, self:GetOwner():EntIndex()))
  self:SetScoped(false)
  self:SetIronSights(false)
  return BaseClass.Holster(self)
end

-- whether ironsights are toggleable
function SWEP:AreIronSightsToggle()
  return self.IsBoltAction
end

-- cannot aim when sprinting
function SWEP:CanIronSights()
  return not self:IsSprinting() and self:GetNextPrimaryFire() < CurTime()
end

-- exit ironsights if running
function SWEP:Think()
  BaseClass.Think(self)
  if self:IsSprinting() then
    self:IronSights(false)
  end
end

function SWEP:Reload()
  timer.Remove(string.format(RESCOPE_TIMER, self:GetOwner():EntIndex()))
  BaseClass.Reload(self)
end

if CLIENT then

  -- constants
  local TEXTURE_COLOUR = Color(255, 255, 255)
  local BLACK_COLOUR = Color(0, 0, 0)
  local SCOPE_LENS = surface.GetTextureID('overlays/scope_lens')
  local SCOPE_ARC = surface.GetTextureID('sprites/scope_arc')

  -- variables
  local tint = Color(0, 0, 0, 0)
  local overlay = 0
  local tick = 0
  local wasScoped = false

  -- scope drawing function
  function SWEP:DrawScope()
    local w, h = math.Round(ScrW() * .5), math.Round(ScrH() * .5)
    -- draw textures
    surface.SetDrawColor(TEXTURE_COLOUR)

    -- draw dirt
    surface.SetTexture(SCOPE_LENS)
    surface.DrawTexturedRect(w - h, 0, ScrH(), ScrH())

    -- draw arcs
    surface.SetTexture(SCOPE_ARC)
    surface.DrawTexturedRect(w, h, h, h)
    surface.DrawTexturedRectUV(w - h, h, h, h, 1, 0, 0, 1)
    surface.DrawTexturedRectUV(w - h, 0, h, h, 1, 1, 0, 0)
    surface.DrawTexturedRectUV(w, 0, h, h, 0, 1, 1, 0)

    -- draw sides
    draw.RoundedBox(0, 0, 0, w - h, ScrH(), BLACK_COLOUR)
    draw.RoundedBox(0, ScrW() - (w - h), 0, w - h, ScrH(), BLACK_COLOUR)

    -- draw crosshair
    if self.IsRedDot then
      local w = 16
      draw.RoundedBox(12, (ScrW() * .5) - (w * .5), (ScrH() * .5) - (w * .5), w, w, Color(255, 90, 60, 190))
    else
      draw.RoundedBox(0, (ScrW() * .5), 0, 1, ScrH(), BLACK_COLOUR)
      draw.RoundedBox(0, 0, (ScrH() * .5), ScrW(), 1, BLACK_COLOUR)
    end
  end

  -- actually paint scope
  function SWEP:DrawHUD()
    BaseClass.DrawHUD(self) -- draw crosshair

    -- draw pre/post scope effect
    if tick < CurTime() then
      if not self:GetScoped() then
        -- start fade out at black
        if wasScoped then
          overlay = 1
          wasScoped = false
        end

        -- check ironsights
        if self:GetIronSights() then
          overlay = math.min(overlay + (.014 * (1 / self.ScopeInSpeed)), 1)
        else
          overlay = math.max(overlay - .03, 0)
        end
      else
        wasScoped = true
        overlay = math.max(overlay - .05, 0)
      end
      tick = CurTime() + .01
    end

    -- draw overlay
    tint.a = 255 * overlay
    draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), tint)

    -- draw scope
    if not self:GetScoped() then return end
    self:DrawScope()
  end

  -- hide viewmodel when scoped
  function SWEP:ShouldDrawViewModel()
    return not self:GetScoped()
  end

end
