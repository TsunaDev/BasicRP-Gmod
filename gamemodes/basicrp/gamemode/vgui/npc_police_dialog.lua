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
      self:Remove()
    end

    local label = vgui.Create("DLabel", self)      
    label:SetFont("MenuFont")
    label:SetText("Police Chief")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(10)
   
    local mainPanel = vgui.Create("DPanel", self)
    mainPanel:SetPos(3, 45)
    mainPanel:SetSize(x - 6, y - 35 - 3)
    mainPanel.Paint = function(self, w, h) 
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    if LocalPlayer():Team() == TEAM_CITIZEN then

      local joinButton = vgui.Create("DButton", mainPanel)
      joinButton:SetText("Join Police")
      joinButton:SetFont("NpcFont")
      joinButton:SetSize(150, 30)
      joinButton:Dock(TOP)
      joinButton.DoClick = function ()
        net.Start("join_police");
        net.SendToServer();
        self:Remove();
      end
    elseif LocalPlayer():Team() == TEAM_POLICE then
      local quitButton = vgui.Create("DButton", mainPanel);
      quitButton:SetText("Quit Police");
      quitButton:SetFont("NpcFont");
      quitButton:SetSize(150, 30);
      quitButton:Dock(TOP)
      quitButton.DoClick = function ()
        net.Start("quit_police");
        net.SendToServer();
        self:Remove();
      end
    end
    local leaveButton = vgui.Create("DButton", mainPanel)
    leaveButton:SetText("Close")
    leaveButton:SetFont("NpcFont")
    leaveButton:SetSize(150, 30)
    leaveButton:Dock(TOP)
    leaveButton.DoClick = function() 
      self:Remove()
    end
  end,

  Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
  end


}

vgui.Register("npc_police_dialog", PANEL)