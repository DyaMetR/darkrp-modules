local PANEL
local minHitDistanceSqr = GM.Config.minHealDistance * GM.Config.minHealDistance

--[[---------------------------------------------------------------------------
Medic menu
Taken from DarkRP's hitmenu module
https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/hitmenu/cl_menu.lua
---------------------------------------------------------------------------]]
PANEL = {}

AccessorFunc(PANEL, "medic", "Medic")
AccessorFunc(PANEL, "priceTag", "Price")

function PANEL:Init()
    self.BaseClass.Init(self)

    self.btnClose = vgui.Create("DButton", self)
    self.btnClose:SetText("")
    self.btnClose.DoClick = function() self:Remove() end
    self.btnClose.Paint = function(panel, w, h) derma.SkinHook("Paint", "WindowCloseButton", panel, w, h) end

    self.icon = vgui.Create("SpawnIcon", self)
    self.icon:SetDisabled(true)
    self.icon.PaintOver = function(icon) icon:SetTooltip() end
    self.icon:SetTooltip()

    self.title = vgui.Create("DLabel", self)
    self.title:SetText(RPExtraTeams[TEAM_MEDIC].name)

    self.name = vgui.Create("DLabel", self)
    self.price = vgui.Create("DLabel", self)

    self.bill = vgui.Create("DScrollPanel", self)

    self.btnRequest = vgui.Create("HitmanMenuButton", self)
    self.btnRequest:SetText(DarkRP.getPhrase("hitmenu_request"))
    self.btnRequest.DoClick = function()
          if IsValid(self:GetMedic()) then
            net.Start('medic_request')
            net.WriteEntity(self:GetMedic())
            net.SendToServer()
          end
          self:Remove()
    end

    self.btnCancel = vgui.Create("HitmanMenuButton", self)
    self.btnCancel:SetText(DarkRP.getPhrase("cancel"))
    self.btnCancel.DoClick = function() self:Remove() end

    self:SetSkin(GAMEMODE.Config.DarkRPSkin)

    self:InvalidateLayout()
end

function PANEL:Think()
    if not IsValid(self:GetMedic()) or self:GetMedic():GetPos():DistToSqr(LocalPlayer():GetPos()) > minHitDistanceSqr then
        self:Remove()
        return
    end
end

function PANEL:PerformLayout()
    local w, h = self:GetSize()

    self:SetSize(500, 700)
    self:Center()

    self.btnClose:SetSize(24, 24)
    self.btnClose:SetPos(w - 24 - 5, 5)

    self.icon:SetSize(128, 128)
    self.icon:SetModel(self:GetMedic():GetModel())
    self.icon:SetPos(20, 20)

    self.title:SetFont("ScoreboardHeader")
    self.title:SetPos(20 + 128 + 20, 20)
    self.title:SizeToContents(true)

    self.name:SizeToContents(true)
    self.name:SetText(DarkRP.getPhrase("name", self:GetMedic():Nick()))
    self.name:SetPos(20 + 128 + 20, 20 + self.title:GetTall())

    self.price:SetFont("HUDNumber5")
    self.price:SetColor(Color(255, 0, 0, 255))
    self.price:SetText(DarkRP.getPhrase("priceTag", DarkRP.formatMoney(self:GetPrice()), ""))
    self.price:SetPos(20 + 128 + 20, 20 + self.title:GetTall() + 20)
    self.price:SizeToContents(true)

    self.bill:SetPos(20, 20 + self.icon:GetTall() + 20)
    self.bill:SetWide(self:GetWide() - 40)

    self.btnRequest:SetPos(20, h - self.btnRequest:GetTall() - 20)
    self.btnRequest:SetButtonColor(Color(0, 120, 30, 255))

    self.btnCancel:SetPos(w - self.btnCancel:GetWide() - 20, h - self.btnCancel:GetTall() - 20)
    self.btnCancel:SetButtonColor(Color(140, 0, 0, 255))

    self.bill:StretchBottomTo(self.btnRequest, 20)

    self.BaseClass.PerformLayout(self)
end

function PANEL:Paint()
    local w, h = self:GetSize()

    surface.SetDrawColor(Color(0, 0, 0, 200))
    surface.DrawRect(0, 0, w, h)
end

function PANEL:AddBillBreakdown(breakdown)
  for _, fee in pairs(breakdown) do
    local line = vgui.Create("MedicMenuBillRow")
    line:SetLabel(fee.name)
    line:SetPrice(fee.price)
    self.bill:AddItem(line)
    line:SetWide(self.bill:GetWide() - 100)
    line:Dock(TOP)
  end
end

vgui.Register("MedicMenu", PANEL, "DPanel")

--[[---------------------------------------------------------------------------
Bill row
---------------------------------------------------------------------------]]
PANEL = {}

AccessorFunc(PANEL, "label", "Label")
AccessorFunc(PANEL, "price", "Price")

function PANEL:Init()
    self.lblLabel = vgui.Create("DLabel", self)
    self.lblLabel:SetColor(Color(255,255,255,200))

    self.lblPrice = vgui.Create("DLabel", self)
    self.lblPrice:SetColor(Color(255,255,255,200))
end

function PANEL:PerformLayout()
    self.lblLabel:SetFont("UiBold")
    self.lblLabel:SetText(DarkRP.deLocalise(self:GetLabel()))
    self.lblLabel:SizeToContents()
    self.lblLabel:SetPos(10, 1)

    self.lblPrice:SetFont("UiBold")
    self.lblPrice:SetText(DarkRP.formatMoney(self:GetPrice()))
    self.lblPrice:SizeToContents()
    self.lblPrice:SetPos(self:GetWide() - 10 - self.lblPrice:GetWide(), 1)
end

function PANEL:Paint() end

vgui.Register("MedicMenuBillRow", PANEL, "DPanel")

--[[---------------------------------------------------------------------------
Open the medic menu
---------------------------------------------------------------------------]]
function DarkRP.openMedicMenu(medic, price, breakdown)
    local frame = vgui.Create("MedicMenu")
    frame:SetMedic(medic)
    frame:SetPrice(price)
    frame:AddBillBreakdown(breakdown)
    frame:SetVisible(true)
    frame:MakePopup()
    frame:ParentToHUD()

    return frame
end
