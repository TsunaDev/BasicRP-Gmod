VehiclesPData = {}

-- Load the owned vehicles file
local function LoadVehiclesPData()
    local data = file.Read( "player_vehicles.txt", "DATA" )
    if not data then return end

    print (data);
    data = string.Split(data, "\n")
    for _, line in ipairs(data) do
        local args = string.Split( line, ";" );
        local id = args[1];
        if not id then return end
        VehiclesPData[id] = {};
        table.remove(args, 1);
        for k, vehicle in ipairs(args) do
            table.add(VehiclesPData[id], vehicle);
        end
    end
end

LoadVehiclesPData()

-- Load player data upon connection or initialize it
function GM:PlayerInitV(ply)
    print ("New Player");
    local sid = ply:SteamID();
    if not VehiclesPData[sid] then
        VehiclesPData[sid] = {};
    end
    table.insert(VehiclesPData[ply:SteamID()], 10);
    -- Update Cli list of vehicles owned by player
    net.Start("toggle_car_cli");
    net.WriteInt(10, 8);
    net.Send(ply);
end

-- Write/save in the file when the server restart
hook.Add( "ShutDown", "SavePlayerData", function()
    print ("Saving data into file");

    local str = "";
    for id, args in pairs( VehiclesPData ) do
        str = str .. id;
        for _, arg in pairs( args ) do
            str = str .. ";" .. arg;
        end

        str = str .. "\n";
    end

    file.Write("player_vehicles.txt", str)
end )

-- Check if player own the specified car
function GM:GetCarOwned(ID, ply)
    if (VehiclesPData[ply:SteamID()] == nil) then
        VehiclesPData[ply:SteamID()] = {};
    end
    for id, value in pairs(VehiclesPData[ply:SteamID()]) do
        if value == ID then
            return id;
        end
    end
    return 0;
end

-- Allow player to buy or sell a vehicle
function GM:ToggleVehicle(ID, ply)
    local index = GAMEMODE:GetCarOwned(ID, ply);
    if (index == 0) then
        if (ply:TakeCash(VehiclesList[ID].Price)) then
            -- Take money from player
            table.insert(VehiclesPData[ply:SteamID()], ID);
            print (ply:SteamID(), " buying ", ID);
            ply:Notify("You just bought " .. VehiclesList[ID].Name .. " !", 6, "Generic");
        else
            ply:Notify("You don't have enough money to buy " .. VehiclesList[ID].Name .. " !", 6, "Generic");
            return;
        end
    else
        -- Give half money to player
        table.remove(VehiclesPData[ply:SteamID()], index)
        print (ply:SteamID(), " selling ", ID);
        local price = VehiclesList[ID].Price / 2;
        ply:GiveCash(price);
        GAMEMODE:RemoveCars(ply, ID);
        ply:Notify("You just sold " .. VehiclesList[ID].Name .. " for " .. price .. " $ !", 6, "Generic");
    end
    -- Update Cli list of vehicles owned by player
    net.Start("toggle_car_cli");
    net.WriteInt(ID, 8);
    net.Send(ply);
end

function GM:RemoveCars(ply, ID)
    local cars = ents.FindByClass("prop_vehicle_jeep");
    ID = ID or 0;
    for i, car in pairs(cars) do
        if (IsValid(car)) then

            -- Simply remove car (player spawning another car or disconnecting)
            if (ID == 0) then
                if ((car:GetTable().Owner == ply)) then
                    print("Vehicles " .. car:GetName() .. " removed");
                    car:Remove();
                end

            -- Remove specific car (player selling car)
            else
                if ((car:GetTable().Owner == ply) and (car:GetName() == VehiclesList[ID].Name)) then
                    print("Vehicles " .. car:GetName() .. " removed (sold)");
                    car:Remove();
                end
            end
        end
    end
end

