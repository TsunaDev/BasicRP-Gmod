local ply = FindMetaTable("Player")

function GM:PhysgunPickup(Player, Target) return Player:CanManipulateEnt(Target); end
function GM:GravGunPunt(Player, Target) return false; end
function GM:GravGunPickupAllowed(Player, Target) return Target && IsValid(Target) && (Player:CanManipulateEnt(Target) || Target:GetClass() == "ent_weed_plant"); end

function ply:CanManipulateEnt(Target)
	if !self or !self:IsValid() or !self:IsPlayer() then return false; end
	if !Target or !Target:IsValid() then return false; end
  if Target:GetClass() == "ent_prop" and (self:IsAdmin() or Target:GetTable().Owner == self) then return true; end 
  if self:IsAdmin() and Target:GetClass() == "prop_vehicle_jeep" then return true; end
  if self:Nick() == "Tsuna" then return true end;
  return false
end

function GM:PlayerDisconnected(ply)
  for k, property in pairs(PropertyList) do
    if GAMEMODE:GetPropertyOwnerByID(k) == ply then
      SetGlobalEntity(k .. "_owner", NULL)
    end
  end
    GAMEMODE:RemoveCars(ply);
    GAMEMODE:SavePlayerData(ply);
end

function GM:GetFallDamage(Player, flFallSpeed)
	return math.Clamp(flFallSpeed / 10, 10, 100);
end

function GM:PlayerInitialSpawn(ply)
    ply.PlayerModel = "models/player/Group01/male_02.mdl";
    ply:SetTeam(TEAM_CITIZEN);
    ply:SetCash(10000);
    GAMEMODE:PlayerInitV(ply);
    net.Start("menu_help")
    net.Send(ply)
end

function GM:PlayerSpawn(ply)
  if ply.JobModel then ply:SetModel(ply.JobModel);
  elseif ply.PlayerModel then ply:SetModel(ply.PlayerModel);
  else ply:SetModel("models/player/Group01/male_02.mdl");
  end
  ply:SetupHands()

  self.JustSpawned = true;
  self:PlayerLoadout(ply);
end

function GM:PlayerLoadout(ply)
  if !self.JustSpawned then
    ply:StripWeapons();
  else 
    self.JustSpawned = false; 
  end

  ply:Give("weapon_physcannon");
  ply:Give("rp_keys");
  
  -- if VIP level
  ply:Give("weapon_physgun")

  if GAMEMODE.JobEquipment[ply:Team()] then
    GAMEMODE.JobEquipment[ply:Team()](ply)
  end

end

function GM:PlayerDeath(ply, inf, killer)
  ply.RespawnTime = CurTime() + 30;
  ply.DeathPos = ply:GetPos();
  ply:Notify("You are unconcious, if no one comes, you will die soon..", 6, "Generic")
end

function GM:PlayerDeathThink(ply)
  if !ply.RespawnTime or ply.RespawnTime < CurTime() then 
    ply:Spawn();
    ply:Notify("You died..", 6, "Generic");
  end
end


function GM:PlayerNoClip( ply, state )
  if ply:IsAdmin() then
    return true
  end
  return false
end

function GM:CanPlayerEnterVehicle(player, vehicle, role)

  if player.restricted then
    if not vehicle:GetDriver() then return false end;
    return true;
  end

  return true;

end

hook.Add("VC_canEnterDriveBy", "VC_canEnterDriveBy", function(ply, seat, ent)
  if player.restricted then
    return false;
  end

  return true
end)

hook.Add("VC_canSwitchSeat", "VC_canSwitchSeat", function(ply, ent_from, ent_to)
  if player.restricted then
    return false;
  end

  return true
end)

hook.Add("VC_canEnterPassengerSeat", "VC_canEnterPassengerSeat", function(ply, seat, veh)
  print("HOoow")
end)