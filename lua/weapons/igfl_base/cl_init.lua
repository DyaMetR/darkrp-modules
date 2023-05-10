include( 'shared.lua' )

-- create CSS fonts
surface.CreateFont( 'igfl_icon_css', {
  font = 'cs',
  size = ScreenScale( 49 ),
  additive = true
} )

surface.CreateFont( 'igfl_icon_css_blur', {
  font = 'cs',
  size = ScreenScale( 49 ),
  additive = true,
  blursize = 11,
  scanlines = 4
} )

-- create HL2 fonts
surface.CreateFont( 'igfl_icon_hl2', {
  font = 'HalfLife2',
  size = ScreenScale( 43 ),
  additive = true
} )

surface.CreateFont( 'igfl_icon_hl2_blur', {
  font = 'HalfLife2',
  size = ScreenScale( 43 ),
  additive = true,
  blursize = 11,
  scanlines = 4
} )

-- icon
SWEP.UseFontIcon          = false
SWEP.Icon                 = nil
SWEP.IconFont             = 'igfl_icon_css'
SWEP.IconBlurFont         = 'igfl_icon_css_blur'

-- viewmodel
SWEP.BasePos              = Vector( 0, 0, 0 )
SWEP.BaseAng              = Vector( 0, 0, 0 )
SWEP.IronSightsPos        = Vector( 0, 0, 0 )
SWEP.IronSightsAng        = Vector( 0, 0, 0 )
SWEP.SprintPos            = Vector( 0, 0, 0 )
SWEP.SprintAng            = Vector( 0, 0, 0 )
SWEP.SafePos              = Vector( 0, 0, 0 )
SWEP.SafeAng              = Vector( 0, 0, 0 )
SWEP.RecoilPos            = Vector( 0, -1, 0 )
SWEP.RecoilAng            = Vector( 0, 0, 0 )

-- current values
SWEP.ViewModelPos         = Vector( 0, 0, 0 )
SWEP.ViewModelAng         = Vector( 0, 0, 0 )

-- transition to
SWEP.DesiredViewModelPos  = Vector( 0, 0, 0 )
SWEP.DesiredViewModelAng  = Vector( 0, 0, 0 )
SWEP.TransitionSpeed      = 1

-- recoil tilt
SWEP.ViewModelKick        = false
SWEP.RecoilTilt           = 0
SWEP.RecoilLerp           = 0

-- offsets
local offset_back         = 0
local offset_side         = 0

-- select desired view model positions
function SWEP:SelectViewModelPosAng()

  -- idle
  self.TransitionSpeed = 1
  self.DesiredViewModelPos:Set( self.BasePos )
  self.DesiredViewModelAng:Set( self.BaseAng )

  -- holstered
  if self:GetHolster() then

    self.TransitionSpeed = 2
    self.DesiredViewModelPos:Set( self.SafePos )
    self.DesiredViewModelAng:Set( self.SafeAng )
    return

  end

  -- sprinting
  if self:IsSprinting() then

    if self:GetNextPrimaryFireSprint() > CurTime() then self.TransitionSpeed = 10 return end

    self.TransitionSpeed = 3
    self.DesiredViewModelPos:Set( self.SprintPos )
    self.DesiredViewModelAng:Set( self.SprintAng )
    return

  end

  -- ironsights
  if self:GetIronSights() then

    self.TransitionSpeed = 4 * (1 / self.IronSightsDelay)
    self.DesiredViewModelPos:Set( self.IronSightsPos )
    self.DesiredViewModelAng:Set( self.IronSightsAng )

  else

    self.TransitionSpeed = 2

  end

end

-- tilts the weapon view model simulating recoil
function SWEP:DoRecoilTilt()

  -- do kick animation
  if self.ViewModelKick then

    if self.RecoilTilt < 0.9 then

      self.RecoilTilt = Lerp( FrameTime() * ( 100 / ( self.Primary.Delay or 1 ) ), self.RecoilTilt, 1 )

    else

      self.ViewModelKick = false

    end

    self.RecoilLerp = self:GetRecoil()

  else

    self.RecoilTilt = Lerp( FrameTime() * ( 0.4 / self.RecoilRecovery ), self.RecoilTilt, 0 )
    self.RecoilLerp = Lerp(0.04, self.RecoilLerp, self:GetRecoil())

  end

  local recoil = self.RecoilTilt * ( 1 + self.RecoilLerp ) * ( 2 + self.BaseRecoil )
  local side_speed = 0.1
  if self:GetIronSights() then side_speed = 0.4 end

  -- soften offsets
  offset_side = Lerp( side_speed, offset_side, self:GetRecoilDirection() * recoil * self:GetCone() )
  offset_back = Lerp( 1, offset_back, recoil )

end

