AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("database/cl_database.lua")
AddCSLuaFile("database/items.lua")

for k, v in pairs(file.Find("basicrp/gamemode/vgui/*.lua","LUA")) do AddCSLuaFile("vgui/" .. v); end
for k, v in pairs(file.Find("basicrp/gamemode/properties/ownable/*.lua","LUA")) do AddCSLuaFile("properties/ownable/" .. v); end
for k, v in pairs(file.Find("basicrp/gamemode/properties/not_ownable/*.lua","LUA")) do AddCSLuaFile("properties/not_ownable/" .. v); end
for k, v in pairs(file.Find("basicrp/gamemode/vehicles/basics/*.lua","LUA")) do AddCSLuaFile("vehicles/basics/" .. v); end
for k, v in pairs(file.Find("basicrp/gamemode/vehicles/police/*.lua","LUA")) do AddCSLuaFile("vehicles/police/" .. v); end

include("shared.lua")
include("sv_teams.lua")
include("sv_hooks.lua")
include("sv_vehicles.lua")
include("sv_config.lua")
include("sv_player.lua")
include("sv_payday.lua")
include("database/database.lua")
include("database/items.lua")

for k, v in pairs(file.Find("basicrp/gamemode/jobs/*.lua","LUA")) do include("jobs/" .. v); end


function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
  local dist = listener:GetPos():Distance(speaker:GetPos())

  if (dist <= 200) then
    return true
  end

  return false
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
  return(listener:GetPos():Distance(speaker:GetPos()) < 600)
end

util.AddNetworkString("menu_help")
util.AddNetworkString("police_info")
util.AddNetworkString("paramedics_info")
util.AddNetworkString("property_toggle")
util.AddNetworkString("player_notify")
util.AddNetworkString("inventory")

function GM:PlayerAuthed( ply, steamID, uniqueID )
  ply:databaseCheck()
end

function GM:PlayerDisconnected( ply )
  ply:databaseDisconnect()
end

function GM:ShowHelp(ply)
  net.Start("menu_help")
  net.Send(ply)
end


function GM:ShowTeam(ply)
  net.Start("inventory")
  net.Send(ply)
end


hook.Add("PlayerSay", "CommandId", function(ply, text, bteam) 
  text = string.lower(text)

  if (text == "!buddy") then

  end
end)

concommand.Add("lookatpos",function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  if !IsValid(ent) then return end
  print(ent)
  print(ent:GetOwner())
  print(ent:GetPos());
end)

concommand.Add("nosolid",function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  if !IsValid(ent) then return end
  ent:SetNotSolid(false)
end)

concommand.Add("setred",function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  if !IsValid(ent) then return end
  ent:SetColor(Color(255,0,0,255));
end)

concommand.Add("getkey",function(ply, cmd, args)
  ply:Give("rp_keys")
end)

concommand.Add("getlp",function(ply, cmd, args)
  ply:Give("rp_lockpick")
end)

concommand.Add("getbr",function(ply, cmd, args)
  ply:Give("rp_battering_ram")
end)

concommand.Add("getownership",function(ply, cmd, args)
  local id = tonumber(args[1])

  GAMEMODE:SetPropertyOwner(id, ply)
end)

concommand.Add("getpos", function(ply, cmd, args)
  print(ply:GetPos())
end)

concommand.Add("cleanup", function(ply, cmd, args)
  game.CleanUpMap()
end)

concommand.Add("getak",function(ply, cmd, args)
  ply:Give("fas2_ak47")
end)

concommand.Add("getammo",function(ply, cmd, args)
  ply:Give("fas2_ammo_762x39")
end)


concommand.Add("getsupp",function(ply, cmd, args)
  ply:Give("fas2_att_suppressor")
end)

concommand.Add("getmed",function(ply, cmd, args)
  ply:Give("rp_healthkit")
end)


concommand.Add("getacog",function(ply, cmd, args)
  ply:Give("fas2_att_compm4")
end)

concommand.Add("getp",function(ply, cmd, args)
  local id = tonumber(args[1])

  PrintTable(GAMEMODE:GetPropertyByID(id, ply))
end)

concommand.Add("givem",function(ply, cmd, args)
  local amount = tonumber(args[1])

  ply:GiveCash(amount)
end)

concommand.Add("give", function(ply, cmd, args)
  local item = args[1];

  ply:Give(item);
end)

concommand.Add("getdefib", function(ply, cmd, args)
  ply:Give("rp_defib");
end)

