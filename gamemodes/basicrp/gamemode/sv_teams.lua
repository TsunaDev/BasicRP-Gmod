local ply = FindMetaTable("Player")
local teams = {}

local BaseWeapons = {"weapon_gravity", "rp_keys"}
local VIPWeapons = {"weapon_physgun"}

teams[TEAM_CITIZEN] = {
  weapons = {},
  hp = 100,
  armor = 0;
  model = "models/player/Group01/male_02.mdl"
}
teams[TEAM_POLICE] = {
  weapons = {"fas2_glock20", "weapon_policebaton","handcuffs","stungun_new"},
  hp = 100,
  armor = 50,
  model = "models/kerry/player/police_usa/male_02.mdl"
}
teams[TEAM_MEDIC] = {
  weapons = {""},
  hp = 100,
  armor = 0,
  model = "models/player/gems_paramedic1/male_02.mdl"
}
teams[TEAM_FIRE] = {
  weapons = {""},
  hp = 100,
  armor = 0,
  model = "models/player/portal/Male_02_fireman.mdl"
}
teams[TEAM_MAYOR] = {
  weapons = {},
  hp = 100,
  armor = 0,
  model = "models/player/breen.mdl"
}
teams[TEAM_SWAT] = {
  weapons = {"fas2_glock20", "fas2_mp5k", "weapon_policebaton","handcuffs","stungun_new" },
  hp = 100,
  armor = 100,
  model = "models/piket_playermodel/piket_playermodel.mdl"
}
teams[TEAM_SPIDERMAN] = {
  weapons = {"weapon_spidermodnomasks"},
  hp = 300,
  armor = 100,
  model = "models/kryptonite/spiderman_2/spiderman_2.mdl"
}

function ply:SetupTeam(n)
  if not teams[n] then return end;

-- should check if in hand items and put them back in inventory

  self:RemoveAllItems()
  self:RemoveAllAmmo()
  self:SetTeam(n)
  self:SetHealth(teams[n].hp)
  self:SetMaxHealth(teams[n].hp)
  self:SetArmor(teams[n].armor)
  self:SetModel(teams[n].model)
  self:GiveWeapons(n)
end

function ply:GiveWeapons(n)
  for k, weapon in pairs(BaseWeapons) do
    self:Give(weapon)
  end

  -- if player is VIP
  for k, weapon in pairs(VIPWeapons) do
    self:Give(weapon)
  end

  for k, weapon in pairs(teams[n].weapons) do
    self:Give(weapon)
  end

end

util.AddNetworkString("setup_team")

net.Receive("setup_team", function(len, ply)
  local id = net.ReadInt(4)

  ply:SetupTeam(id)
end)