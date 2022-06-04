if not EnsureRainBase then
    RBWaitList = {}
    function EnsureRainBase(callback)
        if not RainBase then
            table.insert(RBWaitList, callback)
        else
            xpcall(callback, function(err)
                RainBase.Logging.Warn("Failed to call EnsureRainBase callback.", "\n", Color(255, 63, 63), err, "\n", debug.traceback())
            end)
        end
    end
end