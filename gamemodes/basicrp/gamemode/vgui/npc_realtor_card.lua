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

function PANEL:SetProperty(property)
  local propertyOwner = GAMEMODE:GetPropertyOwnerByID(property.ID)
  print(propertyOwner)
  local image = vgui.Create("DImage", self)
  image:SetSize(130, 0)
  image:DockMargin(0, 0, 10, 0)
  image:SetImage(property.Material)
  image:Dock(LEFT)

  button = vgui.Create("DButton", self)
  if propertyOwner and propertyOwner:IsPlayer() and propertyOwner == LocalPlayer() then
    button:SetText("Sell")
  elseif propertyOwner and propertyOwner:IsPlayer() then
    button:SetDisabled(true)
    button:SetText("Sold")
  else
    button:SetText("Purchase")
  end
  button:SetFont("NpcFont")
  button:SetSize(150, 0)
  button:DockMargin(0, 40, 20, 40)
  button:Dock(RIGHT)

  button.DoClick = function()
    net.Start("property_toggle")
    net.WriteInt(property.ID, 8)
    net.SendToServer()
    self:GetParent():GetParent():GetParent():GetParent():Remove()
  end

  local title = vgui.Create("DLabel", self)
  title:SetFont("PropertyTitleFont")
  title:SetText(property.Name)
  title:SizeToContents()
  title:DockMargin(0, 10, 0, 0)
  title:Dock(TOP)

  local category = vgui.Create("DLabel", self)
  category:SetFont("PropertyTypeFont")
  category:SetText(property.Type)
  category:SizeToContents()
  category:DockMargin(0, 5, 0, 5)
  category:Dock(TOP)

  for k, v in pairs(property.Description:Split('|')) do
    local description = vgui.Create("DLabel", self)
    description:SetFont("PropertyDescriptionFont")
    description:SetText(v)
    description:SizeToContents()
    description:DockMargin(0, 2, 0, 0)
    description:Dock(TOP)
  end

  local price = vgui.Create("DLabel", self);
  price:SetFont("PropertyTitleFont")
  price:SetText("$" .. property.Price)
  price:SizeToContents()
  price:DockMargin(0, 2, 0, 0)
  price:Dock(TOP)
end

vgui.Register("npc_realtor_card", PANEL)