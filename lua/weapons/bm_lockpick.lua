AddCSLuaFile()

DEFINE_BASECLASS( 'lockpick' )

SWEP.Base         = 'lockpick'
SWEP.PrintName    = 'Counterfeit Lock Pick'
SWEP.Author       = 'DarkRP developers & DyaMetR'
SWEP.Purpose      = 'Break into other people\'s properties.\nIt has a 33% chance of breaking down after use.'
SWEP.Category           = 'DarkRP (Utility)'
SWEP.Spawnable          = true
SWEP.AdminOnly          = true

SWEP.BreakChance  = 33

if SERVER then

  DarkRP.addPhrase( 'en', 'lockpick_broke', 'Your lock pick broke down.' )

  function SWEP:Succeed()

    BaseClass.Succeed( self )

    -- have a chance at breaking down
    if math.random( 1, 100 ) <= self.BreakChance then

      self:Remove()
      DarkRP.notify( self:GetOwner(), 1, 4, DarkRP.getPhrase('lockpick_broke') )

    end

  end

end
