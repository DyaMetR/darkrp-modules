AddCSLuaFile()

DEFINE_BASECLASS( 'spawned_shipment' )

ENT.Type      = 'anim'
ENT.Base      = 'spawned_shipment'
ENT.PrintName = 'Spawned standalone entity shipment'
ENT.Author    = 'DyaMetR'
ENT.Spawnable = false

if SERVER then

  function ENT:SpawnItem()

    timer.Remove(self:EntIndex() .. "crate")
    self.sparking = false
    local count = self:Getcount()
    if count <= 1 then self:Remove() end
    local contents = self:Getcontents()

    if CustomShipments[contents] and CustomShipments[contents].spawn then self.USED = false return CustomShipments[contents].spawn(self, CustomShipments[contents]) end

    local ang = self:GetAngles()
    local pos = self:GetAngles():Up() * 40 + ang:Up() * (math.sin(CurTime() * 3) * 8)
    ang:RotateAroundAxis(ang:Up(), (CurTime() * 180) % 360)

    if not CustomShipments[contents] then
        self:Remove()
        return
    end

    local class = CustomShipments[contents].entity
    local model = CustomShipments[contents].model

    local entity = ents.Create(class)
    entity:SetModel(model)
    entity:SetPos(self:GetPos() + pos)
    entity:SetAngles(ang)
    entity.nodupe = true
    entity:Spawn()
    count = count - 1
    self:Setcount(count)
    self.locked = false
    self.USED = nil

  end

end
