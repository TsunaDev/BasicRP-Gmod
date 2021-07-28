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
  self:SetPos(Vector(-7580, -7725, 100))
  self:SetAngles(Angle(0, 0, 0))
  self:DropToFloor()
  self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
  return false
end

util.AddNetworkString("npc_realtor")

function ENT:AcceptInput(Name, Activator, Caller)
  if Name == "Use" and Caller:IsPlayer() then
    net.Start("npc_realtor")
    net.Send(Caller)
  end
end
