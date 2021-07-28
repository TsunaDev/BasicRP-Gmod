local glockAmmo = 40;
local mpAmmo = 40;

GM.JobSalary[TEAM_SWAT] = 1200;
GM.JobSalaryString[TEAM_SWAT] = "as a salary for serving in the elite of the law enforcement.";
GM.JobEquipment[TEAM_SWAT] = function(ply)
  ply:Give("fas2_glock20");
  ply:GiveAmmo(glockAmmo, "10x25MM");
  ply:Give("fas2_mp5a5");
  ply:GiveAmmo(mpAmmo, "9x19MM");
  ply:Give("weapon_policebaton");
  ply:Give("stungun_new");
  ply:Give("rp_battering_ram");
  -- GIVE HANDCUFFS WHEN THEY'RE DONE
  ply:SetArmor(100);
end

function GM.JobJoinSwat(ply)
  if ply:Team() != TEAM_CITIZEN then return end

  ply:SetTeam(TEAM_SWAT);
  --REMOVE CARS SPAWNED PRIOR TO THE MOMENT THEY TAKE THE JOB

  GAMEMODE.JobEquipment[TEAM_SWAT](ply);
  ply.JobModel = "models/piket_playermodel/piket_playermodel.mdl"
  ply:SetModel(ply.JobModel);
end

function GM.JobQuitSwat(ply)
  ply:SetTeam(TEAM_CITIZEN);

  ply:RemoveAmmo(ply:GetAmmoCount('10x25MM'), "10x25MM");
  ply:RemoveAmmo(ply:GetAmmoCount('9x19MM'), "9x19MM");

  ply:StripWeapon("fas2_glock20")
  ply:StripWeapon("fas2_mp5a5")
  ply:StripWeapon("weapon_policebaton");
  ply:StripWeapon("stungun_new");
  ply:StripWeapon("rp_battering_ram");
  ply:SetArmor(0);

  -- REMOVE POLICE CAR (Just remove all the cars of the player)

  ply.JobModel = nil;
  ply:SetModel(ply.PlayerModel);
end

-- ADD FUNCTIONS TO SPAWN VEHICLE