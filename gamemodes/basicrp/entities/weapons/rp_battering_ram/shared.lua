SWEP.PrintName = "Battering Ram"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "Tsuna"
SWEP.Instructions = "Left click: Break open a door/Unfreeze prop"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")
SWEP.AnimPrefix = "rpg"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

function fp(tbl)
  local func = tbl[1]

  return function(...)
      local fnArgs = {}
      local arg = {...}
      local tblN = table.maxn(tbl)

      for i = 2, tblN do fnArgs[i - 1] = tbl[i] end
      for i = 1, table.maxn(arg) do fnArgs[tblN + i - 1] = arg[i] end

      return func(unpack(fnArgs, 1, table.maxn(fnArgs)))
  end
end

function fnId(...)
  return ...
end

local function ramDoor(ply, trace, ent)
  if ply:EyePos():DistToSqr(trace.HitPos) > 2025 then return false end

  local allowed = true
  if CLIENT then return allowed end

  
  ent:Fire("unlock", "", 0)
  ent:Fire("open", "", .6)
  ent:Fire("setanimation", "open", .6)

  return true
end

local function ramVehicle(ply, trace, ent)
  if ply:EyePos():DistToSqr(trace.HitPos) > 10000 then return false end

  if CLIENT then return false end

  local driver = ent:GetDriver()
  if !IsValid(driver) or !driver.ExitVehicle then return false end

  driver:ExitVehicle()
  -- Relock after
  return true
end

local function ramProp(ply, trace, ent)
  if ply:EyePos():DistToSqr(trace.HitPos) > 10000 then return false end
  if ent:GetClass() ~= "prop_physics" then return false end

  if CLIENT then return true end
 
  constraint.RemoveConstraints(ent, "Weld")
  ent:GetPhysicsObject():EnableMotion(true)

  return true
end

local function getRamFunction(ply, eyeTrace)
  local ent = eyeTrace.Entity
  if not IsValid(ent) then return fp{fnId, false} end

  return
      ent:IsDoor() and fp{ramDoor, ply, eyeTrace, ent} or
      ent:IsVehicle() and fp{ramVehicle, ply, eyeTrace, ent} or
      ent:GetPhysicsObject():IsValid() and not ent:GetPhysicsObject():IsMoveable() and fp{ramProp, ply, eyeTrace, ent} or
      fp{fnId, false} -- no ramming was performed
end

function SWEP:Initialize()
  if CLIENT then self.LastIron = CurTime() end
  self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
  self:NetworkVar("Bool", 0, "IronSights")
  self:NetworkVar("Int", 1, "TotalUsedCount")
end

function SWEP:Holster()
  self:SetIronSights(false)

  return true
end

function SWEP:PrimaryAttack()
  if !self:GetIronSights() then return end

  self:SetNextPrimaryFire(CurTime() + 2.5)

  self:GetOwner():LagCompensation(true)
  local eyeTrace = self:GetOwner():GetEyeTrace()
  self:GetOwner():LagCompensation(false)

  local hasRammed = getRamFunction(self:GetOwner(), eyeTrace)()
  
  if !hasRammed then return end

  self:SetTotalUsedCount(self:GetTotalUsedCount() + 1)

  self:GetOwner():SetAnimation(PLAYER_ATTACK1)
  self:GetOwner():EmitSound(self.Sound)
  self:GetOwner():ViewPunch(Angle(-10, math.Round(util.SharedRandom("DoorRam" .. self:EntIndex() .. "_" .. self:GetTotalUsedCount(), -5, 5)), 0))
end

function SWEP:SecondaryAttack()
  if CLIENT then self.LastIron = CurTime() end
  self:SetNextSecondaryFire(CurTime() + 0.30)
  self:SetIronSights(not self:GetIronSights())
  if self:GetIronSights() then
      self:SetHoldType("rpg")
  else
      self:SetHoldType("normal")
  end
end

function SWEP:GetViewModelPosition(pos, ang)
  local Mul = 1

  if self.LastIron > CurTime() - 0.25 then
      Mul = math.Clamp((CurTime() - self.LastIron) / 0.25, 0, 1)
  end

  if self:GetIronSights() then
      Mul = 1-Mul
  end

  ang:RotateAroundAxis(ang:Right(), - 15 * Mul)
  return pos,ang
end

hook.Add("SetupMove", "DoorRamJump", function(ply, mv)
  local wep = ply:GetActiveWeapon()
  if not wep:IsValid() or wep:GetClass() ~= "door_ram" or not wep.GetIronSights or not wep:GetIronSights() then return end

  mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
end)

