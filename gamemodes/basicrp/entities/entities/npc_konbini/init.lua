AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/player/Group01/male_06.mdl")
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetNPCState(NPC_STATE_IDLE)
  self:SetSolid(SOLID_BBOX)
  self:CapabilitiesAdd(CAP_ANIMATEDFACE)
  self:SetUseType(SIMPLE_USE)
--setpos -7493.723633 -6606.864258 136.031250;setang 4.573899 89.012192 0.000000

  self:SetPos(Vector(-7494, -6607, 136))
  self:SetAngles(Angle(0, 90, 0))
  self:DropToFloor()
  self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
  return false
end

util.AddNetworkString("npc_konbini")

function ENT:AcceptInput(Name, Activator, Caller)
  if Name == "Use" and Caller:IsPlayer() then
    net.Start("npc_konbini")
    net.Send(Caller)
  end
end
