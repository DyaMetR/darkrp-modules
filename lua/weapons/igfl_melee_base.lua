DEFINE_BASECLASS('weapon_base')

SWEP.Base                   = 'weapon_base'
SWEP.PrintName              = 'IGF Lite Melee Base'
SWEP.Author                 = 'DyaMetR'
SWEP.Instructions           = 'ATTACK to swing\nUSE + ATTACK to rise/lower'
SWEP.Category               = 'IGF Lite'
SWEP.Spawnable              = false
SWEP.m_WeaponDeploySpeed    = 1
SWEP.DrawCrosshair          = false
SWEP.UseHands               = true
SWEP.IsIGFLite              = true

SWEP.HoldType               = 'melee'
SWEP.HoldTypeHolster        = 'normal'

SWEP.Primary.Ammo           = 'none'
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.ClipSize       = -1
SWEP.Primary.Range          = 100 -- weapon range
SWEP.Primary.SwingViewPunch = Angle(0, 0, 0) -- view punch when swinging
SWEP.Primary.HitViewPunch   = Angle(0, 0, 0) -- view punch when hitting
SWEP.Primary.MissSound      = nil
SWEP.Primary.HitSound       = nil
SWEP.Primary.HitAnimation   = ACT_VM_HITCENTER
SWEP.Secondary.Ammo         = 'none'
SWEP.Trace = {}
SWEP.Bullet = {}

function SWEP:Deploy()
  self:UpdateHoldType()
  BaseClass.Deploy(self)
end

function SWEP:SetupDataTables()
  self:NetworkVar('Bool', 0, 'Holster')
  self:NetworkVar('Float', 1, 'NextSwing')
  self:NetworkVar('Bool', 2, 'ToIdleAnim')
  self:NetworkVar('Float', 3, 'NextIdle')
end

function SWEP:UpdateHoldType()
  if self:GetHolster() then
    self:SetHoldType(self.HoldTypeHolster)
  else
    self:SetHoldType(self.HoldType)
  end
end

function SWEP:HitLanded(trace)
  self:DoShootBullet(math.max(self.Primary.Range * trace.Fraction * 1.15))
end

function SWEP:DoShootBullet(distance)
  distance = distance or self.Primary.Range
  self.Bullet.Attacker = self:GetOwner()
  self.Bullet.Damage = self.Primary.Damage
  self.Bullet.Distance = math.min(distance, self.Primary.Range)
  self.Bullet.Dir = self:GetOwner():GetAimVector()
  self.Bullet.Src = self:GetOwner():GetShootPos()
  self.Bullet.IgnoreEntity = self:GetOwner()
  self:FireBullets(self.Bullet)
end

