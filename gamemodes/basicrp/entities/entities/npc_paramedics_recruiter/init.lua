AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/gems_paramedic1/male_07.mdl")
  self:SetBodygroup(1, 8)
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetNPCState(NPC_STATE_NONE)
  self:SetSolid(SOLID_BBOX)
  self:CapabilitiesAdd(CAP_ANIMATEDFACE)
  self:SetUseType(SIMPLE_USE)
---3890.056152 -6962.715820 262.031250;setang 2.414244 -89.109612 0.000000

  self:SetPos(Vector(-3890, -6962, 262))
  self:SetAngles(Angle(0, -90, 0))
  self:DropToFloor()
  self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
  return false
end

util.AddNetworkString("npc_paramedics_recruiter")

function ENT:AcceptInput(Name, Activator, Caller)
  if Name == "Use" and Caller:IsPlayer() then
    net.Start("npc_paramedics_recruiter")
    net.Send(Caller)
  end
end