-- controls the viewmodel position and angle animations
function SWEP:DoViewModelTransition( pos, ang )

  -- recoil
  local recoil = 0
  if self:GetIronSights() then
    recoil = offset_back
  end

  -- move to desired angle
  self.ViewModelAng.x = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.x, self.DesiredViewModelAng.x )
  self.ViewModelAng.y = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.y, self.DesiredViewModelAng.y )
  self.ViewModelAng.z = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.z, self.DesiredViewModelAng.z )

  -- apply angle
  ang:RotateAroundAxis( ang:Right(), self.ViewModelAng.x )
  ang:RotateAroundAxis( ang:Up(), self.ViewModelAng.y + offset_side )
  ang:RotateAroundAxis( ang:Forward(), self.ViewModelAng.z )

  -- apply recoil
  ang:RotateAroundAxis( ang:Right(), self.RecoilAng.x * recoil )
  ang:RotateAroundAxis( ang:Up(), self.RecoilAng.y * recoil )
  ang:RotateAroundAxis( ang:Forward(), self.RecoilAng.z * recoil )

  -- move to desired position
  self.ViewModelPos.x = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.x, self.DesiredViewModelPos.x )
  self.ViewModelPos.y = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.y, self.DesiredViewModelPos.y )
  self.ViewModelPos.z = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.z, self.DesiredViewModelPos.z )

  -- apply pos
  pos = pos + ( self.ViewModelPos.x * ang:Right() )
  pos = pos + ( self.ViewModelPos.y * ang:Forward() )
  pos = pos + ( self.ViewModelPos.z * ang:Up() )

  -- apply recoil
  pos = pos + ( self.RecoilPos.x * ang:Right() * recoil )
  pos = pos + ( self.RecoilPos.y * ang:Forward() * recoil )
  pos = pos + ( self.RecoilPos.z * ang:Up() * recoil )

  return pos, ang

end

-- calculate weapon position
function SWEP:GetViewModelPosition( pos, ang )

  -- do the firing recoil weapon kick
  self:DoRecoilTilt()

  -- select viewmodel pos and ang
  self:SelectViewModelPosAng()

  -- do the view model position and angle transition
  pos, ang = self:DoViewModelTransition( pos, ang )

  return pos, ang

end

-- draw crosshair
local cone = 0
function SWEP:DrawHUD()

  if self:GetIronSights() or self:GetHolster() then return end

  local w, h = 4, 12

  cone = Lerp( 0.4, cone, self:GetCone() * 600 )

  surface.SetDrawColor( 0, 0, 0 )
  surface.DrawRect( ( ScrW() * .5 ) - ( w * .5 ), ( ( ScrH() * .5 ) - h ) - cone, w, h )
  surface.DrawRect( ( ScrW() * .5 ) - ( w * .5 ), ( ScrH() * .5 ) + cone, w, h )
  surface.DrawRect( ( ( ScrW() * .5 ) - h ) - cone, ( ScrH() * .5 ) - ( w * .5 ), h, w )
  surface.DrawRect( ( ScrW() * .5 ) + cone, ( ScrH() * .5 ) - ( w * .5 ), h, w )
  w = w - 2
  h = h - 2
  surface.SetDrawColor( 255, 255, 255 )
  surface.DrawRect( ( ScrW() * .5 ) - ( w * .5 ), ( ( ScrH() * .5 ) - h ) - cone - 1, w, h )
  surface.DrawRect( ( ScrW() * .5 ) - ( w * .5 ), ( ScrH() * .5 ) + cone + 1, w, h )
  surface.DrawRect( ( ( ScrW() * .5 ) - h ) - cone - 1, ( ScrH() * .5 ) - ( w * .5 ), h, w )
  surface.DrawRect( ( ScrW() * .5 ) + cone + 1, ( ScrH() * .5 ) - ( w * .5 ), h, w )
  --surface.DrawCircle( ScrW() * .5, ScrH() * .5, self:GetCone() * 600, 255, 255, 255, 255 )

end

-- draw icon
local colour = Color( 255, 235, 0, 255 )
function SWEP:DrawWeaponSelection( x, y, w, h, alpha )
  if not self.UseFontIcon then return end

  -- draw icon
  colour.a = alpha
  draw.SimpleText( self.Icon, self.IconFont, x + ( w * .5 ), y + ( h * .5 ), colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  if self.IconBlurFont then
    draw.SimpleText( self.Icon, self.IconBlurFont, x + ( w * .5 ), y + ( h * .5 ), colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

  self:PrintWeaponInfo( x + w + 10, y + h, alpha )
end

-- draw info
function SWEP:PrintWeaponInfo( x, y, alpha )

	if ( self.DrawWeaponInfoBox == false ) then return end

	if (self.InfoMarkup == nil ) then

		local str
		local title_color = "<color=30,160,30,255>"
		local text_color = "<color=225,225,225,255>"

		str = "<font=HudSelectionText>"
		if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
		if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n" end
		if ( self.Purpose != "" ) then str = str .. title_color .. "Details:</color>\n"..text_color..self.Purpose.."</color>\n" end
    --str = str .. title_color .. "Feed:</color>\t\t" .. text_color .. language.GetPhrase( self.Primary.Ammo .. '_ammo' ) .. "</color>\n"
		if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..self.Instructions.."</color>\n" end
		str = str .. "</font>"

		self.InfoMarkup = markup.Parse( str, 250 )

	end

	surface.SetDrawColor( 0, 0, 0, alpha * .5 )
	surface.SetTexture( self.SpeechBubbleLid )

	surface.DrawTexturedRect( x, y - 64 - 5, 128, 63 )
	draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 0, 0, 0, alpha * .5 ) )

	self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )

end
