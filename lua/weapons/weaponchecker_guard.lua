AddCSLuaFile()

DEFINE_BASECLASS('weaponchecker')
SWEP.Base         = 'weaponchecker'
SWEP.MinCheckTime = 2
SWEP.MaxCheckTime = 4
SWEP.Spawnable    = true
SWEP.AdminOnly    = true
SWEP.Instructions = 'Left click to weapon check'
SWEP.Category     = 'DarkRP (Utility)'

DarkRP.addPhrase('en', 'persons_weapons_neutral', '%s\'s is carrying:')

-- change label
function SWEP:PrintWeapons(ent, weaponsFoundPhrase)
  BaseClass.PrintWeapons(self, ent, DarkRP.getPhrase('persons_weapons_neutral', ent:Name()))
end

-- do not confiscate
function SWEP:SecondaryAttack()
  self:PrimaryAttack()
end

function SWEP:Reload() end