concommand.Add( "spawnvehicle", function( _p, _cmd, _args )
	local _v = ents.Create( "prop_vehicle_jeep" ); -- Type of vehicle to spawn.

	// Just in case the entity creation was unsuccessful.
	if ( !IsValid( _v ) ) then return; end

	_v:SetPos( _p:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
	_v:SetAngles( _p:GetAngles( ) + Angle( 0, 90, 0 ) ); -- Vehicles are rotated 90, so Left or so is typically their "Front"...
	_v:SetModel( "models/tdmcars/bug_veyronss.mdl" );
_v:SetSkin( 1 ); -- Optional, set the active skin.. For TDM it is usually 0-15 / 1-16..
	_v:SetKeyValue( "vehiclescript", "scripts/vehicles/tdmcars/veyronss.txt" );
	_v:Spawn( );
	_v:Activate( ); -- Activate needed for some vehicles such as prop_vehicle_airboat or it'll crash the server
end)

concommand.Add("spawnnpc", function(ply, cmd, args)
  local Ent = ents.Create("vc_npc_cardealer")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 50 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 90, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)


concommand.Add("spawnlight", function(ply, cmd, args)
  local Ent = ents.Create("stormfox_streetlight_invisible")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 0 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)

concommand.Add("spawnpot", function(ply, cmd, args)
  local Ent = ents.Create("ent_weed_plant")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)

concommand.Add("spawnweed", function(ply, cmd, args)
  local Ent = ents.Create("durgz_weed_custom")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)
concommand.Add("spawnseed", function(ply, cmd, args)
  local Ent = ents.Create("ent_weed_seed")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)

concommand.Add("killthomas", function(ply, cmd, args)
  local thomas = player.GetBySteamID("STEAM_0:0:70543533");
  if (thomas:GetName() != "thomas64") then
    thomas:Kill();
  end
end)

concommand.Add("give", function(ply, cmd, args)
  ply:Give("weapon_physgun")
end)
concommand.Add("getbodygroup", function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  if !IsValid(ent) then return end

  PrintTable(ent:GetBodyGroups())
end)

concommand.Add("lock", function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  if !IsValid(ent) then return end

  ent:Fire("lock")
end)

concommand.Add("time", function(ply, cmd, args)
  local Ent = ents.Create("stormfox_sunedit")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)

concommand.Add("panel", function(ply, cmd, args)
  local Ent = ents.Create("stormfox_weathercontroller")

  if (!IsValid(Ent)) then return end
  Ent:SetPos( ply:GetEyeTrace( ).HitPos + Vector( 0, 0, 20 ) ); -- Set vehicle position to spawn where we are looking, but off the ground 50 units ( where 16 units = 1 foot ).
  Ent:SetAngles( ply:GetAngles( ) + Angle( 0, 0, 0 ) );
  Ent:DropToFloor()
  Ent:Spawn()
end)

concommand.Add("arrest", function(ply, cmd, args)
  ply:Arrest(ply);
end)


concommand.Add("give2", function(ply, cmd, args)
  ply:Give("vc_spikestrip_wep")
end)

concommand.Add("setadmin", function(ply, cmd, args)
  ply:SetUserGroup("admin")
end)

concommand.Add("medic", function(ply, cmd, args)
  GAMEMODE.JobJoinMedic(ply)
end)
concommand.Add("police", function(ply, cmd, args)
  GAMEMODE.JobJoinPolice(ply);
end)
concommand.Add("fire", function(ply, cmd, args)
  ply:SetupTeam(TEAM_FIRE);
end)
concommand.Add("swat", function(ply, cmd, args)
  GAMEMODE.JobJoinSwat(ply);
end)
concommand.Add("mayor", function(ply, cmd, args)
  ply:SetupTeam(TEAM_MAYOR);
end)
concommand.Add("citizen", function(ply, cmd, args)
  ply:SetupTeam(TEAM_CITIZEN);
end)

concommand.Add("spider", function(ply, cmd, args)
  ply:SetupTeam(TEAM_SPIDERMAN);
end)

concommand.Add("gsa", function()
	local ent = player.GetAll()[1]:GetEyeTraceNoCursor().Entity
	if IsValid(ent) then
    PrintTable(ent:VC_getSeatsAvailable())
  end
end)

concommand.Add("proper", function(ply, cmd, args)
  ply:Give("tool_property")
end)

concommand.Add("opendoor", function(ply, cmd, args)
  local ent = ply:GetEyeTrace().Entity
  print("yaay")
  if !IsValid(ent) then return end
  ent:Fire("close");
end)