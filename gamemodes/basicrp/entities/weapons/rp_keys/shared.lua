SWEP.Author               = "Tsuna"
SWEP.PrintName              = "Keys"
SWEP.Instructions           = [[ Left-Click: Lock
Right-Click: Unlock 
]]

SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.SetHoldType            = "normal"
SWEP.WorldModel             = ""
SWEP.AnimPrefixed           = "rpg"


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



SWEP.LockSound              = "doors/door_latch1.wav"
SWEP.UnlockSound            = "doors/door_latch3.wav"

SWEP.ShouldDropOnDie        = false

function SWEP:Initialize()
  self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
  if CLIENT then return end

  local ply = self:GetOwner()

  ply:LagCompensation(true)

  local ent = ply:GetEyeTrace().Entity

  if ply:GetPos():Distance(ent:GetPos()) < 80 and ((ent:IsDoor() and (GAMEMODE:GetDoorOwner(ent) == ply or table.HasValue(ent:GetDoorProperty().AuthorizedTeams, ply:Team()))) or (ent:IsVehicle() and ent:GetTable().Owner == ply)) then
    ent:Fire("lock")
    self.Owner:EmitSound(self.LockSound)
  end


  ply:LagCompensation(false)
end

function SWEP:SecondaryAttack()
  if CLIENT then return end
  local ply = self:GetOwner()

  ply:LagCompensation(true)

  local ent = ply:GetEyeTrace().Entity

  if ply:GetPos():Distance(ent:GetPos()) < 80 and ((ent:IsDoor() and (GAMEMODE:GetDoorOwner(ent) == ply or table.HasValue(ent:GetDoorProperty().AuthorizedTeams, ply:Team()))) or (ent:IsVehicle() and ent:GetTable().Owner == ply)) then
    ent:Fire("unlock")
    self.Owner:EmitSound(self.UnlockSound)
  end

  ply:LagCompensation(false)
end

function SWEP:Deploy()
  if CLIENT or not IsValid(self:GetOwner()) then return true end
  self:GetOwner():DrawWorldModel(false)
  return true
end

function SWEP:Holster()
  return true
end

function SWEP:PreDrawViewModel()
  return true
end