local PANEL = {
    Init = function(self)
    
      self:SetSize(1000, 720)
      self:Center()
      
      local x, y = self:GetSize()
    
        local label = vgui.Create("DLabel", self)      
        label:SetFont("MenuFont")
        label:SetText("Character Creation")
        label:SizeToContents()
        label:CenterHorizontal()
        label:AlignTop(10)

        local mainPanel = vgui.Create("DPanel", self)
        mainPanel:SetPos(3, 45)
        mainPanel:SetSize(x - 6, y - 35 - 3)
        mainPanel.Paint = function(self, w, h) 
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        end

        local button = vgui.Create("DButton", self)
        button:SetText("<")
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

        local button = vgui.Create("DButton", self)
        button:SetText(">")
        button:SetFont("MenuFont")
        button:SetSize(50, 30)
        button:SetPos(x + 50, 10)
        function button:Paint(w, h)
          if button:IsDown() or button:IsHovered() then
            button:SetColor(Color(255, 0, 0, 255))
          else
            button:SetColor(Color(255, 255, 255, 255))
          end
        end

        local icon = vgui.Create( "DModelPanel", Panel )
        icon:SetSize(200,200)
        icon:SetModel( "models/player/alyx.mdl" ) 
        function icon:LayoutEntity( Entity ) return end
        function icon.Entity:GetPlayerColor() return Vector (1, 0, 0)
    }
