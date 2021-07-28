local PANEL = {
    Init = function(self)

        self:SetSize(ScrW() / 2, ScrH() - 400)
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
        label:SetText("Peter's Workshop")
        label:SizeToContents()
        label:CenterHorizontal()
        label:AlignTop(10)

        local Frame = vgui.Create("DFrame", self)
        Frame:SetTitle("")
        Frame:SetDraggable(false)
        Frame:ShowCloseButton(false)
        Frame:SetSize(ScrW() / 2, ScrH() - 450)
        Frame:Dock(BOTTOM)
        --Frame:MakePopup()

        local labelColor = vgui.Create("DLabel", Frame)
        labelColor:SetFont("NpcFont")
        labelColor:SetText("Choose a new color for your vehicle (you need your car near)")
        labelColor:SizeToContents()
        labelColor:CenterHorizontal()
        labelColor:AlignTop(30)

        local ColorPicker = vgui.Create("DColorMixer", Frame)
        ColorPicker:SetSize(450, 450)
        ColorPicker:Center()
        ColorPicker:SetPalette(true)
        ColorPicker:SetAlphaBar(false)
        ColorPicker:SetWangs(true)
        ColorPicker:SetColor(Color(255, 255, 255))

        local ConfirmColor = vgui.Create("DButton", Frame)
        ConfirmColor:SetText("Apply (1000$)")
        ConfirmColor:SetSize(150, 50)
        ConfirmColor:CenterHorizontal()
        ConfirmColor:AlignBottom(10)

        ConfirmColor.DoClick = function()
            local color = ColorPicker:GetColor()
            net.Start("custom_car")
            net.WriteColor(Color(color.r, color.g, color.b))
            net.SendToServer()
            self:Remove()
        end

    end,

    Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawOutlinedRect(2, 2, w-4, h-4)
    end
}

vgui.Register("npc_carcustom_panel", PANEL)