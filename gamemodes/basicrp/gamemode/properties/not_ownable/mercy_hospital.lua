PROPERTY = {}

PROPERTY.ID = 13
PROPERTY.Name = "Mercy Hospital"
PROPERTY.Type = "Store"
PROPERTY.Location = "Suburbs"
PROPERTY.Sublocation = "Lake"
PROPERTY.Ownable = false

PROPERTY.Image = "mercy"
PROPERTY.Description = "You can change your appearance, sex or increase your skill points there."

PROPERTY.Price = 0

PROPERTY.Doors = {3497, 3496, 3501, 3500, 3587, 3586, 3589, 3588, 3592, 3593, 3591, 3590, 3585, 3499, 3498}
PROPERTY.LockedDoors = {3501, 3500, 3587, 3586, 3589, 3588, 3592, 3593, 3591, 3590, 3585, 3499, 3498}

PROPERTY.AuthorizedTeams = {TEAM_MEDIC}

GAMEMODE:CreateProperty(PROPERTY)