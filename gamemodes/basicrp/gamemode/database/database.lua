local ply = FindMetaTable("Player")
util.AddNetworkString( "database" )
util.AddNetworkString("inventory")

util.AddNetworkString("addItem")
util.AddNetworkString("dropItem")
util.AddNetworkString("craftItem")
util.AddNetworkString("equipWeapon")

function ply:ShortSteamID()
	local id = self:SteamID()
	local id = tostring(id)
	local id = string.Replace(id, "STEAM_0:0:", "")
	local id = string.Replace(id, "STEAM_0:1:", "")
	return id
end

function ply:existInTab(key, tab)
	for index, data in pairs(tab) do
		if index == key then
			return true
		end
	end
	return false
end

function ply:databaseDefault()
	self:databaseSetValue( "money", 100 )
	local inv = getItemsList()
	local i = {}
	for index, data in pairs(inv) do
	    i[index] = { amount = 0 }
	end
	self:databaseSetValue( "inventory", i )
end

function ply:databaseCheckNewItems()
	local inv = getItemsList()
	local i = {}
	plyDB = self:databaseGetValue("inventory")
	for index, data in ipairs(inv) do
		--if self:existInTab(inv[index], plyDB) then
		--	i[index] = { amount = 3 }
		--else
		--	i[index] = { amount = 0 }
		--end
	end
	-- self:databaseSetValue( "inventory", i )
end

function ply:databaseNetworkedData()
	local money = self:databaseGetValue( "money" )
	self:SetNWInt("money", money)

	self:KillSilent()
	self:Spawn()
end

function ply:databaseFolders()
	return "server/BasicRP/players" .. self:ShortSteamID() .. "/"
end

function ply:databasePath()
	return self:databaseFolders() .. "database.txt"
end

function ply:databaseSet( tab )
	self.database = tab
end

function ply:databaseGet()
	return self.database
end

function ply:databaseCheck()
	self.database = {}
	local f = self:databaseExists()
	if f then
		self:databaseRead()
	else
		self:databaseCreate()
		self:databaseRead()
	end
	self:databaseSend()
	self:databaseNetworkedData()
end

function ply:databaseSend()
	net.Start( "database" )
		net.WriteTable ( self:databaseGet() )
	net.Send(self)
end

function ply:databaseExists()
	local f = file.Exists(self:databasePath(), "DATA")
	return f
end

function ply:databaseRead()
	local str = file.Read(self:databasePath(), "DATA")
	self:databaseSet( util.KeyValuesToTable(str) )
end

function ply:databaseSave()
	local str = util.TableToKeyValues(self.database)
	local f = file.Write(self:databasePath(), str)
	self:databaseSend()
end

function ply:databaseCreate()
	self:databaseDefault()
	local b = file.CreateDir( self:databaseFolders() )
	self:databaseSave()
end

function ply:databaseDisconnect()
	self:databaseSave()
end

function ply:databaseSetValue( name, v )
	if not v then return end

	--if type(v) == "table" then
	--	if name == "inventory" then
	--		for k,b in pairs(v) do
	--			if b.amount <= 0 then
	--				v[k] = nil
	--			end
	--		end
	--	end
	--end

	local d = self:databaseGet()
	d[name] = v

	self:databaseSave()
end

function ply:databaseGetValue( name )
	local d = self:databaseGet()
	return d[name]
end

function GM:inventoryMenu( ply )
	net.Start("inventory")
  	net.Send(ply)
end
function ply:changeValueOfItem(str, diff)
        print(str)
	inv = self:databaseGetValue("inventory")
	for index, data in pairs(inv) do
	    if index == str then
		    for key, value in pairs(data) do
		    	data[key] = value + diff
		    end
	    end
	end
	self:databaseSetValue("inventory", inv)
end


net.Receive( "addItem", function(len, ply)
	str = string.lower(net.ReadString())
	ply:changeValueOfItem(str, 1)
end)

net.Receive( "dropItem", function(len, ply)
	str = string.lower(net.ReadString())
	ply:changeValueOfItem(str, -1)
end)

net.Receive("craftItem", function(len, ply)
	name = string.lower(net.ReadString())
	inv = ply:databaseGetValue("inventory")
	recipe = net.ReadTable()
	for index, data in pairs(inv) do
	    if index == name then
		    for key, value in pairs(data) do
		    	data[key] = value + 1
		    end
	    end
	    for mat, am in pairs(recipe) do
			if index == mat then
				for key, value in pairs(data) do
			    	data[key] = value - am
			    end
			end
		end
	end
	ply:databaseSetValue("inventory", inv)
end)

net.Receive("equipWeapon", function (len, ply)
	name = string.lower(net.ReadString())
	ply:Give(name, false)
end)