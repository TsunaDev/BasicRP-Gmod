VehiclesList = {}
VehiclesPoliceList = {}
VehiclesMedicList = {}
OwnedVehicles = {}

function GM:InitVehicle(vehicle)
    if VehiclesList[vehicle.ID] then
        print("Conflict with vehicle " .. vehicle.ID .. " already existing..")
        return false
    end
    VehiclesList[vehicle.ID] = vehicle
end

function GM:InitPoliceVehicle(vehicle)
    if VehiclesPoliceList[vehicle.ID] then
        print("Conflict with police vehicle " .. vehicle.ID .. " already existing..")
        return false
    end
    VehiclesPoliceList[vehicle.ID] = vehicle
end

function GM:InitMedicVehicle(vehicle)
    if VehiclesMedicList[vehicle.ID] then
        print("Conflict with paramedic vehicle " .. vehicle.ID .. " already existing..")
        return false
    end
    VehiclesMedicList[vehicle.ID] = vehicle
end

-- Check if player has the car (client)
function GM:CheckPlayerCars(ID)
    for id, value in pairs(OwnedVehicles) do
        if value == ID then
                return id;
        end
    end
    return 0;
end

-- Add/remove car (client)
function GM:ToggleVehicleCli(ID)
    local index = GAMEMODE:CheckPlayerCars(ID);
    if (index == 0) then
        table.insert(OwnedVehicles, ID);
    else
        table.remove(OwnedVehicles, index)
    end
end

net.Receive ("toggle_car_cli", function()
    local ID = net.ReadInt(8);
    GAMEMODE:ToggleVehicleCli(ID);
end)

