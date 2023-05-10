ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Customizable Money Printer Base"
ENT.Author = "DarkRP Developers and DyaMetR"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "price")
    self:NetworkVar("Entity", 0, "owning_ent")
end
