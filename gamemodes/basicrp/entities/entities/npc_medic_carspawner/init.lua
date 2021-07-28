AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

--- Server Side ---

function ENT:Initialize( ) -- Setup entity.
    self:SetModel( "models/gems_paramedic1/male_07.mdl" ) -- Sets the model of the NPC.
    self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
    self:SetHullSizeNormal( )
    self:SetNPCState( NPC_STATE_SCRIPT )
    self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
    self:CapabilitiesAdd( CAP_ANIMATEDFACE ) -- What the NPC is allowed to do.
    self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
    self:SetPos(Vector(-3660, -8555, 200))
    self:SetAngles(Angle(0, 90, 0))
    self:DropToFloor()
    self:SetMaxYawSpeed( 90 ) -- Sets the angle by which an NPC can rotate at once.
end

function ENT:OnTakeDamage()
    return false -- This NPC won't take damage
end

util.AddNetworkString("npc_medic_carspawner")

function ENT:AcceptInput( Name, Activator, Caller )
    if Name == "Use" and Caller:IsPlayer() then
        net.Start("npc_medic_carspawner")
        net.Send(Caller)
    end
end




