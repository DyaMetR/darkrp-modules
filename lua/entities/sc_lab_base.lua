AddCSLuaFile()

DEFINE_BASECLASS('sc_base')

ENT.Type                = 'anim'
ENT.Base                = 'sc_base'
ENT.PrintName           = 'Scientist Lab Entity Base'
ENT.Author              = 'DyaMetR'
ENT.Spawnable           = false

ENT.producing           = false -- production state

ENT.recipes             = nil -- items to craft and their ingredient requirements
ENT.acceptedIngredients = {} -- ingredients accepted by the lab
ENT.productionTime      = 2 -- time to produce item
ENT.spawnPos            = Vector(0, 0, 0) -- relative position to spawn the item

function ENT:SetupDataTables()
  BaseClass.SetupDataTables(self)
  self:NetworkVar('Bool', 1, 'hasIngredients')
end

function ENT:Initialize()
  BaseClass.Initialize(self)
  if SERVER then
    local recipes = DarkRP.getDrugLabRecipes(self:GetClass())
    if recipes then
      self.recipes = recipes
      for recipe, data in pairs(recipes) do
        for _, ingredient in pairs(data.ingredients) do
          self.acceptedIngredients[ingredient] = true
        end
      end
    end
  end
end

if SERVER then

  -- TODO: do ingredient retreiving

  local INGREDIENT_CLASS = 'spawned_ingredient'

  ENT.Ingredients = {}
  ENT.sparking    = false

  function ENT:PhysicsCollide(data, collider)
    if not self.recipes then return end
    if not IsValid(data.HitEntity) or data.HitEntity:GetClass() ~= INGREDIENT_CLASS then return end
    local class = data.HitEntity.class
    if not self.acceptedIngredients[class] or self.Ingredients[class] or self.producing then return end
    self:SethasIngredients(true)
    self.Ingredients[class] = true
    data.HitEntity:Remove()
    self:CheckCompleteRecipes()
  end

  function ENT:CheckCompleteRecipes()
    for recipe, data in pairs(self.recipes) do
      local i = 0
      for _, ingredient in pairs(data.ingredients) do
        if self.Ingredients[ingredient] then
          i = i + 1
        end
      end
      if i >= table.Count(data.ingredients) then
        self:ProduceRecipe(recipe)
        break
      end
    end
    self:SethasIngredients(table.Count(self.Ingredients) > 0)
  end

  function ENT:ProduceRecipe(recipe)
    for _, ingredient in pairs(self.recipes[recipe].ingredients) do
      self.Ingredients[ingredient] = nil
    end
    self.sparking = true
    if not self.producing then
      timer.Simple(self.productionTime, function()
        if not IsValid(self) then return end
        self.sparking = false

        -- get relative position
        local pos = self:GetPos()
        pos = pos + (self:GetAngles():Forward() * self.spawnPos.x)
        pos = pos + (self:GetAngles():Right() * self.spawnPos.y)
        pos.z = pos.z + self.spawnPos.z

        -- spawn entity
        local ent = ents.Create(recipe)
        ent:SetPos(pos)
        ent:Spawn()

        self.producing = false
      end)
      self.producing = true
    end
  end

  function ENT:Think()
    if not self.sparking then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)
  end
end

if CLIENT then

  function ENT:Draw()
    self:DrawModel()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()

    surface.SetFont("HUDNumber5")
    local text = self.PrintName
    local text2 = DarkRP.getPhrase('sclab_hasingredients', string.upper(input.LookupBinding('+use')))
    local TextWidth = surface.GetTextSize(text)
    local TextWidth2 = surface.GetTextSize(text2)

    if self.RotatingLabel then
      Ang:RotateAroundAxis(Ang:Forward(), 90)

      Ang:RotateAroundAxis(Ang:Right(), CurTime() * -180)

      Pos = Pos + Ang:Right() * self.LabelPos.y
    else
      Pos = Pos + Ang:Forward() * self.LabelPos.x
      Pos = Pos + Ang:Right() * self.LabelPos.y
      Pos = Pos + Ang:Up() * self.LabelPos.z
      Ang = self.LabelAng
    end

    cam.Start3D2D(Pos, Ang, 0.1)
      local y = -30
      if self:GethasIngredients() then
        draw.WordBox(2, -TextWidth2 * 0.5 + 5, y, text2, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
        y = y - 33
      end
      draw.WordBox(2, -TextWidth * 0.5 + 5, y, text, "HUDNumber5", Color(140, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
  end

end
