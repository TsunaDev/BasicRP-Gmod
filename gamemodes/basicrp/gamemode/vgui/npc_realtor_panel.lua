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
    label:SetText("Realtor menu")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(10)

    local sheet = vgui.Create("DPropertySheet", self);
    sheet:StretchToParent(5, 30, 5, 5);

    local sheetPanels = {}

    for k, property in pairs(PropertyList) do
      if property.Ownable then
        if !sheetPanels[property.Location] then
          sheetPanels[property.Location] = vgui.Create("DPanelList")
          sheetPanels[property.Location]:StretchToParent(5, 30, 5, 5)
          sheetPanels[property.Location]:SetPadding(5)
          sheetPanels[property.Location]:SetSpacing(5)
          sheetPanels[property.Location]:EnableVerticalScrollbar(true)
        end

        local card = vgui.Create("npc_realtor_card", sheetPanels[property.Location])
        card:SetProperty(property)
        sheetPanels[property.Location]:AddItem(card)
      end
    end

    sheet:AddSheet("Downtown", sheetPanels["Downtown"])
    sheet:AddSheet("Suburbs", sheetPanels["Suburbs"])
    sheet:AddSheet("Industrial", sheetPanels["Industrial"])
    
  end,

  Paint = function(self, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 150))
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawOutlinedRect(2, 2, w-4, h-4)
  end


}

vgui.Register("npc_realtor_panel", PANEL)