include('shared.lua')

net.Receive("npc_policechief", function()
  if !PoliceChiefTalk then
    PoliceChiefTalk = vgui.Create("npc_police_dialog")
    PoliceChiefTalk:SetVisible(true)
  else
    PoliceChiefTalk:Remove()
    PoliceChiefTalk = nil
  end
end)


net.Receive("police_info", function() 
  PoliceInfo = vgui.Create("vgui_police_info")
  PoliceInfo:SetVisible(true)
end)

function ENT:Draw()
  self:DrawModel()
end

local ply = FindMetaTable("Player")