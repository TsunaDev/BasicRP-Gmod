AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/gman_high.mdl")
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetNPCState(NPC_STATE_SCRIPT)
  self:SetSolid(SOLID_BBOX)
  self:CapabilitiesAdd(CAP_ANIMATEDFACE)
  self:SetUseType(SIMPLE_USE)
  self:DropToFloor()
  self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
  return false
end

util.AddNetworkString("npc_1")

function ENT:AcceptInput(Name, Activator, Caller)
  if Name == "Use" and Caller:IsPlayer() then
    net.Start("npc_1")
    net.Send(Caller)
  end
end

