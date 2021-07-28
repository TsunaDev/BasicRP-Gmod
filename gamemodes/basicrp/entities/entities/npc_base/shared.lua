ENT.Base                  = "base_ai"
ENT.Type                  = "ai"
ENT.PrintName             = "NPC1"
ENT.Author                = "Tsuna"
ENT.Instructions          = "Press E to talk"
ENT.Spawnable             = true
ENT.AdminSpawnable        = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
  self.AutomaticFrameAdvance = bUsingAnim
end