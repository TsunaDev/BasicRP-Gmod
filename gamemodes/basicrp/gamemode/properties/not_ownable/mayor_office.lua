PROPERTY = {}

PROPERTY.ID = 12
PROPERTY.Name = "Mayor's office"
PROPERTY.Type = "Government"
PROPERTY.Location = "Downtown"
PROPERTY.Sublocation = "Government Tower"
PROPERTY.Ownable = false

PROPERTY.Image = "govt"
PROPERTY.Description = "4th floor of the Government Tower."

PROPERTY.Price = 0

PROPERTY.Doors = {2501, 2502, 2687, 2688}
PROPERTY.LockedDoors = {}

PROPERTY.AuthorizedTeams = {TEAM_MAYOR}

GAMEMODE:CreateProperty(PROPERTY)