AddCSLuaFile()

DEFINE_BASECLASS( 'unarrest_stick' )

SWEP.Base               = 'unarrest_stick'
SWEP.PrintName          = 'Counterfeit Unarrest Baton'
SWEP.Author             = 'DarkRP developers & DyaMetR'
SWEP.Purpose            = 'Take your partners out of jail.\nIt has a 75% chance of breaking down after use.'
SWEP.Category           = 'DarkRP (Utility)'
SWEP.Spawnable          = true
SWEP.AdminOnly          = true

SWEP.IsCounterfeitBaton = true
SWEP.BreakChance        = 75

if SERVER then

  DarkRP.addPhrase( 'en', 'unarrest_stick_broke', 'Your unarrest baton broke down.' )

  -- removes the unarrest baton
  function SWEP:BreakDown( owner )

    if math.random( 1, 100 ) > self.BreakChance then return end

    self:Remove()
    DarkRP.notify( self:GetOwner(), 1, 4, DarkRP.getPhrase('unarrest_stick_broke') )

  end

  -- detect players being unarrested
  hook.Add( 'playerUnArrested', 'bm_unarrest_stick_unarrest', function( criminal, actor )

    if actor and IsValid( actor ) and actor:IsPlayer() and IsValid( actor:GetActiveWeapon() ) and actor:GetActiveWeapon().IsCounterfeitBaton then

      actor:GetActiveWeapon():BreakDown()

    end

  end )

end
