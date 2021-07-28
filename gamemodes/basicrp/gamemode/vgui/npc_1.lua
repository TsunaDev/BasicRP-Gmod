local PANEL = {
  Init = function(self)
  
    self:SetSize(ScrW() / 3, ScrH() / 3)
    self:Center()
    self:MakePopup()
    
    local x, y = self:GetSize()

    local button = vgui.Create("DButton", self)
    button:SetText("X")
    button:SetFont("NpcFont")
    button:SetSize(ScrW() / 10, ScrH() / 10)
    button:SetPos(x - ScrW() / 10, 10)
    function button:Paint(w, h)
      if button:IsDown() or button:IsHovered() then
        button:SetColor(Color(255, 0, 0, 255))
      else
        button:SetColor(Color(255, 255, 255, 255))
      end
    end
    button.DoClick = function() 
      self:SetVisible(false)
    end

    local label = vgui.Create("DLabel", self)
    label:SetFont("NpcFont")
    label:SetText("menu")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(10)

    local button2 = vgui.Create("DButton", self)
    button2:SetText("Join Police")
    button2:SetFont("NpcFont")
    button2:SetSize(x / 2, ScrH() / 10)
    button2:SetPos(x - (3 * x / 4), (ScrH() / 10) * 2)

    button2.DoClick = function()
      
      print(LocalPlayer():SetupTeam(TEAM_POLICE))
    end
  end,

  Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
  end


}

vgui.Register("npc_1", PANEL)