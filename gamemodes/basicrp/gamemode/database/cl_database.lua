include("items.lua")

local ply = FindMetaTable("Player")
local database = {}

local function databaseReceive( tab )
	database = tab
end

net.Receive("database", function(len)
	local tab = net.ReadTable()
	databaseReceive( tab )
end)

function databaseTable()
	return database
end

function databaseGetValue( name )
	local d = databaseTable()
	return d[name]
end

function inventoryTable()
	-- print(databaseGetValue("inventory"))
	return databaseGetValue( "inventory" ) or {}
end

function inventoryHasItem( name , amount )
	if not amount then amount = 1 end

	local i = inventoryTable()

	if i then
		if i[name] then
			if i[name].amount >= amount then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

local SKINS = {}
SKINS.COLORS = {
				lightgrey = Color(131, 131, 131, 180),
				grey = Color(111, 111, 111, 180),
				lowWhite = Color(243, 243, 243, 180),
				goodBlack = Color(41, 41, 41, 230),
				}
function SKINS:DrawFrame(w, h)
	topHeight = 24
	local rounded = 4
	draw.RoundedBoxEx( rounded, 0, 0, w, topHeight, SKINS.COLORS.lightgrey, true, true, false, false )
	draw.RoundedBoxEx( rounded, 0, topHeight, w, h-topHeight, SKINS.COLORS.lightgrey, false, false, true, true )
	draw.RoundedBoxEx( rounded, 2, topHeight, w-4, h-topHeight-2, SKINS.COLORS.goodBlack, false, false, true, true )

	local QuadTable = {}
	QuadTable.texture = surface.GetTextureID( "gui/gradient" )
	QuadTable.color = Color(10, 10, 10, 120)
	QuadTable.x = 2
	QuadTable.y = topHeight
	QuadTable.w = w-4
	QuadTable.h = h-topHeight-2
	draw.TexturedQuad(QuadTable)
end

local function inventoryItemButton( iname, name, amount, desc, model, parent, dist, buttons, id)
	if not dist then dist = 128 end
	local p = vgui.Create( "DPanel", parent )
	p:SetPos( 4, 4 )
	p:SetSize( 64, 64 )

	local mp = vgui.Create( "DModelPanel", p )
	mp:SetSize( p:GetWide(), p:GetTall() )
	mp:SetPos( 0, 0 )
	mp:SetModel( model )
	mp:SetCamPos( Vector(dist, dist, dist ) )
	mp:SetLookAt( Vector(0, 0, 0 ) )
	mp:SetFOV( 20 )

	function mp:LayoutEntity(Entity)
		self:RunAnimation();
		Entity:SetSkin(getItems(iname).skin or 0)
		-- Entity:SetAngle( Angle(0, 0, 0 ) )
	end

	local b = vgui.Create( "DButton", p)
	b:SetPos(4,4)
	b:SetSize(64, 64)
	b:SetText("")
	b:SetToolTip(name .. ":\n\n" .. desc)

	b.DoClick = function()
		local opt = DermaMenu()
		for k, v in pairs(buttons) do
			opt:AddOption(k, v)
		end
		opt:Open()
	end

	b.DoRightClick = function()
	end

	function b.Paint()
		return true
	end

	if amount then
		local l = vgui.Create("DLabel", p)
		l:SetPos(6,4)
		l:SetFont("default")
		l:SetText(amount)
		l:SizeToContents()
	end

	return p;
end

local function can_craft( irecipe )
	for index, data in pairs(irecipe) do
		if inventoryHasItem(index, data) == false then
			return false;
		end
	end
	return true;
end

