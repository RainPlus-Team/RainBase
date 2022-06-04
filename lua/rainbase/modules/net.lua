if SERVER then
    util.AddNetworkString("RainBase_NWString")
end

RainBase.Net = {}

function RainBase.Net.SetNWString(ply, key, value) -- NOTE: Only supports LocalPlayer currently.
    local k = util.Compress(key)
    local v = util.Compress(value)
    local len = string.len(k) + string.len(v)
    if string.len(k) > 255 then
        RainBase.Logging.Error("Tried to set a string with a key longer than 255 bytes after compressing.")
        return false
    end
    if len > 65531 then
        RainBase.Logging.Error("Tried to set a string longer than 65531 bytes after compressing.")
        return false
    end
    net.Start("RainBase_NWString")
        net.WriteUInt(string.len(k), 8)
        net.WriteData(k .. v)
    if SERVER then
        net.Send(ply)
    else
        net.SendToServer()
    end
end

function RainBase.Net.GetNWString(ply, key, fallback)
    return ply["RB_NWString_" .. key] or fallback
end

local plyMeta = FindMetaTable("Player")

function plyMeta:RB_SetNWString(key, value)
    RainBase.Net.SetNWString(self, key, value)
end

function plyMeta:RB_GetNWString(key, fallback)
    return RainBase.Net.GetNWString(self, key, fallback)
end

net.Receive("RainBase_NWString", function(len, ply)
    local kLen = net.ReadUInt(8)
    local data = net.ReadData(len - 8)
    local key = util.Decompress(string.sub(data, 1, kLen))
    local value = util.Decompress(string.sub(data, kLen))
    if SERVER then
        ply["RB_NWString_" .. key] = value
    else
        LocalPlayer()["RB_NWString_" .. key] = value
    end
end)