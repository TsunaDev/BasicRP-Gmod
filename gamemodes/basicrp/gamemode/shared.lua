GM.Name = "Basic RP"
GM.Author = "Tsuna"
GM.Email = "N/A"
GM.Website = "N/A"

TEAM_CITIZEN    = 1
TEAM_POLICE     = 2
TEAM_MEDIC      = 3
TEAM_FIRE       = 4
TEAM_MAYOR      = 5
TEAM_SWAT       = 6
TEAM_SPIDERMAN  = 99

AddCSLuaFile("sh_properties.lua")
AddCSLuaFile("sh_npcs.lua")
AddCSLuaFile("sh_notification.lua")
AddCSLuaFile("sh_vehicles.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("sh_config.lua")
include("sh_properties.lua")
include("sh_npcs.lua")
include("sh_notification.lua")
include("sh_vehicles.lua")
include("sh_player.lua")
include("sh_config.lua")

function GM:Initialize()
end

function GM:InitPostEntity()

  -- LOAD PROPERTIES
  for k, v in pairs(file.Find("basicrp/gamemode/properties/not_ownable/*.lua","LUA")) do include("basicrp/gamemode/properties/not_ownable/" .. v); end
	for k, v in pairs(file.Find("basicrp/gamemode/properties/ownable/*.lua","LUA")) do include("basicrp/gamemode/properties/ownable/" .. v); end
  for k, v in pairs(file.Find("basicrp/gamemode/vehicles/basics/*.lua","LUA")) do include("basicrp/gamemode/vehicles/basics/" .. v); end
    for k, v in pairs(file.Find("basicrp/gamemode/vehicles/police/*.lua","LUA")) do include("basicrp/gamemode/vehicles/police/" .. v); end
    for k, v in pairs(file.Find("basicrp/gamemode/vehicles/medic/*.lua","LUA")) do include("basicrp/gamemode/vehicles/medic/" .. v); end

  -- LOAD NPCs
  self:LoadNPCs()
end

team.SetUp(TEAM_CITIZEN, "Citizen", Color(0, 255, 0))
team.SetUp(TEAM_POLICE, "Police Officer", Color(0, 0, 255))
team.SetUp(TEAM_MEDIC, "Paramedic", Color(255, 0, 255))
team.SetUp(TEAM_FIRE, "Fireman", Color(255, 170, 0))
team.SetUp(TEAM_MAYOR, "Mayor", Color(255, 0, 0))
team.SetUp(TEAM_SWAT, "SWAT", Color(0, 0, 120))
team.SetUp(TEAM_SPIDERMAN, "Spider-Man", Color(200, 0, 0))