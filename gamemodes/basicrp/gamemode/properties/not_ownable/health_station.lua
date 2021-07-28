PROPERTY = {}

PROPERTY.ID = 7
PROPERTY.Name = "Health Station"
PROPERTY.Type = "Workplace"
PROPERTY.Location = "Downtown"
PROPERTY.Sublocation = "Commercial zone"
PROPERTY.Ownable = false

PROPERTY.Image = "healthstation"
PROPERTY.Description = "You can apply for the fire quad or paramedics there"

PROPERTY.Price = 0

PROPERTY.Doors = {2350, 2351, 1385, 1386, 1387, 1388, 1389, 2361, 2362, 2353, 2352, 2354}
PROPERTY.LockedDoors = {1385, 1386, 1387, 1388, 1389, 2361, 2362}

PROPERTY.AuthorizedTeams = {TEAM_MEDIC}

GAMEMODE:CreateProperty(PROPERTY)