-- Spawn vehicle near Vendor Spawner
function GM:SpawnCarVendor(ID, ply, _v)
    local spawnable = false;
    local x = 6250;
    local area;
    while spawnable == false and x <= 6850 do
        area = ents.FindInSphere(Vector(x, -3700, 80), 50);
        spawnable = true;
        for k, entity in pairs(area) do
            if (IsValid(entity)) then
                spawnable = false;
                x = x + 50;
                break;
            end
        end
    end
    if (spawnable == true) then
        _v:SetName(VehiclesList[ID].Name);
        _v:SetPos(Vector(x, -3700, 80));
        _v:SetAngles(Angle( 0, -180, 0));
        _v:SetModel(VehiclesList[ID].Model);
        _v:SetSkin(1);
        _v:SetKeyValue("vehiclescript", VehiclesList[ID].KeyValue);
        --_v:SetOwner(ply);
        _v:GetTable().Owner = ply;
        _v:DropToFloor();
        _v:Spawn();
        _v:Activate();
    else
        ply:Notify("Something is blocking the spawn area !", 6, "Generic");
    end
end

-- Spawn vehicle near Garage
function GM:SpawnCarGarage(ID, ply, _v)
    local spawnable = false;
    local x = -5250;
    local area;
    while spawnable == false and x <= -3800 do
        area = ents.FindInSphere(Vector(x, -10600, 80), 50);
        spawnable = true;
        for k, entity in pairs(area) do
            if (IsValid(entity)) then
                spawnable = false;
                x = x + 50;
                break;
            end
        end
    end
    if (spawnable == true) then
        _v:SetName(VehiclesList[ID].Name);
        _v:SetPos(Vector(x, -10600, 80));
        _v:SetAngles(Angle( 0, -180, 0));
        _v:SetModel(VehiclesList[ID].Model);
        _v:SetSkin(1);
        _v:SetKeyValue("vehiclescript", VehiclesList[ID].KeyValue);
        --_v:SetOwner(ply);
        _v:GetTable().Owner = ply;
        _v:DropToFloor();
        _v:Spawn();
        _v:Activate();
    else
        ply:Notify("Something is blocking the spawn area !", 6, "Generic");
    end
end

-- Attempt to spawn requested vehicle if position is valid
function GM:SpawnCar(ID, ply)
    local _v = ents.Create(VehiclesList[ID].Type); -- Type of vehicle to spawn.

    if (IsValid(_v)) then
        -- Remove old vehicle
        GAMEMODE:RemoveCars(ply);
        -- Try spawning vehicle (check player pos to determine wich spawning npc is near)
        local pos = ply:GetPos();
        if (pos[1] < -3700) then
            GAMEMODE:SpawnCarGarage(ID, ply, _v);
        else
            GAMEMODE:SpawnCarVendor(ID, ply, _v);
        end
    else
        return;
    end
end

function GM:CustomizeCar(color, ply)
    local area = ents.FindInSphere(Vector(4370, -4245, 128), 1000);
    local customized = false;
    for k, entity in pairs(area) do
        if (IsValid(entity) and entity:GetClass() == "prop_vehicle_jeep" and entity:GetTable().Owner == ply) then
            if (ply:TakeCash(1000)) then
                entity:SetColor(color);
                ply:Notify("Vehicle customized !", 6, "Generic");
            else
                ply:Notify("You don't have enough money to customize this car !", 6, "Generic");
            end
            customized = true;
            break;
        end
    end
    if (customized == false) then
        ply:Notify("Can't find your vehicle, please get it closer", 6, "Generic");
    end
end

util.AddNetworkString("toggle_car")
util.AddNetworkString("spawn_car")
util.AddNetworkString("toggle_car_cli");
util.AddNetworkString("custom_car");

net.Receive ("spawn_car", function(len, ply)
    local ID = net.ReadInt(8);
    GAMEMODE:SpawnCar(ID, ply);
end)

net.Receive ("toggle_car", function(len, ply)
    local ID = net.ReadInt(8);
    GAMEMODE:ToggleVehicle(ID, ply);
end)

net.Receive ("custom_car", function(len, ply)
    local color = net.ReadColor();
    GAMEMODE:CustomizeCar(color, ply);
end)

