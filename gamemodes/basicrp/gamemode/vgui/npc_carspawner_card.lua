local PANEL = {}

function PANEL:Init()
    local width = ScrW() / 2 < 800 && ScrW() / 2 || 800
    self:SetSize(width, 150)
    self:DockPadding(10, 10, 10, 10)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
end

function PANEL:SetProperty(vehicle)
    local image = vgui.Create("DImage", self)
    image:SetSize(130, 0)
    image:DockMargin(0, 0, 10, 0)
    image:SetImage(vehicle.Material)
    image:Dock(LEFT)

    button = vgui.Create("DButton", self)
    button:SetText("Choose")
    button:SetFont("NpcFont")
    button:SetSize(150, 0)
    button:DockMargin(0, 40, 20, 40)
    button:Dock(RIGHT)

    button.DoClick = function()
        net.Start("spawn_car")
        net.WriteInt(vehicle.ID, 8)
        net.SendToServer()
        self:GetParent():GetParent():GetParent():GetParent():Remove()
    end

    local title = vgui.Create("DLabel", self)
    title:SetFont("PropertyTitleFont")
    title:SetText(vehicle.Name)
    title:SizeToContents()
    title:DockMargin(0, 5, 0, 0)
    title:Dock(TOP)

    local price = vgui.Create("DLabel", self)
    price:SetFont("PropertyTitleFont")
    price:SetText(tostring(vehicle.Price) .. " $")
    price:SizeToContents()
    price:DockMargin(0, 20, 0, 0)
    price:Dock(TOP)

end

vgui.Register("npc_carspawner_card", PANEL)