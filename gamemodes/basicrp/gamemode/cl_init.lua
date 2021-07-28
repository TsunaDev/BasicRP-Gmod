include("shared.lua")
include("cl_fonts.lua")
include("database/cl_database.lua")

for k, v in pairs(file.Find("basicrp/gamemode/vgui/*.lua","LUA")) do include("vgui/" .. v); end



hook.Add("HUDPaint", "HUDIdent", function() 
  local ply = LocalPlayer()
  surface.SetDrawColor(100, 100, 100, 255)

  if ply:Nick() == "Tsuna" then return end
  surface.DrawRect(30 - 2, ScrH() - 70 - 2, 300 + 4, 30 + 4)
  surface.DrawRect(ScrW() - 300, ScrH() - 70, 200, 30)
  draw.SimpleText("Cash: $" .. ply:GetCash(), "HUDFont", ScrW() - 300 + 15, ScrH() - 70 + 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  surface.SetDrawColor(255, 100, 100, 255)
  surface.SetTexture(10)
  surface.DrawTexturedRect(30, ScrH() - 70, 300 * ply:Health() / ply:GetMaxHealth(), 30)
  draw.SimpleText(ply:Health() .. "%", "HUDFont", 30 + 150, ScrH() - 70 + 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  if ply:Armor() > 0 then
    surface.SetDrawColor(100, 100, 255, 255)
    surface.DrawTexturedRect(30, ScrH() - 130, 300 * ply:Armor() / 100, 30)
    draw.SimpleText(ply:Armor() .. "%", "HUDFont", 30 + 150, ScrH() - 130 + 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end

  local eyeTrace = LocalPlayer():GetEyeTrace();
  local viewDistance = 200;
  local fade = 100;
  local pos = LocalPlayer():GetPos();

  if !LocalPlayer():InVehicle() && eyeTrace.Entity && IsValid(eyeTrace.Entity) && eyeTrace.Entity:IsDoor() then
    local dist = eyeTrace.Entity:GetPos():Distance(pos);

    if dist <= viewDistance then
      local a = 255;

      if dist >= fade then
        local diff = viewDistance - dist;
        local percentage = diff / (viewDistance - fade);

        a =  255 * percentage;
      end
    
      local doorPos = eyeTrace.Entity:LocalToWorld(eyeTrace.Entity:OBBCenter()):ToScreen();
      local property = eyeTrace.Entity:GetDoorProperty();

      if property then
        draw.SimpleTextOutlined(property.Name, "MenuFont", doorPos.x, doorPos.y + 25, Color(255, 255, 255, a), 1, 1, 1, Color(0, 100, 0, a));
      end
    end
  end
  
end)

function GM:HUDShouldDraw(name)
  local hud = {"CHudHealth", "CHudBattery"}

  for k, v in pairs(hud) do 
    if name == v then return false end
  end
  return true
end

net.Receive("menu_help", function() 
  if !HelpMenu then
    HelpMenu = vgui.Create("menu_help")
    HelpMenu:SetVisible(false)
  end

  if HelpMenu:IsVisible() then
    HelpMenu:SetVisible(false)
    gui.EnableScreenClicker(false)
  else
    HelpMenu:SetVisible(true)
    gui.EnableScreenClicker(true)
  end

end)
