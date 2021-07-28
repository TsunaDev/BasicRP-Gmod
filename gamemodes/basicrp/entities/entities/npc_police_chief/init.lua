AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
  self:SetModel("models/kerry/player/police_usa/male_08.mdl")
  self:SetBodygroup(1, 8)
  self:SetHullType(HULL_HUMAN)
  self:SetHullSizeNormal()
  self:SetNPCState(NPC_STATE_NONE)
  self:SetSolid(SOLID_BBOX)
  self:CapabilitiesAdd(CAP_ANIMATEDFACE)
  self:SetUseType(SIMPLE_USE)

  self:SetPos(Vector(-6808, -9330, 136))
  self:SetAngles(Angle(0, 160, 0))
  self:DropToFloor()
  self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage()
  return false
end

util.AddNetworkString("npc_policechief")

function ENT:AcceptInput(Name, Activator, Caller)
  if Name == "Use" and Caller:IsPlayer() then
    net.Start("npc_policechief")
    net.Send(Caller)
  end
end
