AddCSLuaFile()

DEFINE_BASECLASS( 'sellitem_base' )

ENT.Type        = 'anim'
ENT.Base        = 'sellitem_base'
ENT.PrintName   = 'Weed'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false

-- maximum price
ENT.maxPrice    = 120

function ENT:initVars()

  self.model = 'models/props_junk/garbage_bag001a.mdl'
  self.damage = 20
  self.initialPrice = 60
  self.itemPhrase = DarkRP.getPhrase( 'weed' )

end

--[[---------------------------------------------------------------------------
  Returns the final buying price
]]-----------------------------------------------------------------------------
function ENT:salePrice()
  return math.min(self:Getprice(), self.maxPrice)
end

if SERVER then

  function ENT:Use( activator, caller, use_type )

    if not BaseClass.Use( self, activator, caller, use_type ) then return end
    activator:addStatus('weed', 'weed')

  end

end
