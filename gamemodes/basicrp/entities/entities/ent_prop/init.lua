AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:GetPhysicsObject():Wake();
end

function ENT:Use(activator)
        if activator == self:GetTable().Owner then
		activator:changeValueOfItem(self:GetTable().Name, 1)
                self:Remove()
	end
end

function ENT:SetContents(item, owner, name)
	self:GetTable().ItemID = tonumber(item);
	self:GetTable().Owner = owner;
        self:GetTable().Name = name
end