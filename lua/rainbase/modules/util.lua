RainBase.Util = {}

if SERVER then
    function RainBase.Util.AddCSLuaDir(path, callback)
        local files = file.Find(path .. "/*.lua", "LUA")
        for _, v in ipairs(files) do
            local succ, cbResult = true, true
            if callback then
                succ, cbResult = xpcall(callback, function(err)
                    RainBase.Logging.Warn("Failed to call AddCSLuaDir callback.", "\n", Color(255, 63, 63), err, "\n", debug.traceback())
                end, v)
            end
            if not succ or cbResult ~= false then
                AddCSLuaFile(path .. "/" .. v)
            end
        end
    end
end

function RainBase.Util.IncludeDir(path, callback)
    local files = file.Find(path .. "/*.lua", "LUA")
    for _, v in ipairs(files) do
        local succ, cbResult = true, true
        if callback then
            succ, cbResult = xpcall(callback, function(err)
                RainBase.Logging.Warn("Failed to call IncludeDir callback.", "\n", Color(255, 63, 63), err, "\n", debug.traceback())
            end, v)
        end
        if not succ or cbResult ~= false then
            include(path .. "/" .. v)
        end
    end
end