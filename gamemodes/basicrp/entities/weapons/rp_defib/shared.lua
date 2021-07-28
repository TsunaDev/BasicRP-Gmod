SWEP.Author                 = "Tsuna"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Defibrillator"
SWEP.Instructions           = [[Left click to shock
Right click to load]]

SWEP.ViewModel              = "models/weapons/custom/v_defib.mdl"
SWEP.ViewModelFlipper       = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/custom/w_defib.mdl"
SWEP.SetHoldType            = "normal"

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 3
SWEP.SlotPos                = 0

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

  self.Charged = false;
  self.Delay = 1;
  self.Timer = CurTime();
end

function SWEP:SetupDataTables()
end

function SWEP:PrimaryAttack()
  if self.Charged then
    local eyeTrace = self.Owner:GetEyeTrace();
	
    local Distance = self.Owner:EyePos():Distance(eyeTrace.HitPos);
    if Distance > 75 then return false; end
 
    print(eyeTrace.Entity.uqid);
    print(eyeTrace.Entity)

    if CLIENT then
      for k, v in pairs(player.GetAll()) do
        if !v:Alive() then
          for _, ent in pairs(ents.FindInSphere(eyeTrace.HitPos, 5)) do						
            if ent == v:GetRagdollEntity() then
                self.Charged = false;
                self.Weapon:EmitSound("weapons/stunstick/stunstick_impact1.wav");
                self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
                self:SetNextPrimaryFire(CurTime() + 1);
                self:SetNextSecondaryFire(CurTime() + 1);
                net.Start("medic_revive");
                net.WriteEntity(v);
                net.SendToServer();
              return;
            end
          end
        end
      end
    end


  end
end


function SWEP:SecondaryAttack()
  self.Charged = true;
  self.Weapon:EmitSound("ambient/energy/spark5.wav");
  self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK);
  self:SetNextPrimaryFire(CurTime() + 1);
  self:SetNextSecondaryFire(CurTime() + 1);
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