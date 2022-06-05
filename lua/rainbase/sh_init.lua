RainBase = {}
RainBase._VERSION_ = "0.0.1"

print("///// RainBase /////")
print("/// Version")
print("// v" .. RainBase._VERSION_)
print("/// Environment")
print("// " .. (SERVER and "Server" or "Client"))
print("/// Initializing")
print("// ConVars")

RainBase.ConVars = {}

RainBase.ConVars.Debug = CreateConVar("rb_debug", 0, FCVAR_NONE, "Enable RainBase debug mode.", 0, 1)

print("/// Loading Modules")

local files = file.Find("rainbase/modules/*.lua", "LUA")
for _, v in ipairs(files) do
    include("rainbase/modules/" .. v)
    print("// " .. v)
end

print("/// By  RainPlus ///")
print("////////////////////")