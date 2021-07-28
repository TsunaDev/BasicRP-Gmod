include('shared.lua')

net.Receive("npc_konbini", function()
  if !KonbiniTalk then
    KonbiniTalk = vgui.Create("npc_konbini_dialog")
    KonbiniTalk:SetVisible(true)
  else
    KonbiniTalk:Remove()
    KonbiniTalk = nil
  end
end)

function ENT:Draw()
  self:DrawModel()
end

local ply = FindMetaTable("Player")