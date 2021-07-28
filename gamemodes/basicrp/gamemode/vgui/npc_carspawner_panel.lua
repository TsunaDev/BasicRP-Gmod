local PANEL = {
    Init = function(self)

        self:SetSize(ScrW() / 2, ScrH() - 200)
        self:Center()
        self:MakePopup()

        local x, y = self:GetSize()

        local button = vgui.Create("DButton", self)
        button:SetText("X")
        button:SetFont("MenuFont")
        button:SetSize(50, 30)
        button:SetPos(x - 50, 10)
        function button:Paint(w, h)
            if button:IsDown() or button:IsHovered() then
                button:SetColor(Color(255, 0, 0, 255))
            else
                button:SetColor(Color(255, 255, 255, 255))
            end
        end
        button.DoClick = function()
            self:Remove()
        end

        local label = vgui.Create("DLabel", self)
        label:SetFont("MenuFont")
        label:SetText("Edgar's Car Delivery")
        label:SizeToContents()
        label:CenterHorizontal()
        label:AlignTop(10)

        local sheet = vgui.Create("DPropertySheet", self);
        sheet:StretchToParent(5, 40, 5, 5);
        local sheetPanel = vgui.Create("DPanelList", sheet)
        sheetPanel:StretchToParent(5, 30, 5, 5)
        sheetPanel:SetPadding(5)
        sheetPanel:SetSpacing(5)
        sheetPanel:EnableVerticalScrollbar(true)

        for k, vehicle in pairs(VehiclesList) do
            if (GAMEMODE:CheckPlayerCars(vehicle.ID) > 0) then
                local card = vgui.Create("npc_carspawner_card", sheetPanel)
                card:SetProperty(vehicle)
                sheetPanel:AddItem(card)
            end
        end
    end,

    Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawOutlinedRect(2, 2, w-4, h-4)
    end
}

vgui.Register("npc_carspawner_panel", PANEL)