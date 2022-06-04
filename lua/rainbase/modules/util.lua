RainBase.Util = {}

if SERVER then
    function RainBase.Util.AddCSLuaDir(path)
        local files = file.Find(path .. "/*.lua", "LUA")
        for _, v in ipairs(files) do
            AddCSLuaFile(path .. "/" .. v)
        end
    end
end

function RainBase.Util.IncludeDir(path)
    local files = file.Find(path .. "/*.lua", "LUA")
    for _, v in ipairs(files) do
        include(path .. "/" .. v)
    end
end