RainBase.Util.AddCSLuaDir("rainbase/modules")
RainBase.Util.AddCSLuaDir("rainbase/modules/client")

RainBase.Logging.Info("Loading RainBase server side modules...")
RainBase.Util.IncludeDir("rainbase/modules/server", function(lua)
    RainBase.Logging.Info("Loading ", lua)
end)
RainBase.Logging.Info("RainBase server side modules loaded.")