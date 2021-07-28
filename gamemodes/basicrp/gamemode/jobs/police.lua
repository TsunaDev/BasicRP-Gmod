local glockAmmo = 40;

GM.JobSalary[TEAM_POLICE] = 1000;
GM.JobSalaryString[TEAM_POLICE] = "as a salary for serving in the law enforcement.";
GM.JobEquipment[TEAM_POLICE] = function(ply)
  ply:Give("fas2_glock20");
  ply:GiveAmmo(glockAmmo, "10x25MM");
  --ply:Give("weapon_policebaton");
  ply:Give("stungun_new");
  ply:Give("rp_battering_ram");
  ply:Give("vc_spikestrip_wep");
  ply:Give("rp_handcuffs");
  -- GIVE HANDCUFFS WHEN THEY'RE DONE
  ply:SetArmor(50);
end

function GM.JobJoinPolice(ply)
  if ply:Team() != TEAM_CITIZEN then return end

  ply:SetTeam(TEAM_POLICE);
  --REMOVE CARS SPAWNED PRIOR TO THE MOMENT THEY TAKE THE JOB
  GAMEMODE:RemoveCars(ply);
  GAMEMODE.JobEquipment[TEAM_POLICE](ply);
  ply.JobModel = "models/kerry/player/police_usa/male_02.mdl"
  ply:SetModel(ply.JobModel);
  ply:Notify("You joined the police!", 6, "Generic");
  net.Start("police_info");
  net.Send(ply);
end

util.AddNetworkString("join_police")
net.Receive("join_police", function(len, ply)
  GAMEMODE.JobJoinPolice(ply);
end)


function GM.JobQuitPolice(ply)
  ply:SetTeam(TEAM_CITIZEN);

  ply:RemoveAmmo(ply:GetAmmoCount('10x25MM'), "10x25MM");

  ply:StripWeapon("fas2_glock20")
  --ply:StripWeapon("weapon_policebaton");
  ply:StripWeapon("stungun_new");
  ply:StripWeapon("rp_battering_ram");
  ply:StripWeapon("vc_spikestrip_wep");
  ply:SetArmor(0);

  -- REMOVE POLICE CAR (Just remove all the cars of the player)
  GAMEMODE:RemoveCars(ply);
  ply.JobModel = nil;
  ply:SetModel(ply.PlayerModel);
  ply:Notify("You left the police!", 6, "Generic");

end


util.AddNetworkString("quit_police")
net.Receive("quit_police", function(len, ply)
  GAMEMODE.JobQuitPolice(ply);
end)

-- ADD FUNCTIONS TO SPAWN VEHICLE

function GM:SpawnPoliceCar(ID, ply)
  local _v = ents.Create(VehiclesPoliceList[ID].Type); -- Type of vehicle to spawn.

  if (IsValid(_v)) then
    -- Remove old vehicle
    GAMEMODE:RemoveCars(ply);
    local spawnable = false;
    local y = -10030;
    local area;
    while spawnable == false and y <= -8500 do
      area = ents.FindInSphere(Vector(-7650, y, -100), 50);
      spawnable = true;
      for k, entity in pairs(area) do
        if (IsValid(entity)) then
          spawnable = false;
          y = y + 260;
          break;
        end
      end
    end
    if (spawnable == true) then
      _v:SetName(VehiclesPoliceList[ID].Name);
      _v:SetPos(Vector(-7650, y, -100));
      _v:SetAngles(Angle( 0, -90, 0));
      _v:SetModel(VehiclesPoliceList[ID].Model);
      _v:SetSkin(1);
      _v:SetKeyValue("vehiclescript", VehiclesPoliceList[ID].KeyValue);
      _v:GetTable().Owner = ply;
      _v:DropToFloor();
      _v:Spawn();
      _v:Activate();
    else
      ply:Notify("Something is blocking the spawn area !", 6, "Generic");
    end
  else
    return;
  end
end


util.AddNetworkString("spawn_police_car")

net.Receive ("spawn_police_car", function(len, ply)
  GAMEMODE:SpawnPoliceCar(1, ply);
end)