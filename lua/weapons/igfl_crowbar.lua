SWEP.Base                   = 'igfl_melee_base'
SWEP.PrintName              = 'CROWBAR'
SWEP.Author                 = 'DyaMetR'
SWEP.Category               = 'IGF Lite'
SWEP.Spawnable              = true
SWEP.SlotPos                = 3

SWEP.ViewModel              = 'models/weapons/c_crowbar.mdl'
SWEP.WorldModel             = 'models/weapons/w_crowbar.mdl'
SWEP.HoldType               = 'melee2'
SWEP.HoldTypeHolster        = 'passive'

SWEP.Primary.Damage         = 25
SWEP.Primary.Delay          = .9
SWEP.Primary.Range          = 90
SWEP.Primary.SwingViewPunch = Angle(4, 4, 0)
SWEP.Primary.HitViewPunch   = Angle(-4, -3, 0)
SWEP.Primary.MissSound      = 'weapons/slam/throw.wav'
SWEP.ViewModelFOV           = 55

if CLIENT then
  SWEP.UseFontIcon          = true
  SWEP.Icon                 = 'c'
  SWEP.IconFont             = 'igfl_icon_hl2'
  SWEP.IconBlurFont         = 'igfl_icon_hl2_blur'
  SWEP.SafePos              = Vector(0, 0, -8)
  SWEP.SafeAng              = Vector(-10, 10, -20)
end
