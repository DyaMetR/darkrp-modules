AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'base_gmodentity'
ENT.PrintName   = 'Sellable item base'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false
ENT.CanSetPrice = true

-- These are variables that should be set in entities that base from this
ENT.model = ""
ENT.initialPrice = 0
ENT.itemPhrase = ""
ENT.damage = -1 -- unbreakable

function ENT:initVars()
    -- Implement this to set the above variables
end

function ENT:SetupDataTables()

    self:NetworkVar('Int', 0, 'price')
    self:NetworkVar('Entity', 1, 'owning_ent')
    self:NetworkVar('String', 2, 'itemPhrase')

end

function ENT:Initialize()

  self:initVars()

  -- set SID
  self.SID = self:Getowning_ent().SID

  -- set model
  self:SetModel( self.model )

  if SERVER then

    -- initialize networked variables
    self:SetitemPhrase( self.itemPhrase )
    self:Setprice( self.initialPrice or 50 )

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():Wake()
    end

  end

end

--[[---------------------------------------------------------------------------
  Returns the final buying price
]]-----------------------------------------------------------------------------
function ENT:salePrice()
  return self:Getprice() -- override this with a custom price clamping
end

if SERVER then

  function ENT:OnTakeDamage( dmg_info )

    if self.damage <= -1 then return end

    if dmg_info:GetDamage() > self.damage then
      self:Remove()
    else
      self.damage = self.damage - dmg_info:GetDamage()
    end

  end

  function ENT:Use( activator, caller, use_type )

    if not activator:IsPlayer() then return end

    -- check owner
    local Owner = self:Getowning_ent()
    if not IsValid(Owner) then return end

    -- check whether it can be used
    local canUse, reason = hook.Call( 'canDarkRPUse', nil, activator, self, caller )
    if canUse == false then
      if reason then DarkRP.notify( activator, 1, 4, reason ) end
      return
    end

    -- buy food from owner
    if activator ~= self:Getowning_ent() then
      if activator:getDarkRPVar( 'money' ) < self:salePrice() then
        DarkRP.notify( activator, 1, 4, DarkRP.getPhrase( 'cant_afford', self:GetitemPhrase() ) )
        return
      end
      DarkRP.payPlayer( activator, Owner, self:salePrice() )
      DarkRP.notify( activator, 0, 4, DarkRP.getPhrase( 'you_bought', self:GetitemPhrase(), DarkRP.formatMoney( self:salePrice() ) ) )
      DarkRP.notify( Owner, 0, 4, DarkRP.getPhrase( 'you_received_x', DarkRP.formatMoney( self:salePrice() ), self:GetitemPhrase() ) )
    end

    self:Remove()

    return true

  end

end

if CLIENT then

  function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

    surface.SetFont("HUDNumber5")
    local text = self:GetitemPhrase()
    local text2 = DarkRP.getPhrase("priceTag", DarkRP.formatMoney(self:salePrice()), "")
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(text2)

    Ang:RotateAroundAxis(Ang:Forward(), 90)
    local TextAng = Ang

    TextAng:RotateAroundAxis(TextAng:Right(), CurTime() * -180)

    cam.Start3D2D(Pos + Ang:Right() * -15, TextAng, 0.2)
        draw.WordBox(2, -TextWidth * 0.5 + 5, -30, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        draw.WordBox(2, -TextWidth2 * 0.5 + 5, 18, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
  end

end
