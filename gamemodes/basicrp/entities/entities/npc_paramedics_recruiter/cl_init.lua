include('shared.lua')

net.Receive("npc_paramedics_recruiter", function()
  if !ParamedicsTalk then
    ParamedicsTalk = vgui.Create("npc_paramedics_dialog")
    ParamedicsTalk:SetVisible(true)
  else
    ParamedicsTalk:Remove()
    ParamedicsTalk = nil
  end
end)


net.Receive("paramedics_info", function() 
  ParamedicsInfo = vgui.Create("vgui_paramedics_info")
  ParamedicsInfo:SetVisible(true)
end)

function ENT:Draw()
  self:DrawModel()
end

local ply = FindMetaTable("Player")