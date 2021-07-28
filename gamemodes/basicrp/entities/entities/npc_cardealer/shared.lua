--- Both side ---

ENT.Base = "base_ai" -- Base of the entity
ENT.Type = "ai" -- Type of the entity
ENT.PrintName             = "John (Car Seller)"
ENT.Author                = "Thorek"
ENT.Instructions          = "Press E to talk" --
ENT.Spawnable             = true -- Can be spawned
ENT.AdminSpawnable        = true -- Can be spawned by admin
ENT.AutomaticFrameAdvance = true -- Entity animated

function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- Tell the entity if it should animate itself.
    self.AutomaticFrameAdvance = bUsingAnim
end