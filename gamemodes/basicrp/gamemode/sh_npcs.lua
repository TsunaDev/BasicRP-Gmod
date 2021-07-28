function GM:LoadNPCs()
  if CLIENT then return end

  local npcs = {
    "npc_realtor",
    "npc_cardealer",
    "npc_carcustom",
    "npc_carspawner",
    "npc_carspawner_2",
    "npc_medic_carspawner",
    "npc_police_carspawner",
    "npc_police_chief",
    "npc_paramedics_recruiter",
    "npc_konbini"
  }
  
  for k, v in pairs(npcs) do
    if IsValid(ents.FindByClass(v)) then
      for k, v in ents.FindByClass(v) do
        v.Remove()
      end
    end
    local Ent = ents.Create(v)

    if (!IsValid(Ent)) then return end
  
    Ent:Spawn()
  end
end