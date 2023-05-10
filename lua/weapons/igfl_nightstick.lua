SWEP.Base                   = 'igfl_melee_base'
SWEP.PrintName              = 'NIGHTSTICK'
SWEP.Author                 = 'DyaMetR'
SWEP.Category               = 'IGF Lite'
SWEP.Spawnable              = true
SWEP.SlotPos                = 4

SWEP.ViewModel              = 'models/weapons/c_stunstick.mdl'
SWEP.WorldModel             = 'models/weapons/w_stunbaton.mdl'

SWEP.Primary.Damage         = 16
SWEP.Primary.Delay          = .6
SWEP.Primary.Range          = 80
SWEP.Primary.SwingViewPunch = Angle(1, 2, 0)
SWEP.Primary.HitViewPunch   = Angle(-2, -2, 0)
SWEP.Primary.MissSound      = 'weapons/iceaxe/iceaxe_swing1.wav'
SWEP.ViewModelFOV           = 55

if CLIENT then
  SWEP.UseFontIcon          = true
  SWEP.Icon                 = 'n'
  SWEP.IconFont             = 'igfl_icon_hl2'
  SWEP.IconBlurFont         = 'igfl_icon_hl2_blur'
  SWEP.SafePos              = Vector(0, 0, -8)
  SWEP.SafeAng              = Vector(-10, 10, -20)
end
