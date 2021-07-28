local PANEL = {
  Init = function(self)
  
    self:SetSize(ScrW() / 3, 300)
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
    label:SetText("Welcome to the Paramedics!")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(10)
   
    local mainPanel = vgui.Create("DPanel", self)
    mainPanel:SetPos(3, 45)
    mainPanel:SetSize(x - 6, y - 35 - 3)
    mainPanel.Paint = function(self, w, h) 
      draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    local label = vgui.Create("DLabel", mainPanel);
    label:SetFont("MenuFont2");
    label:SetText("Your role is to heal and save people around the city. If you manage to save someone from a certain death you might get a $100 bonus.");
    label:SetAutoStretchVertical(true);
    label:Dock(TOP);
    label:DockMargin(10, 10, 10, 40);
    label:SetWrap(true);

    local label2 = vgui.Create("DLabel", mainPanel);
    label2:SetFont("MenuFont2");
    label2:SetText("You can get a car if you talk to our guy in the garage of this building.");
    label2:SetAutoStretchVertical(true);
    label2:Dock(TOP);
    label2:DockMargin(10, 10, 10, 40);
    label2:SetWrap(true);

  end,

  Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
  end


}
vgui.Register("vgui_paramedics_info", PANEL)