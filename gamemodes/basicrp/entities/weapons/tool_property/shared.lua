SWEP.Author               = "Tsuna"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Property"
SWEP.Instructions           = [[ Left-Click: Add door
Right-Click: Start/Stop adding doors 
]]

SWEP.ViewModel              = "models/weapons/c_crowbar.mdl"
SWEP.ViewModelFlipper       = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"
SWEP.SetHoldType            = "melee"

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 0
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
  SetGlobalBool("toggleprop", false);
  SetGlobalString("proper", "");
end

function SWEP:PrimaryAttack()
  if CLIENT then return end

  local str = GetGlobalString("proper");
  local ply = self:GetOwner();

  ply:LagCompensation(true);

  local ent = ply:GetEyeTrace().Entity;


  str = str .. ent:MapCreationID();
  str = str .. ", ";

  SetGlobalString("proper", str);

  ply:LagCompensation(false);
end

function SWEP:SecondaryAttack()
  if CLIENT then return end

  toggle = GetGlobalBool("toggleprop");
  toggle = !toggle;

  if (!toggle) then
    local str = GetGlobalString("proper");
    
    print(string.sub(str, 0, string.len(str) - 2));
    SetGlobalString("proper", "");
  end
  SetGlobalBool("toggleprop", toggle);

  
end

function SWEP:DrawHUD()
  toggle = GetGlobalBool("toggleprop");
  if (toggle) then
    surface.SetDrawColor( 0, 255, 0, 255 )
  else
    surface.SetDrawColor( 255, 0, 0, 255 )
  end

  surface.DrawRect(25, 25, 100, 100);
  surface.SetFont("Default");
  surface.SetTextPos(140, 140);
  surface.SetTextColor(255, 255, 255);
  surface.DrawText(GetGlobalString("proper"));
end