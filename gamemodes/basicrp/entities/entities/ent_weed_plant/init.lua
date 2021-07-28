AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
  self:SetModel("models/nater/weedplant_pot_dirt.mdl");
  self:PhysicsInit(SOLID_VPHYSICS);
  self:SetSolid(SOLID_VPHYSICS);
  self:SetMoveType(MOVETYPE_VPHYSICS);
  self:SetUseType(SIMPLE_USE);

  local physics = self:GetPhysicsObject();
  
  if physics and physics:IsValid() then
    physics:Wake();
  end

  self:SetNWBool("done", false);
  self:SetNWBool("free", true);
end

function ENT:Touch(hit)
  if hit:GetClass() == "ent_weed_seed" then
    if self:GetNWBool("free") then
      self:SetNWBool("free", false);
      hit:Remove();
      self:SetModel("models/nater/weedplant_pot_planted.mdl");

      timer.Create("s2_" .. self:EntIndex(), 3, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing1.mdl");
      end);

      timer.Create("s3_" .. self:EntIndex(), 6, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing2.mdl");
      end);

      timer.Create("s4_" .. self:EntIndex(), 9, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing3.mdl");
      end);

      timer.Create("s5_" .. self:EntIndex(), 12, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing4.mdl");
      end);

      timer.Create("s6_" .. self:EntIndex(), 15, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing5.mdl");
      end);

      timer.Create("s7_" .. self:EntIndex(), 18, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing6.mdl");
      end);

      timer.Create("s8_" .. self:EntIndex(), 21, 1, function()
        self:SetModel("models/nater/weedplant_pot_growing7.mdl");
        self:SetNWBool("done", true);
      end);
    end
  end
end

function ENT:OnRemove()
  if not self:GetNWBool("free") then
    timer.Destroy("s2_" .. self:EntIndex())
    timer.Destroy("s3_" .. self:EntIndex())
    timer.Destroy("s4_" .. self:EntIndex())
    timer.Destroy("s5_" .. self:EntIndex())
    timer.Destroy("s6_" .. self:EntIndex())
    timer.Destroy("s7_" .. self:EntIndex())
    timer.Destroy("s8_" .. self:EntIndex())
  end
end

function ENT:Use(activator)
  if self:GetNWBool("done") then
    self:SetNWBool("done", false);
    self:SetNWBool("free", true);
    self:SetModel("models/nater/weedplant_pot_dirt.mdl");
    local weed = ents.Create("durgz_weed_custom")
    activator:changeValueOfItem("weed", 3)
  -- Put a random number of those in the inventory instead in the future (this is just for test)
    
    weed:SetPos(self:GetPos() + Vector(0, 0, 20)); 
    weed:Spawn();
  elseif self:GetNWBool("free") then
    self:Remove();
    activator:changeValueOfItem(self:GetTable().Name, 1)
  end
end


function ENT:SetContents(item, owner, name)
	self:GetTable().ItemID = tonumber(item);
	self:GetTable().Owner = owner;
        self:GetTable().Name = name
end