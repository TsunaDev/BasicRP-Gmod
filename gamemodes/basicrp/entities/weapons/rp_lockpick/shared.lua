SWEP.Author                 = "Tsuna"
SWEP.Base                   = "weapon_base"
SWEP.PrintName              = "Lockpick"
SWEP.Instructions           = "Left click to pick a lock"

SWEP.ViewModel              = "models/weapons/c_crowbar.mdl"
SWEP.ViewModelFlipper       = false
SWEP.UseHands               = true
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"
SWEP.SetHoldType            = "melee"

SWEP.Weight                 = 5
SWEP.AutoSwitchTo           = true
SWEP.AutoSwitchFrom         = false

SWEP.Slot                   = 5
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


SWEP.BreakSound             = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.ShouldDropOnDie        = false

function SWEP:Initialize()
  self:SetHoldType("normal")
end

function ownerCanLockpick(entity, ply)
  if entity:IsDoor() && GAMEMODE:GetDoorOwner(ent) != ply then -- Add the fact that it mustn't be possible to lockpick EVERY not ownable locks
    return true;
  end
  print("lololol")
  return false;
end


function SWEP:SetupDataTables()
  self:NetworkVar("Float", 0, "LPStart");
  self:NetworkVar("Float", 1, "LPEnd");
  self:NetworkVar("Float", 2, "LPSoundTimer");
  self:NetworkVar("Int", 0, "LPTotal");
  self:NetworkVar("Bool", 0, "LPCurrentState");
  self:NetworkVar("Entity", 0, "LPEntity");
end

function SWEP:PrimaryAttack()
  self:SetNextPrimaryFire(CurTime() + 3);
  if self:GetLPCurrentState() then return end

  self:GetOwner():LagCompensation(true);
  local eyeTrace = self:GetOwner():GetEyeTrace();
  self:GetOwner():LagCompensation(false);

  local ent = eyeTrace.Entity

  if !IsValid(ent) then return end

  local canLockpick = ownerCanLockpick(ent, self:GetOwner());

  if !canLockpick then return end
 -- if !(eyeTrace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000) then return end
  
  self:SetHoldType("pistol");

  print("lololooiaoiazeaze")
  self:SetLPCurrentState(true);
  self:SetLPEntity(ent);
  self:SetLPStart(CurTime());
  self:SetLPEnd(CurTime() + 20);

  if CLIENT then
    self.Dots = ""
    self.NextDotsTime = SysTime() + 0.5
    return
  end

  local onFail = function(ply) if ply == self:GetOwner() then hook.Call("onLockpickCompleted", nil, ply, false, ent) end end ------- Call the hook on lockpick complete with false meaning it failed
  -- Lockpick fails when dying or disconnecting
  hook.Add("PlayerDeath", self, fc{onFail, fnFlip(fnConst)})
  hook.Add("PlayerDisconnected", self, fc{onFail, fnFlip(fnConst)})
  -- Remove hooks when finished
  hook.Add("onLockpickCompleted", self, fc{fp{hook.Remove, "PlayerDisconnected", self}, fp{hook.Remove, "PlayerDeath", self}})
end

function SWEP:Holster()
  self:SetLPCurrentState(false);
  self:SetLPEntity(nil);
  return true
end

function SWEP:Succeed()
  self:SetHoldType("normal");

  local ent = self:GetLPEntity();

  self:SetLPCurrentState(false);
  self:SetLPEntity(nil);

  if !ent:IsValid() then return end

  print(ent)
  if SERVER then
    ent:Fire("unlock");
    ent:Fire("open");
  end
end

function SWEP:Fail()
  self:SetLPCurrentState(false);
  self:SetHoldType("normal");
  self:SetLPEntity(nil);
end

local dots = {
  [0] = ".",
  [1] = "..",
  [2] = "...",
  [3] = ""
}

function SWEP:Think()
  if not self:GetLPCurrentState() or self:GetLPEnd() == 0 then return end
  print("lololoolpkoikjoko")
  if CurTime() >= self:GetLPSoundTimer() then
      self:SetLPSoundTimer(CurTime() + 1)
      local snd = {1,3,4}
      self:EmitSound("weapons/357/357_reload" .. tostring(snd[math.Round(util.SharedRandom("LockpickSnd" .. CurTime(), 1, #snd))]) .. ".wav", 50, 100)
  end
  if CLIENT and (not self.NextDotsTime or SysTime() >= self.NextDotsTime) then
      self.NextDotsTime = SysTime() + 0.5
      self.Dots = self.Dots or ""
      local len = string.len(self.Dots)

      self.Dots = dots[len]
  end

  local trace = self:GetOwner():GetEyeTrace()
  if not IsValid(trace.Entity) or trace.Entity ~= self:GetLPEntity() or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 then
      self:Fail()
  elseif self:GetLPEnd() <= CurTime() then
      self:Succeed()
  end
end

function SWEP:DrawHUD()
  if not self:GetLPCurrentState() or self:GetLPEnd() == 0 then return end

  self.Dots = self.Dots or ""
  local w = ScrW()
  local h = ScrH()
  local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15
  draw.RoundedBox(8, x, y, width, height, Color(10,10,10,120))

  local time = self:GetLPEnd() - self:GetLPStart()
  local curtime = CurTime() - self:GetLPStart()
  local status = math.Clamp(curtime / time, 0, 1)
  local BarWidth = status * (width - 16)
  local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)
  draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(255 - (status * 255), 0 + (status * 255), 0, 255))

  draw.SimpleText("Picking lock" .. self.Dots, "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
end


function SWEP:SecondaryAttack()
  self:PrimaryAttack()
end


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

local function comp_h(a, b, ...)
  if b == nil then return a end
  b = comp_h(b, ...)
  return function(...)
      return a(b(...))
  end
end

function fc(funcs, ...)
  if type(funcs) == "table" then
      return comp_h(unpack(funcs))
  else
      return comp_h(funcs, ...)
  end
end

function fnFlip(f)
  if not f then error("not a function") end
  return function(b, a, ...)
      return f(a, b, ...)
  end
end

function fnConst(a, b)
  return a 
end