local items = {}

if SERVER then
	util.AddNetworkString("spawn_prop")

	net.Receive( "spawn_prop", function( length, ply )
		local str = string.lower(net.ReadString())
		local typ = net.ReadString()
                if (typ == "weapon") then typ = "ent_prop" end 
		local ent = ents.Create( typ )
		if ( !IsValid( ent ) ) then return end
		local mod = net.ReadString()
		ent:SetModel(mod)
		local tr = ply:GetEyeTrace()
		ent:SetPos( tr.HitPos + Vector( 0, 0, 50 ) )
		ent:SetContents(net.ReadInt(5), ply, str)
		ent:Spawn()
		ent:Activate()
		ply:changeValueOfItem(str, -1)
	end)
end

function getItems( name )
	if items[name] then
		return items[name];
	end
	return false
end

function getItemsList()
	return items
end

items["ak_47"] = {
	id = 0,
	name = "AK-47",
	desc = "Powerful automatic weapon",
	ent = "weapon",
	model = "models/weapons/w_smg1.mdl",
	craftable = true,
	recipe = {
		ak_47_canon = 1,
		ak_47_crosse = 1,
		ak_47_corps = 1
	},
	weapon_name = "fas2_ak47",
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["ak_47_canon"] = {
	id = 1,
	name = "AK-47 Barrel",
	desc = "Used to build a AK-47",
	ent = "ent_prop",
	model = "models/mechanics/gears2/gear_24t1.mdl",
	craftable = true,
	recipe = {
		iron = 10,
		wood = 2
	},
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["ak_47_crosse"] = {
	id = 2,
	name = "AK-47 Hand Grip",
	desc = "Used to build a AK-47",
	ent = "ent_prop",
	model = "models/mechanics/gears2/gear_24t1.mdl",
	craftable = true,
	recipe = {
		iron = 2,
		wood = 10
	},
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["ak_47_corps"] = {
	id = 3,
	name = "AK-47 body part",
	desc = "Used to build a AK-47",
	ent = "ent_prop",
	model = "models/mechanics/gears2/gear_24t1.mdl",
	craftable = true,
	recipe = {
		steel = 10,
		iron = 5,
		wood = 10,
		metal = 2
	},
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["iron"] = {
	id = 4,
	name = "Iron",
	desc = "Used to craft strong items",
	ent = "ent_prop",
	model = "models/props_phx/misc/iron_beam1.mdl",
	craftable = false,
	can_buy = true,
	can_sell = true,
	buy_price = 20,
	sell_price = 10,
}
items["metal"] = {
	id = 5,
	name = "Metal",
	desc = "Material used for crafting",
	ent = "ent_prop",
	model = "models/phxtended/bar1x.mdl",
	use = (function(ply, ent)
	end),
	spawn = (function(ply, ent)
		ent:SetItemName("Metal")
	end),
	skin = 0,
	buttonDist = 32,
	craftable = false,
	can_buy = true,
	can_sell = true,
	buy_price = 10,
	sell_price = 5,
}
items["metal_fence"] = {
	id = 6,
	name = "Metal Fence",
	desc = "You usually don't sit on it",
	ent = "ent_prop",
	model = "models/props_c17/fence01a.mdl",
	use = (function(ply, ent)
	end),
	spawn = (function(ply, ent)
	end),
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		metal = 3
	},
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["steel"] = {
	id = 7,
	name = "Steel",
	desc = "Used to craft powerful items",
	ent = "ent_prop",
	model = "models/props_phx/construct/metal_plate1.mdl",
	craftable = false,
	can_buy = true,
	can_sell = true,
	buy_price = 50,
	sell_price = 25,
}
items["wood"] = {
	id = 8,
	name = "Wood",
	desc = "Material used for crafting",
	ent = "ent_prop",
	model = "models/props_phx/construct/wood/wood_boardx1.mdl",
	use = (function(ply, ent)
	end),
	spawn = (function(ply, ent)
	end),
	skin = 0,
	buttonDist = 32,
	craftable = false,
	can_buy = true,
	can_sell = true,
	buy_price = 5,
	sell_price = 3,
}
items["wooden_chair"] = {
	id = 9,
	name = "Wooden Chair",
	desc = "You usually sit on it",
	ent = "ent_prop",
	model = "models/props_c17/FurnitureChair001a.mdl",
	use = (function(ply, ent)
	end),
	spawn = (function(ply, ent)
	end),
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		wood = 3
	},
	can_buy = true,
	can_sell = false,
	buy_price = 20,
	sell_price = 0,
}
items["concrete_barrier"] = {
	id = 10,
	name = "Wooden Chair",
	desc = "You usually sit on it",
	ent = "ent_prop",
	model = "models/props_c17/concrete_barrier001a.mdl",
	use = (function(ply, ent)
	end),
	spawn = (function(ply, ent)
	end),
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		iron = 3
	},
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["weed_pot"] = {
	id = 11,
	name = "Weed Pot",
	desc = "Used to grow Weed, a illegal substance",
	ent = "ent_weed_plant",
	model = "models/nater/weedplant_pot_dirt.mdl",
	craftable = false,
	can_buy = true,
	can_sell = true,
	buy_price = 20,
	sell_price = 10,
}
items["weed_seed"] = {
	id = 12,
	name = "Weed Seed",
	desc = "Use it on a pot to grow Weed",
	ent = "ent_weed_seed",
	model = "models/katharsmodels/contraband/zak_wiet/zak_seed.mdl",
	craftable = false,
	can_buy = true,
	can_sell = false,
	buy_price = 2,
	sell_price = 0,
}
items["weed"] = {
	id = 13,
	name = "Weed",
	desc = "Don't do drugs",
	ent = "durgz_weed_custom",
	model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	craftable = false,
	can_buy = false,
	can_sell = true,
	buy_price = 0,
	sell_price = 50,
}
items["mp5"] = {
	id = 14,
	name = "MP5",
	desc = "Sub-machine gun",
	ent = "weapon",
	model = "models/weapons/w_smg1.mdl",
	craftable = true,
	recipe = {
		steel = 20,
		iron = 10,
		wood = 5,
		metal = 20
	},
	weapon_name = "fas2_mp5a5",
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["m24"] = {
	id = 15,
	name = "M24",
	desc = "Sniper Rifle",
	ent = "weapon",
	model = "models/weapons/w_smg1.mdl",
	craftable = true,
	recipe = {
		steel = 30,
		iron = 15,
		wood = 15,
		metal = 20
	},
	weapon_name = "fas2_m24",
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["shotgun"] = {
	id = 16,
	name = "Shotgun",
	desc = "Shotgun for close range combat",
	ent = "weapon",
	model = "models/weapons/w_smg1.mdl",
	craftable = true,
	recipe = {
		steel = 20,
		iron = 15,
		wood = 25,
		metal = 20
	},
	weapon_name = "fas2_m3s90",
	can_buy = false,
	can_sell = false,
	buy_price = 0,
	sell_price = 0,
}
items["wooden_chair"] = {
	id = 17,
	name = "Wooden Panel",
	desc = "You can use it to cover a window",
	ent = "ent_prop",
	model = "models/props_phx/construct/wood/wood_panel1x1.mdl",
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		wood = 6
	},
	can_buy = true,
	can_sell = false,
	buy_price = 30,
	sell_price = 0,
}
items["couch"] = {
	id = 18,
	name = "Couch",
	desc = "You can see on it",
	ent = "ent_prop",
	model = "models/props_c17/FurnitureCouch001a.mdl",
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		wood = 10
	},
	can_buy = true,
	can_sell = false,
	buy_price = 50,
	sell_price = 0,
}
items["low_table"] = {
	id = 19,
	name = "Low Table",
	desc = "Use it to decorate your house",
	ent = "ent_prop",
	model = "models/props_c17/FurnitureTable003a.mdl",
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		wood = 5
	},
	can_buy = true,
	can_sell = false,
	buy_price = 25,
	sell_price = 0,
}
items["table"] = {
	id = 20,
	name = "Table",
	desc = "Use it to decorate your house",
	ent = "ent_prop",
	model = "models/props_c17/FurnitureTable003a.mdl",
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		wood = 7
	},
	can_buy = true,
	can_sell = false,
	buy_price = 35,
	sell_price = 0,
}
items["metal_panel"] = {
	id = 21,
	name = "Metal Panel",
	desc = "Use it to cover doors and windows",
	ent = "ent_prop",
	model = "models/props_phx/construct/metal_plate2x2.mdl",
	skin = 0,
	buttonDist = 32,
	craftable = true,
	recipe = {
		metal = 5
	},
	can_buy = true,
	can_sell = false,
	buy_price = 50,
	sell_price = 0,
}