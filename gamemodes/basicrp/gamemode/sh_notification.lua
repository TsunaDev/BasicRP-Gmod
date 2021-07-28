local ply = FindMetaTable("Player")

NotifTypes = {}
NotifTypes["Error"] = NOTIFY_ERROR
NotifTypes["Hint"] = NOTIFY_HINT
NotifTypes["Generic"] = NOTIFY_GENERIC


function ply:Notify(str, duration, type)
  if SERVER && duration > 0 then
    net.Start("player_notify")
    net.WriteString(type)
    net.WriteString(str)
    net.WriteInt(duration, 16)
    net.Send(self)
  elseif CLIENT then
    notification.AddLegacy(str, NotifTypes[type], duration)
    surface.PlaySound('ambient/water/drip' .. math.random(1, 4) .. '.wav');
  end
end

if CLIENT then
  net.Receive("player_notify", function()
    local type = net.ReadString()
    LocalPlayer():Notify(net.ReadString(), net.ReadInt(16), type)
  end)
end