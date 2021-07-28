local glockAmmo = 40;
local mpAmmo = 40;

GM.JobSalary[TEAM_MEDIC] = 1200;
GM.JobSalaryString[TEAM_MEDIC] = "as a salary for your job as a medic.";
GM.JobEquipment[TEAM_MEDIC] = function(ply)
  ply:Give("rp_defib");
  ply:Give("rp_healthkit");
end

function GM.JobJoinMedic(ply)
  if ply:Team() != TEAM_CITIZEN then return end

  ply:SetTeam(TEAM_MEDIC);
  --REMOVE CARS SPAWNED PRIOR TO THE MOMENT THEY TAKE THE JOB
  GAMEMODE:RemoveCars(ply);
  GAMEMODE.JobEquipment[TEAM_MEDIC](ply);
  ply.JobModel = "models/player/gems_paramedic1/male_02.mdl"
  ply:SetModel(ply.JobModel);
  ply:Notify("You joined the paramedic team!", 6, "Generic");
  net.Start("paramedics_info");
  net.Send(ply);
end

util.AddNetworkString("join_medic")
net.Receive("join_medic", function(len, ply)
  GAMEMODE.JobJoinMedic(ply);
end)

function GM.JobQuitMedic(ply)
  ply:SetTeam(TEAM_CITIZEN);


  ply:StripWeapon("rp_defib");
  ply:StripWeapon("rp_healthkit");

  -- REMOVE CAR (Just remove all the cars of the player)
  GAMEMODE:RemoveCars(ply);

  ply.JobModel = nil;
  ply:SetModel(ply.PlayerModel);
  ply:Notify("You left the paramedic team!", 6, "Generic");

end

util.AddNetworkString("quit_medic")
net.Receive("quit_medic", function(len, ply)
  GAMEMODE.JobQuitMedic(ply);
end)

function GM.MedicRevive(ply, target)
  if !target or !target:IsPlayer() then return end

  if math.random(0, 2) != 0 then return end -- You have one out of three chances to revive the player every time

  ply:GiveCash(100);
  ply:Notify("You got $100 for reviving this person!", 6, "Generic");

    target:Revive();
end

util.AddNetworkString("medic_revive")
net.Receive("medic_revive", function(len, ply)
  local targ = net.ReadEntity();

  GAMEMODE.MedicRevive(ply, targ);
end)

-- ADD FUNCTIONS TO SPAWN VEHICLE

function GM:SpawnMedicCar(ID, ply)
  local _v = ents.Create(VehiclesMedicList[ID].Type); -- Type of vehicle to spawn.

  if (IsValid(_v)) then
    -- Remove old vehicle
    GAMEMODE:RemoveCars(ply);
    local spawnable = false;
    local y = -7650;
    local area;
    while spawnable == false and y >= -8300 do
      area = ents.FindInSphere(Vector(-3550, y, 225), 50);
      spawnable = true;
      for k, entity in pairs(area) do
        if (IsValid(entity)) then
          spawnable = false;
          y = y - 300;
          break;
        end
      end
    end
    if (spawnable == true) then
      _v:SetName(VehiclesMedicList[ID].Name);
      _v:SetPos(Vector(-3644, y, 225));
      _v:SetAngles(Angle( 0, 90, 0));
      _v:SetModel(VehiclesMedicList[ID].Model);
      _v:SetSkin(1);
      _v:SetKeyValue("vehiclescript", VehiclesMedicList[ID].KeyValue);
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

util.AddNetworkString("spawn_medic_car")

net.Receive ("spawn_medic_car", function(len, ply)
  GAMEMODE:SpawnMedicCar(1, ply);
end)