net.Receive("inventory", function()
	local w = 506
	local h = 512

	local f = vgui.Create("DFrame")
	f:SetSize( w, h)
	f:SetPos( (ScrW()/ 2) - (w/2), (ScrH()/2) - (h/2) )
	f:SetTitle("Inventory")
	f:SetDraggable(true)
	f:ShowCloseButton(true)
	f:MakePopup()
	f.Paint = function()
		SKINS:DrawFrame(f:GetWide(), f:GetTall())
	end

	local ps = vgui.Create("DPropertySheet", f)
	ps:SetPos( 8, 28 )
	ps:SetSize( w - 16, h - 36 )

	local padding = 4

	local items = vgui.Create( "DPanelList", ps)
	items:SetPos(padding, padding)
	items:SetSize( w - 32 - padding*2, h-48-padding*2)
	items:EnableVerticalScrollbar( true )
	items:EnableHorizontal(true)
	items:SetPadding( padding )
	items:SetSpacing( padding )
	function items:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60 ) )
	end

	local craft = vgui.Create( "DPanelList", ps)
	craft:SetPos(padding, padding)
	craft:SetSize( w - 32 - padding*2, h-48-padding*2)
	craft:EnableVerticalScrollbar( true )
	craft:EnableHorizontal(true)
	craft:SetPadding( padding )
	craft:SetSpacing( padding )
	function craft:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60 ) )
	end

	local buy = vgui.Create( "DPanelList", ps)
	buy:SetPos(padding, padding)
	buy:SetSize( w - 32 - padding*2, h-48-padding*2)
	buy:EnableVerticalScrollbar( true )
	buy:EnableHorizontal(true)
	buy:SetPadding( padding )
	buy:SetSpacing( padding )
	function buy:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60 ) )
	end

	local sell = vgui.Create( "DPanelList", ps)
	sell:SetPos(padding, padding)
	sell:SetSize( w - 32 - padding*2, h-48-padding*2)
	sell:EnableVerticalScrollbar( true )
	sell:EnableHorizontal(true)
	sell:SetPadding( padding )
	sell:SetSpacing( padding )
	function sell:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(60, 60, 60 ) )
	end

	local inventory = inventoryTable()

	local function ItemButtons(items)
		for k, v in pairs(inventory) do
			local i = getItems(k)
			if i then
				local buttons = {}
				if v.amount > 0 then
					buttons["spawn"] = (function()
						f:Close()
						net.Start("spawn_prop")
						net.WriteString(k)
						net.WriteString(i.ent)
						net.WriteString(i.model)
						net.WriteInt(i.id, 5)
						net.SendToServer()
					end)
				end

				if (i.ent == "weapon" and v.amount > 0) then
					buttons["equip"] = (function()
						f:Close()
						net.Start("equipWeapon")
						net.WriteString( i.weapon_name )
						net.SendToServer()
					end)
				end

				local b = inventoryItemButton( k, i.name .. " (" .. v.amount .. ")", v.amount, i.desc, i.model, items, i.buttonDist, buttons, i.id )
				items:AddItem(b)
			end
		end
	end

	local function CraftButtons(items)
		for k, v in pairs (inventory) do
			local i = getItems(k)
			if i then
				local buttons = {}
				if i.craftable == true then
					if can_craft(i.recipe) == true then
						buttons["craft"] = (function()
							f:Close()
							net.Start("craftItem")
							net.WriteString(k)
							net.WriteTable(i.recipe)
							net.SendToServer()
						end)
					end
					buttons["show_recipe"] = (function()
						f:Close()
						notification.AddLegacy( "Recipe for ".. i.name, NOTIFY_UNDO, 2 )
						surface.PlaySound( "buttons/button15.wav" )
						for index, data in pairs(i.recipe) do
							print(index)
							print(data)
							notification.AddLegacy( "- " .. index .. " : " .. data,  NOTIFY_UNDO, 2)
						end
					end)
					local b = inventoryItemButton( k, i.name .. " (" .. v.amount .. ")", v.amount, i.desc, i.model, items, i.buttonDist, buttons, i.id )
					items:AddItem(b)
				end
			end
		end
	end

	local function BuyButtons(items)
		for k, v in pairs (inventory) do
			local i = getItems(k)
			if i then
				local buttons = {}
				if i.can_buy == true then

					buttons["Buy"] = (function()
						f:Close()
						net.Start("buy_item")
						net.WriteInt(i.buy_price, 8)
                                                net.WriteString(k)
                                                net.WriteInt(1, 5)
						net.SendToServer()
					end)

                                        buttons["Buy 10"] = (function()
						f:Close()
						net.Start("buy_item")
						net.WriteInt(i.buy_price, 8)
                                                net.WriteString(k)
                                                net.WriteInt(10, 5)
						net.SendToServer()
					end)
					local b = inventoryItemButton( k, i.name, v.buy_price, i.desc, i.model, items, i.buttonDist, buttons, i.id )
					items:AddItem(b)
				end
			end
		end
	end

	local function SellButtons(items)
		for k, v in pairs (inventory) do
			local i = getItems(k)
			if i then
				local buttons = {}
				if (i.can_sell == true && v.amount > 0) then

					buttons["Sell"] = (function()
						f:Close()
						net.Start("sell_item")
						net.WriteInt(i.sell_price, 8)
                                                net.WriteString(k)
						net.SendToServer()
					end)
					local b = inventoryItemButton( k, i.name, v.buy_price, i.desc, i.model, items, i.buttonDist, buttons, i.id )
					items:AddItem(b)
				end
			end
		end
	end

	ItemButtons(items)
	CraftButtons(craft)
	BuyButtons(buy)
	SellButtons(sell)

	ps:AddSheet( "Items", items, "icon16/box.png", false, false, "Your items are stored here...")
	ps:AddSheet( "Crafting", craft, "icon16/box.png", false, false, "Crafting here...")
	ps:AddSheet( "Buying", buy, "icon16/box.png", false, false, "Buy items here...")
	ps:AddSheet( "Selling", sell, "icon16/box.png", false, false, "Sell items here...")

end)

