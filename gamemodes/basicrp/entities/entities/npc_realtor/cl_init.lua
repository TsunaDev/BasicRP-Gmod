include('shared.lua')

net.Receive("npc_realtor", function()
  if !RealtorTalk then
    RealtorTalk = vgui.Create("npc_realtor_panel")
    RealtorTalk:SetVisible(true)
  else
    RealtorTalk:Remove()
    RealtorTalk = nil
  end
end)

function ENT:Draw()
  self:DrawModel()
end

local ply = FindMetaTable("Player")