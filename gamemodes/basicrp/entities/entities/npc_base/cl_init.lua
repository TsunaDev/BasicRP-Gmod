include('shared.lua')

net.Receive("npc_1", function()
  if !NpcInteraction then
    NpcInteraction = vgui.Create("npc_1")
    NpcInteraction:SetVisible(false)
  end

  if NpcInteraction:IsVisible() then
    NpcInteraction:SetVisible(false)
  else
    NpcInteraction:SetVisible(true)
  end
end)

function ENT:Draw()
  self:DrawModel()
end

local ply = FindMetaTable("Player")

function ply:SetupTeam(n)
  net.Start("setup_team")
  net.WriteInt(n, 4)
  net.SendToServer()
end