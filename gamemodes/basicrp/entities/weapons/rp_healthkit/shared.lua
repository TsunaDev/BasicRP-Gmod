SWEP.Author                 = "Tsuna"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "First Aid Kit"
SWEP.Instructions           = [[Left click to shock
Right click to load]]

SWEP.ViewModel              = "models/weapons/v_ifak.mdl"
SWEP.ViewModelFlipper       = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_ifak.mdl"
SWEP.SetHoldType            = "normal"

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 3
SWEP.SlotPos                = 1

SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = false

SWEP.Spawnable              = false
SWEP.AdminSpawnable         = false

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Automatic      = false

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Automatic    = false

SWEP.ShouldDropOnDie        = false

function SWEP:Initialize()
  self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
end

function SWEP:PrimaryAttack()
  local eyeTrace = self.Owner:GetEyeTrace();

  local Distance = self.Owner:EyePos():Distance(eyeTrace.HitPos);
  if !eyeTrace.Entity or !eyeTrace.Entity:IsPlayer() or Distance > 75 then return false; end

  self:SetNextPrimaryFire(CurTime() + 10);
  self:SetNextSecondaryFire(CurTime() + 10);
  self:EmitSound("items/smallmedkit1.wav");

  if CLIENT then return end

  eyeTrace.Entity:SetHealth(math.Clamp(eyeTrace.Entity:Health() + 50, 0, 100));
end


function SWEP:SecondaryAttack()
  self:PrimaryAttack();
end

function SWEP:Holster()
  return true
end

function SWEP:Succeed()
end

function SWEP:Fail()
end

function SWEP:Think()
end