include('shared.lua')

--- Client side ---

net.Receive("npc_carspawner_2", function()
    if !CardealerTalk then
        CardealerTalk = vgui.Create("npc_carspawner_panel")
        CardealerTalk:SetVisible(true)
        else
        CardealerTalk:Remove()
        CardealerTalk = nil
    end

end)

function ENT:Draw()
    self:DrawModel()
end

local ply = FindMetaTable("Player")