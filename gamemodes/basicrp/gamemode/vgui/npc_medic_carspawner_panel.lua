local PANEL = {
    Init = function(self)

        self:SetSize(ScrW() / 4, 200)
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
            self:Remove();
        end

        local label = vgui.Create("DLabel", self);
        label:SetFont("MenuFont");
        label:SetText("George - Medic Intendant");
        label:SizeToContents();
        label:CenterHorizontal();
        label:AlignTop(10);

        local mainPanel = vgui.Create("DPanel", self);
        mainPanel:SetPos(3, 45);
        mainPanel:SetSize(x - 6, y - 35 - 3);
        mainPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100));
        end

        if LocalPlayer():Team() == TEAM_MEDIC then
            local spawnButton = vgui.Create("DButton", mainPanel);
            spawnButton:SetText("Get Medic Vehicle");
            spawnButton:SetFont("NpcFont");
            spawnButton:SetSize(150, 30);
            --spawnButton:DockMargin(0, 0, 0, 60);
            spawnButton:SetContentAlignment(5);
            spawnButton:Dock(TOP);
            spawnButton.DoClick = function ()
                net.Start("spawn_medic_car");
                net.SendToServer();
                self:Remove();
            end
        else
            local text = vgui.Create("DLabel", self);
            text:SetFont("PropertyTitleFont");
            text:SetText("To join the medics, speak to the recruiter");
            text:SizeToContents();
            text:SetContentAlignment(5);
            --text:DockMargin(80, 0, 0, 0);
            text:Dock(FILL);

        end
        local leaveButton = vgui.Create("DButton", mainPanel);
        leaveButton:SetText("Close");
        leaveButton:SetFont("NpcFont");
        leaveButton:SetSize(150, 30);
        leaveButton:DockMargin(0, 0, 0, 20);
        leaveButton:Dock(BOTTOM);
        leaveButton.DoClick = function()
            self:Remove();
        end
    end,

    Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150));
        surface.SetDrawColor(255, 255, 255, 255);
        surface.DrawOutlinedRect(2, 2, w-4, h-4);
    end
}

vgui.Register("npc_medic_carspawner_panel", PANEL)