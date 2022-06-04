include("rainbase/sh_init.lua")

if SERVER then
    include("rainbase/init.lua")

    AddCSLuaFile("rainbase/sh_init.lua")
    AddCSLuaFile("rainbase/cl_init.lua")
    AddCSLuaFile("rainbase/loader.lua")
end

if CLIENT then
    include("rainbase/cl_init.lua")
end

-- Call WaitForRainBase callbacks.
for _, v in pairs(RBWaitList) do
    xpcall(v, function(err)
        RainBase.Logging.Error("Failed to call WaitForRainBase callback.", err)
    end)
end