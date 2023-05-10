AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.SeizeReward = 950
ENT.Damage = 100
ENT.PrintAmount = 250
ENT.OverheatChance = 22
ENT.Model = "models/props_c17/consolebox01a.mdl"
ENT.Sound = "ambient/levels/labs/equipment_printer_loop1.wav"
ENT.SoundLevel = 52
ENT.MinPrintTime = 100
ENT.MaxPrintTime = 350

ENT.MoneyHeightOffset = 0

local PrintMore
function ENT:Initialize()
    self:SetModel( self.Model )
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.sparking = false
    self.damage = self.Damage
    self.IsMoneyPrinter = true
    timer.Simple(math.random(self.MinPrintTime, self.MaxPrintTime), function() PrintMore(self) end)

    self.sound = CreateSound(self, Sound(self.Sound))
    self.sound:SetSoundLevel(self.SoundLevel)
    self.sound:PlayEx(1, 100)
end

function ENT:OnTakeDamage(dmg)
    if self.burningup then return end

    self.damage = (self.damage or 100) - dmg:GetDamage()
    if self.damage <= 0 then
        local rnd = math.random(1, 10)
        if rnd < 3 then
            self:BurstIntoFlames()
        else
            self:Destruct()
            self:Remove()
        end
    end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
    DarkRP.notify(self:Getowning_ent(), 1, 4, DarkRP.getPhrase("money_printer_exploded"))
end

function ENT:BurstIntoFlames()
    DarkRP.notify(self:Getowning_ent(), 0, 4, DarkRP.getPhrase("money_printer_overheating"))
    self.burningup = true
    local burntime = math.random(8, 18)
    self:Ignite(burntime, 0)
    timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
    if not self:IsOnFire() then self.burningup = false return end
    local dist = math.random(20, 280) -- Explosion radius
    self:Destruct()
    for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
        if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
            v:Ignite(math.random(5, 22), 0)
        elseif v:IsPlayer() then
            local distance = v:GetPos():Distance(self:GetPos())
            v:TakeDamage(distance / dist * 100, self, self)
        end
    end
    self:Remove()
end

PrintMore = function(ent)
    if not IsValid(ent) then return end

    ent.sparking = true
    timer.Simple(3, function()
        if not IsValid(ent) then return end
        ent:CreateMoneybag()
    end)
end

function ENT:CreateMoneybag()
    if not IsValid(self) or self:IsOnFire() then return end

    local MoneyPos = self:GetPos()

    if GAMEMODE.Config.printeroverheat then
        if math.random(1, math.max( self.OverheatChance, 3 ) ) == 3 then self:BurstIntoFlames() end
    end

    local amount = self.PrintAmount
    if amount == 0 then
        amount = 250
    end

    local moneyBag = DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15 + self.MoneyHeightOffset), amount)
    hook.Run('moneyPrinterPrinted', self, moneyBag)
    self.sparking = false
    timer.Simple(math.random(self.MinPrintTime, self.MaxPrintTime), function() PrintMore(self) end)
end

function ENT:Think()

    if self:WaterLevel() > 0 then
        self:Destruct()
        self:Remove()
        return
    end

    if not self.sparking then return end

    local effectdata = EffectData()
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetMagnitude(1)
    effectdata:SetScale(1)
    effectdata:SetRadius(2)
    util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
    if self.sound then
        self.sound:Stop()
    end
end