function SWEP:PrimaryAttack()
  if self:GetNextSwing() > CurTime() then return end
  if self:GetOwner():KeyDown(IN_USE) then
    self:SetHolster(not self:GetHolster())
    self:UpdateHoldType()
    self:SetNextSwing(CurTime() + self.Primary.Delay)
  else
    if not IsFirstTimePredicted() or self:GetHolster() then return end
    -- trace hit
    self.Trace.filter = self:GetOwner()
    self.Trace.start = self:GetOwner():GetShootPos()
    self.Trace.endpos = self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * self.Primary.Range)
    local result = util.TraceLine(self.Trace)
    -- check if something was hit
    if result.Hit then
      self:HitLanded(result)
      if SERVER then
        self:SendWeaponAnim(self.Primary.HitAnimation)
        -- emit sound
        if self.Primary.HitSound then
          local sound = self.Primary.HitSound
          if type(sound) == 'table' then sound = sound[math.random(1, #sound)] end
          self:GetOwner():EmitSound(sound)
        end
      end
      self:GetOwner():ViewPunch(self.Primary.HitViewPunch)
    else
      if SERVER then
        self:SendWeaponAnim(ACT_VM_MISSCENTER)
        -- emit sound
        if self.Primary.MissSound then
          local sound = self.Primary.MissSound
          if type(sound) == 'table' then sound = sound[math.random(1, #sound)] end
          self:GetOwner():EmitSound(sound)
        end
      end
      self:GetOwner():ViewPunch(self.Primary.SwingViewPunch)
    end
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    -- return to idle
    local animation_time = self:GetOwner():GetViewModel():SequenceDuration()
    self:SetNextIdle(CurTime() + animation_time)
    self:SetToIdleAnim(true)
    -- delay next swing
    self:SetNextSwing(CurTime() + self.Primary.Delay)
  end
end

function SWEP:SecondaryAttack()
  self:PrimaryAttack()
end

function SWEP:Think()
  if self:GetToIdleAnim() and self:GetNextIdle() < CurTime() then
    self:SetToIdleAnim(false)
    if SERVER then self:SendWeaponAnim(ACT_VM_IDLE) end
  end
end

if CLIENT then

  -- icon
  SWEP.UseFontIcon          = false
  SWEP.Icon                 = nil
  SWEP.IconFont             = 'igfl_icon_css'
  SWEP.IconBlurFont         = 'igfl_icon_css_blur'

  -- viewmodel
  SWEP.BasePos          = Vector(0, 0, 0)
  SWEP.BaseAng          = Vector(0, 0, 0)
  SWEP.SafePos          = Vector(0, 0, 0)
  SWEP.SafeAng          = Vector(0, 0, 0)

  -- current values
  SWEP.ViewModelPos         = Vector( 0, 0, 0 )
  SWEP.ViewModelAng         = Vector( 0, 0, 0 )

  -- transition to
  SWEP.DesiredViewModelPos  = Vector( 0, 0, 0 )
  SWEP.DesiredViewModelAng  = Vector( 0, 0, 0 )
  SWEP.TransitionSpeed  = 1

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
    --[[
    if self:IsSprinting() then

      if self:GetNextPrimaryFireSprint() > CurTime() then self.TransitionSpeed = 10 return end

      self.TransitionSpeed = 3
      self.DesiredViewModelPos:Set( self.SprintPos )
      self.DesiredViewModelAng:Set( self.SprintAng )
      return

    end]]

  end

  -- controls the viewmodel position and angle animations
  function SWEP:DoViewModelTransition( pos, ang )
    -- move to desired angle
    self.ViewModelAng.x = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.x, self.DesiredViewModelAng.x )
    self.ViewModelAng.y = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.y, self.DesiredViewModelAng.y )
    self.ViewModelAng.z = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelAng.z, self.DesiredViewModelAng.z )

    -- apply angle
    ang:RotateAroundAxis( ang:Right(), self.ViewModelAng.x )
    ang:RotateAroundAxis( ang:Up(), self.ViewModelAng.y )
    ang:RotateAroundAxis( ang:Forward(), self.ViewModelAng.z )

    -- move to desired position
    self.ViewModelPos.x = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.x, self.DesiredViewModelPos.x )
    self.ViewModelPos.y = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.y, self.DesiredViewModelPos.y )
    self.ViewModelPos.z = Lerp( FrameTime() * self.TransitionSpeed, self.ViewModelPos.z, self.DesiredViewModelPos.z )

    -- apply pos
    pos = pos + ( self.ViewModelPos.x * ang:Right() )
    pos = pos + ( self.ViewModelPos.y * ang:Forward() )
    pos = pos + ( self.ViewModelPos.z * ang:Up() )

    return pos, ang
  end

  -- calculate weapon position
  function SWEP:GetViewModelPosition( pos, ang )
    -- select viewmodel pos and ang
    self:SelectViewModelPosAng()
    -- do the view model position and angle transition
    pos, ang = self:DoViewModelTransition( pos, ang )
    return pos, ang
  end

  -- draw icon
  local colour = Color( 255, 235, 0, 255 )
  function SWEP:DrawWeaponSelection( x, y, w, h, alpha )
    if not self.UseFontIcon then BaseClass.DrawWeaponSelection(self, x, y, w, h, alpha) return end

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

end
