AddCSLuaFile()

DEFINE_BASECLASS('sellitem_base')

ENT.Type        = 'anim'
ENT.Base        = 'sellitem_base'
ENT.PrintName   = 'Spawned stove food'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = false
ENT.IsStoveFood = true

ENT.foodItem    = 0

function ENT:initVars()
  self.itemPhrase = DarkRP.getFood(self:GetfoodItem()).name -- set name as item phrase
end

function ENT:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Int', 3, 'foodItem')
end

function ENT:salePrice()
  local cost = DarkRP.getFood(self:GetfoodItem()).price
  return math.Clamp(self:Getprice(), cost, GAMEMODE.Config.maxFoodPrice * cost)
end


if SERVER then

  function ENT:onEat(activator)
    -- Override this to give a special function upon eating it
  end

  function ENT:Initialize()
    self:SetfoodItem(self.foodItem) -- network food item variable
    BaseClass.Initialize(self)
  end

  function ENT:Use(activator, caller, use_type)
    local used = BaseClass.Use(self, activator, caller, use_type)
    if used then
      self:onEat(activator)
      activator:eat(DarkRP.getFood(self:GetfoodItem()).energy)
    end
  end

end
