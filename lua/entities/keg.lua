AddCSLuaFile()

DEFINE_BASECLASS( 'lab_base' )

ENT.Type      = 'anim'
ENT.Base      = 'lab_base'
ENT.PrintName = 'Keg'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false
ENT.IsKeg     = true

function ENT:initVars()

    self.model = 'models/props/de_inferno/wine_barrel.mdl'
    self.initialPrice = GAMEMODE.Config.kegdrinkcost
    self.labPhrase = DarkRP.getPhrase('keg')
    self.itemPhrase = DarkRP.getPhrase('beer')
    self.camMul = -60
    self.blastRadius = 0
    self.blastDamage = 0

end

if SERVER then

  function ENT:canUse( activator )

      if activator.maxDrinks and activator.maxDrinks >= GAMEMODE.Config.maxdrinks then

          DarkRP.notify( activator, 1, 3, DarkRP.getPhrase( 'limit', self.itemPhrase ) )
          return false

      end

      return true
  end

  function ENT:createItem( activator )

    local pos = self:GetPos() - ( self:GetAngles():Up() * self.camMul )

    local drink = ents.Create( 'spawned_beer' )
    drink:SetPos( pos )
    drink:Setowning_ent( activator )
    drink.nodupe = true
    drink:Spawn()

    if not activator.maxDrinks then

        activator.maxDrinks = 0

    end

    activator.maxDrinks = activator.maxDrinks + 1

  end

end
