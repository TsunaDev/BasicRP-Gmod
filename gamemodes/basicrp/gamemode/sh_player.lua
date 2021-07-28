local PLAYER = FindMetaTable("Player")

function PLAYER:GetCash()
  return GetGlobalInt(self:SteamID() .. "_cash");
end