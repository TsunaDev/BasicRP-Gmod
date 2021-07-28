SWEP.Author               = "Tsuna"
SWEP.PrintName              = "Handcuffs"
SWEP.Instructions           = [[Left-Click: Arrest/Release]]

SWEP.ViewModelFlip          = false
SWEP.UseHands               = true
SWEP.SetHoldType            = "normal"
SWEP.ViewModelFOV	          = 90
SWEP.ViewModel      	      = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.WorldModel   	        = "models/katharsmodels/handcuffs/handcuffs-1.mdl"


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
  self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)

  if CLIENT then return end

  local ply = self:GetOwner()

  ply:LagCompensation(true)

  local target = ply:GetEyeTrace().Entity

  if target:IsValid() and target:IsPlayer() then
    target:Arrest(ply);
  end

  ply:LagCompensation(false)
end

function SWEP:SecondaryAttack()
  self:PrimaryAttack();
end


if ( CLIENT ) then
	function SWEP:GetViewModelPosition( pos, ang )
		ang:RotateAroundAxis( ang:Forward(), 90 ) 
		pos = pos + ang:Forward()*12 
		return pos, ang
	end 
end