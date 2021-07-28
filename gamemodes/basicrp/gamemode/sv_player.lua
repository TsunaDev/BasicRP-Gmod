local PLAYER = FindMetaTable("Player")

util.AddNetworkString("set_cash");
util.AddNetworkString("take_cash");
util.AddNetworkString("give_cash");
util.AddNetworkString("buy_item");
util.AddNetworkString("sell_item");

function PLAYER:SetCash(amount)
  SetGlobalInt(self:SteamID() .. "_cash", amount);
end

net.Receive("set_cash", function(len, ply)
  local amount = net.ReadInt(8);

  ply:SetCash(amount);
end)

function PLAYER:TakeCash(amount)
  if GetGlobalInt(self:SteamID() .. "_cash") < amount then return false; end

  SetGlobalInt(self:SteamID() .. "_cash", GetGlobalInt(self:SteamID() .. "_cash") - amount);
  return true
end

net.Receive("buy_item", function(len, ply)
  local amount = net.ReadInt(8);
   str = string.lower(net.ReadString())
  local size = net.ReadInt(5);
  if (ply:TakeCash(amount * size)) then
   ply:changeValueOfItem(str, size)
   ply:Notify("Bought " .. size .. " " .. str)
  else
   ply:Notify("Not enough money")
  end
end)


net.Receive("sell_item", function(len, ply)
  local amount = net.ReadInt(8);
  ply:GiveCash(amount)
  str = string.lower(net.ReadString())
  ply:changeValueOfItem(str, -1)
end)

net.Receive("take_cash", function(len, ply)
  local amount = net.ReadInt(8);
  ply:TakeCash(amount);
end)

function PLAYER:GiveCash(amount)
  SetGlobalInt(self:SteamID() .. "_cash", GetGlobalInt(self:SteamID() .. "_cash") + amount);
end

net.Receive("give_cash", function(len, ply)
  local amount = net.ReadInt(8);

  ply:GiveCash(amount);
end)

function PLAYER:Revive()
  if self:Alive() then return end
  if !self.DeathPos then return end
  
  self:Spawn();
  self:Notify("You've been saved!", 6, "Generic");
  self:SetPos(self.DeathPos);
end
net.Receive("revive", function(len, ply)
  local player = net.ReadEntity();

  player:Revive();
end)

function PLAYER:Arrest(by)
  if self:Team() != TEAM_CITIZEN then return end;
  self.restricted = !self.restricted;
  self.whoArrestedMe = by;

  if self.restricted then
    self:StripWeapons();
    self:Notify("You've been arrested by a police officer, follow their order if you don't want any more trouble.", 10, "Generic");
    if by and by:IsValid() and by:IsPlayer() then
      by:Notify("You've arrested " .. self:Nick() .. ", you can now bring them to jail.", 6, "Generic");
    end
  else
    GAMEMODE:PlayerLoadout(self);
    self:Notify("You've been released.", 6, "Generic");
    if by and by:IsValid() and by:IsPlayer() then
      by:Notify("You've released " .. self:Nick(), 6, "Generic");
    end
  end

  self:SetSpeedValues();
end

function PLAYER:SetSpeedValues()
  local speedValues = {200, 300}

  if self.restricted then
    speedValues = {50, 50};
  end

  GAMEMODE:SetPlayerSpeed(self, speedValues[1], speedValues[2]);
end