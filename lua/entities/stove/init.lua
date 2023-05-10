include( 'shared.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'cl_init.lua' )

local NET_MENU = 'stove_menu'
local NET_BUY = 'stove_buy'
local BLAST_RADIUS = 100
local BLAST_DAMAGE = 100
local DISTANCE = 200

-- add network strings
util.AddNetworkString( NET_MENU )
util.AddNetworkString( NET_BUY )

-- receive food to make
net.Receive( NET_BUY, function( len, _player )

  local ent = net.ReadEntity()
  local food = net.ReadFloat()

  if not IsValid( ent ) or ent:GetClass() ~= 'stove' then return end
  ent:cookFood( _player, food )

end )

--[[---------------------------------------------------------------------------
  Opens the menu
]]-----------------------------------------------------------------------------
function ENT:Use( activator, called, use_type )

  if not activator:IsPlayer() then return end

  if not activator:isCook() then
    DarkRP.notify( activator, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'cooks_only' ) )
    return
  end

  net.Start( NET_MENU )
  net.WriteEntity( self )
  net.Send( activator )

end

--[[---------------------------------------------------------------------------
  Cooks the given meal
  @param {Player} cook
  @param {number} food
]]-----------------------------------------------------------------------------
function ENT:cookFood( cook, food )

  local _food = DarkRP.getFood( food )

  if not cook:IsPlayer() or not _food or timer.Exists( self:GetClass() .. self:EntIndex() ) then
    return
  end

  -- check that the player isn't cheating
  if not cook:GetEyeTrace().Hit or cook:GetEyeTrace().Entity ~= self or self:GetPos():Distance( cook:GetPos() ) > DISTANCE then
    return
  end

  if not cook:isCook() then
    DarkRP.notify( cook, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'cooks_only' ) )
    return
  end

  if cook:getDarkRPVar( 'money' ) < _food.price then
    DarkRP.notify( cook, NOTIFY_ERROR, 4, DarkRP.getPhrase( 'cant_afford', _food.name ) )
    return
  end

  -- take money and notify
  cook:addMoney( -_food.price )
  DarkRP.notify( cook, NOTIFY_GENERIC, 4, DarkRP.getPhrase( 'stove_food', _food.name, DarkRP.formatMoney( _food.price ) ) )
  self.sparking = true

  -- delay food creation
  timer.Create( self:GetClass() .. self:EntIndex(), 1, 1 , function()

    if not IsValid( self ) or not IsValid( cook ) then return end

    local stovefood = ents.Create( 'spawned_stovefood' )
    stovefood:SetPos( self:GetPos() + Vector( 0, 0, 30 ) )
    stovefood:Setowning_ent( cook )
    stovefood.model = _food.model
    stovefood.foodItem = food
    stovefood.initialPrice = _food.price * GAMEMODE.Config.foodDefaultProfit

    -- menu card entity support
    if cook.CookMenuCard and cook.CookMenuCard.prices[food] then
      stovefood.initialPrice = cook.CookMenuCard.prices[food]
    end

    if _food.onEat then
      stovefood.onEat = _food.onEat
    end

    stovefood:Spawn()
    self.sparking = false

  end )

end

--[[---------------------------------------------------------------------------
  Throw sparks if it's cooking something
]]-----------------------------------------------------------------------------
function ENT:Think()

  if self.sparking then

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect('Sparks', effectdata)

  end

end

--[[---------------------------------------------------------------------------
  Makes the stove explode
]]-----------------------------------------------------------------------------
function ENT:Destruct()

  local vPoint = self:GetPos()

  util.BlastDamage(self, self, vPoint, BLAST_RADIUS, BLAST_DAMAGE)
  util.ScreenShake(vPoint, 512, 255, 1.5, 200)

  local effectdata = EffectData()
  effectdata:SetStart(vPoint)
  effectdata:SetOrigin(vPoint)
  effectdata:SetScale(1)
  util.Effect(self:WaterLevel() > 1 and 'WaterSurfaceExplosion' or 'Explosion', effectdata)
  util.Decal('Scorch', vPoint, vPoint - Vector(0, 0, 25), self)

  -- notify user
  DarkRP.notify(self:Getowning_ent(), NOTIFY_ERROR, 4, DarkRP.getPhrase('stove_destroyed'))

end

--[[---------------------------------------------------------------------------
  Make the stove take damage until it explodes
]]-----------------------------------------------------------------------------
function ENT:OnTakeDamage(dmg)

  self:TakePhysicsDamage(dmg)
  self.damage = self.damage - dmg:GetDamage()

  if self.damage <= 0 and not self.Destructed then
      self.Destructed = true
      self:Destruct()
      self:Remove()
  end

end

--[[---------------------------------------------------------------------------
  Remove all menu cards
]]-----------------------------------------------------------------------------
function ENT:OnRemove()
  local owner = self:Getowning_ent()
  if IsValid(owner) then
    owner.stoveEntity = nil
    if owner.removeAllMenuCards then
      owner:removeAllMenuCards()
    end
  end
end
