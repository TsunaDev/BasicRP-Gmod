local ent = FindMetaTable("Entity")
PropertyList = {};

function GM:CreateProperty(property)
  if PropertyList[property.ID] then
    print("Conflict with property " .. property.ID .. " already existing..")
    return false
  end

  if CLIENT then 
    property.Material = "vgui/" .. property.Image
  else
    for k, id in pairs(property.Doors) do
      local entity = ents.GetMapCreatedEntity(id)
      SetGlobalInt("door_" .. entity:EntIndex(), id);
      if table.HasValue(property.LockedDoors, id) then
        entity:Fire("lock")
      end
      entity.PropertyID = property.ID
    end
  end

  PropertyList[property.ID] = property
end

function GM:GetDoorOwner(door)
  if !door or !door:IsDoor() then return end

  return GAMEMODE:GetPropertyOwnerByID(door.PropertyID)
end

function GM:ToggleProperty(ID, ply)
  local curOwner = GAMEMODE:GetPropertyOwnerByID(ID)
  if curOwner and curOwner:IsPlayer() and curOwner == ply then
    ply:GiveCash(PropertyList[ID].Price / 2);
    SetGlobalEntity(ID .. "_owner", NULL)
    ply:Notify("You just sold " .. PropertyList[ID].Name .. " for $" .. PropertyList[ID].Price / 2  .. "!", 6, "Generic")
  elseif curOwner and curOwner != NULL and curOwner:IsPlayer() then
    print(curOwner)
    ply:Notify("Property already owned.", 6, "Error")
  else
    if ply:TakeCash(PropertyList[ID].Price) then
      SetGlobalEntity(ID .. "_owner", ply)
      ply:Notify("You just bought " .. PropertyList[ID].Name .. " for $" .. PropertyList[ID].Price .. "!", 6, "Generic")
    else
      ply:Notify("You don't have enough money!", 6, "Error")
    end
  end
end

function GM:GetPropertyOwnerByID(ID)
  return GetGlobalEntity(ID .. "_owner")
end

function GM:GetPropertyByID(ID)
  return PropertyList[ID]
end

function ent:IsDoor()
  return string.find(self:GetClass(), "door");
end

if SERVER then
  
  net.Receive("property_toggle", function(len, ply)
    local id = net.ReadInt(8)
    
    GAMEMODE:ToggleProperty(id, ply)
  end)

end

local doorProperty = {};
function ent:GetDoorProperty()
	if (!self:IsDoor()) then return nil; end
  local id = GetGlobalInt("door_" .. self:EntIndex());
  if !doorProperty[id] then
    for k, v in pairs(PropertyList) do
      for _, doorID in pairs(v.Doors) do
        if (id == doorID) then
          doorProperty[id] = k;
        end
			end
		end
	end
	
	return PropertyList[doorProperty[id]];
end