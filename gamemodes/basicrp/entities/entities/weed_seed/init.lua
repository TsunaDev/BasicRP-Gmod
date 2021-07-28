AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self.Entity:SetModel("models/nater/weedplant_pot_dirt.mdl");
  self.Entity:PhysicsInit(SOLID_VPHYSICS);
  self.Entity:SetSolid(SOLID_VPHYSICS);
  self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
  self.Entity:SetUseType(SIMPLE_USE);

  local physics = self.Entity:GetPhysicsObject();
  
  if physics and physics:IsValid() then
    physics:Wake();
  end
end

function ENT:Use()
  -- BACK IN THE INVENTORY
end