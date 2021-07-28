local function paydayEvent()
  for k, ply in pairs(player.GetAll()) do
    if ply:Team() == TEAM_CITIZEN then
      ply:GiveCash(200);
      ply:Notify("You received $200 as your income from unemployment.", 6, "Generic");
    else
      ply:GiveCash(GAMEMODE.JobSalary[ply:Team()]);
      ply:Notify("You received $" .. GAMEMODE.JobSalary[ply:Team()] .. " " .. GAMEMODE.JobSalaryString[ply:Team()], 6, "Generic");      
    end
  end
end
timer.Create("payday", 75, 0, paydayEvent);
