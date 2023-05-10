SWEP.Base                   = 'igfl_melee_base'
SWEP.PrintName              = 'FISTS'
SWEP.Author                 = 'DyaMetR'
SWEP.Category               = 'IGF Lite'
SWEP.Purpose                = 'Punch players on the head to stun them and run away'
SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.ViewModel              = 'models/weapons/c_hands.mdl'
SWEP.WorldModel             = 'models/weapons/w_hands.mdl'
SWEP.HoldType               = 'fist'
SWEP.HoldTypeHolster        = 'normal'

SWEP.Primary.Damage         = 5
SWEP.Primary.Delay          = 1
SWEP.Primary.Range          = 40
SWEP.Primary.SwingViewPunch = Angle(4, 4, 0)
SWEP.Primary.HitViewPunch   = Angle(-4, -3, 0)
SWEP.ViewModelFOV           = 55

if CLIENT then
  SWEP.SafePos              = Vector(0, 0, 0)
  SWEP.SafeAng              = Vector(-18, 0, -10)
end

function SWEP:Deploy()
  self:GetOwner():ChatPrint('This weapon is not finished. The concept is written on the file.')
end

-- TODO: after succesfully landing a hit, make a cooldown (hand hurt)
-- TODO: if the other player was hit on the head, set active weapon as NULL and disable weapon deployment; after some time ('stun' meter goes to 0), return to the previous weapon
-- TODO: knockback on successful hit
-- TODO: if the player was either hit on the stomach or the head, blur vision based on 'stun' meter (based on damage)
